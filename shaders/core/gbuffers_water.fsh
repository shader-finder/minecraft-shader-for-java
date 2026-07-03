#version 150 core

// Ultra Realistic Iris Shader - Water G-Buffer Pass (FIXED)

in vec3 vNormal;
in vec2 vTexCoord;
in vec3 vViewPos;
in vec4 vBlockLight;

uniform sampler2D texture;
uniform float frameTime;

layout(location = 0) out vec4 colortex0; // Water color
layout(location = 1) out vec4 colortex1; // Normal + flag
layout(location = 2) out vec4 colortex2; // Caustics
layout(location = 3) out vec4 colortex3; // Material

const float PI = 3.14159265359;

// Generate water waves
vec3 generateWaterWaves(vec2 uv, float time) {
    vec2 wave1 = sin(uv * 3.0 + time * 0.5) * 0.05;
    vec2 wave2 = sin(uv * 1.5 - time * 0.3) * 0.03;
    
    vec3 normal = normalize(vec3(wave1 + wave2, 1.0));
    return normal;
}

// Water caustics
vec3 generateCaustics(vec2 uv, float time) {
    float caustic = sin(uv.x * 4.0 + time) * cos(uv.y * 4.0 + time * 0.7);
    caustic = abs(sin(caustic * PI)) * 0.5 + 0.5;
    return vec3(caustic);
}

void main() {
    vec4 waterColor = vec4(0.1, 0.4, 0.6, 0.8);
    
    // Generate water waves
    vec3 waveNormal = generateWaterWaves(vTexCoord, frameTime);
    
    // Generate caustics
    vec3 caustics = generateCaustics(vTexCoord, frameTime);
    
    // Encode normal
    vec3 encodedNormal = waveNormal * 0.5 + 0.5;
    
    // Output - Alpha = 0 signals NO SHADOW for water
    colortex0 = vec4(waterColor.rgb * 0.8 + caustics * 0.2, 0.0); // Alpha = 0 = water, no shadow
    colortex1 = vec4(encodedNormal, 0.0);
    colortex2 = vec4(caustics, 1.0);
    colortex3 = vec4(0.0);
}
