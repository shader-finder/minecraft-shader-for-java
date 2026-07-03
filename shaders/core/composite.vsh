#version 150 core

// Ultra Realistic Iris Shader - Composite Vertex Shader

in vec3 vaPosition;
in vec2 vaUV0;

out vec2 texCoord;

void main() {
    gl_Position = vec4(vaPosition, 1.0);
    texCoord = vaUV0;
}
