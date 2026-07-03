#version 150 core

in vec3 vaPosition;
in vec2 vaUV0;

uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;

out vec2 texCoord;

void main() {
    gl_Position = gbufferProjection * (gbufferModelView * vec4(vaPosition, 1.0));
    texCoord = vaUV0;
}
