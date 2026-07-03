#version 150 core

// Ultra Realistic Iris Shader - Composite Pass V2
// Simplified for maximum compatibility

in vec2 texCoord;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D depthtex0;
uniform sampler2D shadow;

uniform float viewWidth;
uniform float viewHeight;

out vec4 outColor;

void main() {
    // Sample color and depth
    vec4 color = texture(colortex0, texCoord);
    vec4 normalData = texture(colortex1, texCoord);
    float depth = texture(depthtex0, texCoord).r;
    
    // Sky rendering
    if (depth > 0.99) {
        outColor = vec4(0.6, 0.8, 1.0, 1.0);
        return;
    }
    
    // Basic lighting
    vec3 normal = normalize(normalData.rgb * 2.0 - 1.0);
    vec3 lightDir = normalize(vec3(1.0, 1.0, 0.8));
    
    float diffuse = max(dot(normal, lightDir), 0.0);
    vec3 finalColor = color.rgb * (0.3 + diffuse * 0.7);
    
    // Output
    outColor = vec4(finalColor, 1.0);
}
