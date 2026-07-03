#version 150 core

// Ultra Realistic Iris Shader - Solid Vertex Shader

in vec3 vaPosition;
in vec2 vaUV0;
in vec3 vaNormal;
in vec4 vaColor;

out vec3 vNormal;
out vec2 vTexCoord;
out vec3 vTangent;
out vec3 vBitangent;
out vec4 vBlockLight;
out vec4 vSkyLight;

uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;

void main() {
    gl_Position = gbufferProjection * (gbufferModelView * vec4(vaPosition, 1.0));
    
    vTexCoord = vaUV0;
    vNormal = mat3(gbufferModelView) * vaNormal;
    
    // Compute tangent and bitangent for normal mapping
    vTangent = normalize(cross(vNormal, vec3(0.0, 1.0, 0.0)));
    vBitangent = cross(vNormal, vTangent);
    
    // Light levels from vertex color
    vBlockLight = vaColor;
    vSkyLight = vaColor;
}
