#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
    vec3 eye;
} camera;

// TODO: Declare fragment shader inputs
layout(location = 0) in vec3 fs_pos;
layout(location = 1) in vec3 fs_nor;
layout(location = 2) in vec2 fs_uv;

layout(location = 0) out vec4 outColor;

void main() {
    // TODO: Compute fragment color
    vec3 lightDir = normalize(vec3(4.5, 6.5, -1.5));
    vec3 green = vec3(0.2, 0.8, 0.2);
    float light = max(0.3, abs(dot(fs_nor, lightDir)));
    outColor = vec4(green * light, 1.0);

    //outColor = vec4(1.0, 0.0, 0.0, 1.0);
}
