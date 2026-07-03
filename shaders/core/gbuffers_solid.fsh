#version 150 core

in vec2 texCoord;
in vec4 vertexColor;

uniform sampler2D texture;

layout(location = 0) out vec4 colortex0;
layout(location = 1) out vec4 colortex1;
layout(location = 2) out vec4 colortex2;
layout(location = 3) out vec4 colortex3;

void main() {
    vec4 texColor = texture(texture, texCoord) * vertexColor;
    
    if (texColor.a < 0.5) discard;
    
    colortex0 = texColor;
    colortex1 = vec4(0.5, 0.5, 1.0, 1.0);
    colortex2 = vec4(0.0);
    colortex3 = vec4(0.0);
}
