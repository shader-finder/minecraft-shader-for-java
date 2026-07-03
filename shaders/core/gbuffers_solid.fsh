#version 150 core

// Ultra Realistic Iris Shader - Solid G-Buffer Pass
// Captures geometry data: albedo, normals, roughness, metallic

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
layout(location = 1) out vec4 colortex1; // Normal + Light
layout(location = 2) out vec4 colortex2; // Specular + Roughness
layout(location = 3) out vec4 colortex3; // Material data

void main() {
    // Sample textures
    vec4 albedoSample = texture(texture, vTexCoord);
    vec3 normalSample = texture(normals, vTexCoord).rgb;
    vec3 specularSample = texture(specular, vTexCoord).rgb;
    
    // Discard transparent pixels
    if (albedoSample.a < 0.5) discard;
    
    // Decode normal from normal map
    vec3 normalFromMap = normalize(normalSample * 2.0 - 1.0);
    
    // Create TBN matrix for normal mapping
    mat3 tbn = mat3(normalize(vTangent), normalize(vBitangent), normalize(vNormal));
    vec3 finalNormal = normalize(tbn * normalFromMap);
    
    // Encode normal
    vec3 encodedNormal = finalNormal * 0.5 + 0.5;
    
    // Output
    colortex0 = vec4(albedoSample.rgb, 1.0);
    colortex1 = vec4(encodedNormal, max(vBlockLight.a, vSkyLight.a)); // Normal + light level
    colortex2 = vec4(specularSample, 1.0 - length(normalSample - 0.5) * 0.5); // Specular + roughness
    colortex3 = vec4(0.0); // Material data (metallic, etc.)
}
