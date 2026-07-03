#version 150 core

// Ultra Realistic Iris Shader - Composite Pass
// Main lighting and compositing pass

in vec2 texCoord;

uniform sampler2D colortex0;   // Main color
uniform sampler2D colortex1;   // Normal + material data
uniform sampler2D colortex2;   // Depth texture
uniform sampler2D colortex3;   // Specular
uniform sampler2D shadow;      // Shadow map
uniform sampler2D depthtex0;   // Depth

uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;

uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform float viewWidth;
uniform float viewHeight;
uniform float near;
uniform float far;

uniform vec3 sunPosition;
uniform vec3 moonPosition;
uniform vec3 upPosition;
uniform float sunAngle;

uniform float rainStrength;
uniform float wetness;
uniform float isNight;

uniform int frameCounter;
uniform float frameTime;

// Custom uniforms from shaders.properties
uniform float shadowDistance;
uniform float shadowMapResolution;
uniform int shadowSamples;
uniform float shadowBias;
uniform float giQuality;
uniform float aoStrength;
uniform float blockLightStrength;
uniform float skyLightStrength;
uniform bool waterShadowDisable;
uniform float waterReflectionQuality;
uniform float rainQuality;
uniform bool rainSplash;
uniform float bloomStrength;
uniform bool colorGrading;
uniform float depthOfField;
uniform float normalMapDetail;

out vec4 outColor;

// Constants
const float PI = 3.14159265359;
const float TAU = 6.28318530718;

// Depth reconstruction
float getLinearDepth(float depth) {
    return (2.0 * near * far) / (far + near - (2.0 * depth - 1.0) * (far - near));
}

// Normal decoding
vec3 decodeNormal(vec3 normal) {
    return normalize(normal * 2.0 - 1.0);
}

// Shadow sampling with PCF (Percentage Closer Filtering)
float sampleShadow(vec3 shadowCoord, vec3 normal, vec3 lightDir) {
    float shadow = 0.0;
    float texelSize = 1.0 / shadowMapResolution;
    
    // PCF sampling
    for (int x = -shadowSamples/2; x <= shadowSamples/2; x++) {
        for (int y = -shadowSamples/2; y <= shadowSamples/2; y++) {
            float closestDepth = texture(shadow, shadowCoord.xy + vec2(x, y) * texelSize).r;
            float currentDepth = shadowCoord.z - shadowBias;
            shadow += currentDepth > closestDepth ? 0.0 : 1.0;
        }
    }
    
    shadow /= float(shadowSamples * shadowSamples);
    return shadow;
}

// Water shadow disabling
bool isWater(vec4 colorData) {
    // Check if material is water based on color or alpha
    return colorData.a < 0.5; // Simplified check
}

// Realistic shadow calculation
float calculateShadow(vec3 fragPos, vec3 normal, vec3 lightDir, bool isWaterSurface) {
    if (isWaterSurface && waterShadowDisable) {
        return 1.0; // No shadows on water
    }
    
    vec4 shadowCoord = shadowProjection * (shadowModelView * vec4(fragPos, 1.0));
    shadowCoord /= shadowCoord.w;
    shadowCoord = shadowCoord * 0.5 + 0.5;
    
    if (shadowCoord.z > 1.0) return 1.0;
    
    // NdotL for surface facing
    float NdotL = max(dot(normal, lightDir), 0.0);
    float bias = max(shadowBias * (1.0 - NdotL), shadowBias * 0.1);
    
    return sampleShadow(shadowCoord, normal, lightDir);
}

// Global Illumination (simplified)
vec3 calculateGI(vec3 fragPos, vec3 normal, vec3 albedo) {
    vec3 up = normalize(upPosition);
    float skyLightFactor = max(0.0, dot(normal, up)) * skyLightStrength;
    
    // Indirect lighting based on sky angle
    vec3 skyColor = mix(vec3(0.1, 0.3, 0.8), vec3(0.9, 0.8, 0.7), sunAngle);
    return skyColor * skyLightFactor * giQuality * albedo;
}

