#version 150 core

// Ultra Realistic Iris Shader - Water Vertex Shader

in vec3 vaPosition;
in vec2 vaUV0;
in vec3 vaNormal;
in vec4 vaColor;

out vec3 vNormal;
out vec2 vTexCoord;
out vec3 vViewPos;
out vec4 vBlockLight;

uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;

void main() {
    gl_Position = gbufferProjection * (gbufferModelView * vec4(vaPosition, 1.0));
    
    vTexCoord = vaUV0;
    vNormal = mat3(gbufferModelView) * vaNormal;
    vViewPos = (gbufferModelView * vec4(vaPosition, 1.0)).xyz;
    vBlockLight = vaColor;
}
