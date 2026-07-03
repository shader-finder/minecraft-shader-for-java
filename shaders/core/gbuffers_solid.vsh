#version 150 core

in vec3 vaPosition;
in vec2 vaUV0;
in vec4 vaColor;

uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;

out vec2 texCoord;
out vec4 vertexColor;

void main() {
    gl_Position = gbufferProjection * (gbufferModelView * vec4(vaPosition, 1.0));
    texCoord = vaUV0;
    vertexColor = vaColor;
}