// Ambient Occlusion approximation
float calculateAO(vec3 normal) {
    // Simplified AO based on normal direction
    return mix(1.0, 0.6, aoStrength * (1.0 - max(0.0, dot(normal, upPosition))));
}

// Realistic rain effect
vec3 applyRain(vec3 color, vec2 texCoord, float depth) {
    if (rainStrength < 0.01) return color;
    
    float rain = sin(texCoord.x * 100.0 + frameTime * 5.0) * 0.5 + 0.5;
    rain *= sin(texCoord.y * 100.0 - frameTime * 3.0) * 0.5 + 0.5;
    rain = smoothstep(0.4, 0.6, rain);
    
    vec3 rainColor = vec3(0.95);
    float rainAlpha = rainStrength * rain * rainQuality;
    
    return mix(color, rainColor, rainAlpha * 0.3);
}

// Bloom effect
vec3 applyBloom(vec3 color) {
    float brightness = dot(color, vec3(0.299, 0.587, 0.114));
    vec3 bloom = color * max(0.0, brightness - 0.9) * bloomStrength;
    return color + bloom;
}

// Color grading
vec3 applyColorGrading(vec3 color) {
    // Cinematic color grading
    color = pow(color, vec3(1.0 / 2.2)); // Apply gamma
    
    // Teal and orange grading
    float luminance = dot(color, vec3(0.299, 0.587, 0.114));
    vec3 tealOrange = mix(vec3(0.1, 0.4, 0.5), vec3(1.0, 0.6, 0.2), luminance);
    
    color = mix(color, tealOrange, colorGrading ? 0.2 : 0.0);
    
    return color;
}

void main() {
    vec4 colorData = texture(colortex0, texCoord);
    vec4 normalData = texture(colortex1, texCoord);
    vec4 specularData = texture(colortex3, texCoord);
    float depth = texture(depthtex0, texCoord).r;
    
    vec3 normal = decodeNormal(normalData.rgb);
    vec3 albedo = colorData.rgb;
    
    float linearDepth = getLinearDepth(depth);
    
    // Reconstruct world position
    vec3 fragPos = vec3(texCoord * 2.0 - 1.0, linearDepth);
    
    // Light direction (sun)
    vec3 lightDir = normalize(sunPosition);
    
    // Check if water surface
    bool isWaterSurface = isWater(colorData);
    
    // Calculate shadows
    float shadow = calculateShadow(fragPos, normal, lightDir, isWaterSurface);
    
    // Calculate lighting
    float NdotL = max(dot(normal, lightDir), 0.0);
    vec3 directLight = vec3(1.0) * NdotL * shadow;
    
    // Global Illumination
    vec3 indirectLight = calculateGI(fragPos, normal, albedo);
    
    // Ambient Occlusion
    float ao = calculateAO(normal);
    
    // Block light contribution
    float blockLight = normalData.a * blockLightStrength;
    
    // Combine lighting
    vec3 finalColor = albedo * (directLight + indirectLight + blockLight) * ao;
    
    // Apply specular
    vec3 viewDir = normalize(-fragPos);
    vec3 halfDir = normalize(lightDir + viewDir);
    float spec = pow(max(dot(normal, halfDir), 0.0), 32.0) * specularData.r;
    finalColor += vec3(1.0) * spec * shadow * 0.5;
    
    // Apply rain effect
    finalColor = applyRain(finalColor, texCoord, linearDepth);
    
    // Apply bloom
    finalColor = applyBloom(finalColor);
    
    // Apply color grading
    finalColor = applyColorGrading(finalColor);
    
    // Fog effect
    float fogDistance = mix(100.0, 200.0, sunAngle);
    float fogFactor = exp(-linearDepth / fogDistance);
    vec3 fogColor = mix(vec3(0.2, 0.4, 0.8), vec3(0.9, 0.8, 0.7), sunAngle);
    finalColor = mix(fogColor, finalColor, fogFactor);
    
    outColor = vec4(finalColor, 1.0);
}
