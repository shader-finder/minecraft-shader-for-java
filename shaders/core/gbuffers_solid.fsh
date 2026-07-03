#version 150 core

// Ultra Realistic Iris Shader - Solid G-Buffer Pass (FIXED)

in vec3 vNormal;
in vec2 vTexCoord;
in vec3 vTangent;
in vec3 vBitangent;
in vec4 vBlockLight;
in vec4 vSkyLight;

uniform sampler2D texture;
uniform sampler2D normals;
uniform sampler2D specular;

layout(location = 0) out vec4 colortex0; // Albedo
layout(location = 1) out vec4 colortex1; // Normal
layout(location = 2) out vec4 colortex2; // Specular
layout(location = 3) out vec4 colortex3; // Material

void main() {
    // Sample textures
    vec4 albedoSample = texture(texture, vTexCoord);
    
    // Discard transparent pixels
    if (albedoSample.a < 0.5) discard;
    
    // Encode normal
    vec3 encodedNormal = normalize(vNormal) * 0.5 + 0.5;
    
    // Output
    colortex0 = vec4(albedoSample.rgb, 1.0);
    colortex1 = vec4(encodedNormal, max(vBlockLight.a, vSkyLight.a));
    colortex2 = vec4(0.5, 0.5, 0.5, 1.0); // Specular
    colortex3 = vec4(0.0);
}
