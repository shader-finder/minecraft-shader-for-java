#version 150 core

// Ultra Realistic Iris Shader - Shadow Pass Vertex Shader

in vec3 vaPosition;
in vec2 vaUV0;
in vec4 vaColor;

out vec2 texCoord;
out vec4 vColor;

uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

void main() {
    gl_Position = shadowProjection * (shadowModelView * vec4(vaPosition, 1.0));
    texCoord = vaUV0;
    vColor = vaColor;
}
