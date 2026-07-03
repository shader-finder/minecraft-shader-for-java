#version 150 core

// Ultra Realistic Iris Shader - Composite Pass (FIXED)
// Main lighting and compositing pass

in vec2 texCoord;

uniform sampler2D colortex0;   // Albedo
uniform sampler2D colortex1;   // Normal data
uniform sampler2D colortex2;   // Depth texture
uniform sampler2D depthtex0;   // Depth

uniform sampler2D shadow;      // Shadow map

uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;

uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform float viewWidth;
uniform float viewHeight;
uniform float far;
uniform float near;

uniform vec3 sunPosition;
uniform float sunAngle;
uniform float rainStrength;

// Custom uniforms
uniform float shadowDistance;
uniform float giQuality;
uniform float aoStrength;
uniform float blockLightStrength;
uniform float skyLightStrength;
uniform bool waterShadowDisable;
uniform float bloomStrength;
uniform bool colorGrading;

out vec4 outColor;

const float PI = 3.14159265359;

// Depth reconstruction
float getLinearDepth(float depth) {
    return (2.0 * near * far) / (far + near - (2.0 * depth - 1.0) * (far - near));
}

// Normal decode
vec3 decodeNormal(vec3 encoded) {
    return normalize(encoded * 2.0 - 1.0);
}

// Simple shadow function
float sampleShadowSimple(vec3 shadowCoord) {
    if (shadowCoord.z > 1.0) return 1.0;
    
    float shadow = 0.0;
    float texelSize = 1.0 / 2048.0;
    
    // Simple 4x4 PCF
    for (int x = -2; x <= 1; x++) {
        for (int y = -2; y <= 1; y++) {
            float depth = texture(shadow, shadowCoord.xy + vec2(x, y) * texelSize).r;
            if (shadowCoord.z - 0.005 < depth) {
                shadow += 1.0;
            }
        }
    }
    
    return shadow / 16.0;
}

void main() {
    // Sample textures
    vec4 color = texture(colortex0, texCoord);
    vec4 normalData = texture(colortex1, texCoord);
    float depth = texture(depthtex0, texCoord).r;
    
    // Early exit for sky
    if (depth > 0.99) {
        outColor = vec4(0.6, 0.8, 1.0, 1.0); // Sky color
        return;
    }
    
    vec3 normal = decodeNormal(normalData.rgb);
    vec3 albedo = color.rgb;
    bool isWater = color.a < 0.1; // Water detection
    
    // Reconstruct world position
    vec3 fragPos = vec3(texCoord * 2.0 - 1.0, depth * 2.0 - 1.0);
    
    // Basic lighting
    vec3 lightDir = normalize(vec3(0.8, 0.6, 0.5)); // Sun direction
    float NdotL = max(dot(normal, lightDir), 0.0);
    
    // Shadow calculation
    vec4 shadowCoord = shadowProjection * (shadowModelView * vec4(fragPos, 1.0));
    shadowCoord = shadowCoord * 0.5 + 0.5;
    
    float shadow = 1.0;
    if (!isWater || !waterShadowDisable) {
        shadow = sampleShadowSimple(shadowCoord);
    } else if (isWater && waterShadowDisable) {
        shadow = 1.0; // No shadows on water
    }
    
    // Direct lighting
    vec3 directLight = vec3(0.8) * NdotL * shadow;
    
    // Ambient lighting
    vec3 ambientLight = vec3(0.3, 0.35, 0.4) * giQuality;
    
    // Combine
    vec3 finalColor = albedo * (directLight + ambientLight);
    
    // Add bloom
    float brightness = dot(finalColor, vec3(0.299, 0.587, 0.114));
    finalColor += albedo * max(0.0, brightness - 0.8) * bloomStrength * 0.3;
    
    // Rain effect
    float rain = sin(texCoord.x * 100.0) * 0.5 + 0.5;
    finalColor = mix(finalColor, vec3(0.9), rain * rainStrength * 0.1);
    
    // Tone mapping
    finalColor = finalColor / (finalColor + vec3(1.0));
    
    outColor = vec4(finalColor, 1.0);
}
