#version 150 core

in vec2 texCoord;

uniform sampler2D texture;
uniform float frameTime;

layout(location = 0) out vec4 colortex0;
layout(location = 1) out vec4 colortex1;
layout(location = 2) out vec4 colortex2;
layout(location = 3) out vec4 colortex3;

void main() {
    vec4 waterColor = vec4(0.1, 0.4, 0.6, 0.3);
    
    colortex0 = waterColor;
    colortex1 = vec4(0.5, 0.5, 1.0, 0.5);
    colortex2 = vec4(0.0);
    colortex3 = vec4(0.0);
}
