#version 150 core

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D depthtex0;

in vec2 texCoord;

out vec4 outColor;

void main() {
    vec4 color = texture(colortex0, texCoord);
    outColor = vec4(color.rgb, 1.0);
}
