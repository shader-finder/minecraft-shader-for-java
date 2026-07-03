#version 150 core

// Ultra Realistic Iris Shader - Shadow Pass Fragment Shader

in vec2 texCoord;
in vec4 vColor;

uniform sampler2D texture;

void main() {
    vec4 colorSample = texture(texture, texCoord);
    
    // Discard transparent pixels
    if (colorSample.a < 0.5) discard;
    
    // Output depth only (depth comparison is done automatically)
    gl_FragDepth = gl_FragCoord.z;
}
