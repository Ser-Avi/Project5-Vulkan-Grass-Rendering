#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation evaluation shader inputs and outputs

layout(location = 0) in vec4 tese_v1[];
layout(location = 1) in vec4 tese_v2[];
layout(location = 2) in vec4 tese_up[];

layout(location = 0) out vec3 fs_pos;
layout(location = 1) out vec3 fs_nor;
layout(location = 2) out vec2 fs_uv;

float interpParam(float u, float v, float t)
{
    return 0.5 + (u - 0.5) * (1 - (max(v - t, 0) / (1 - t)));
}

void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	// TODO: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade

    vec3 v0 = gl_in[0].gl_Position.xyz;
    vec3 v1 = tese_v1[0].xyz;
    vec3 v2 = tese_v2[0].xyz;
    vec3 up = tese_up[0].xyz;
    float angle = gl_in[0].gl_Position.w;
    float w = tese_v2[0].w;
    vec3 t1 = vec3(cos(angle), 0, sin(angle));

    vec3 a = v0 + v * (v1 - v0);
    vec3 b = v1 + v * (v2 - v1);
    vec3 c = a + v * (b - a);
    vec3 c0 = c - w * t1;
    vec3 c1 = c + w * t1;
    vec3 t0 = normalize(b - a);
    vec3 n = normalize(cross(t0, t1));

    float t = interpParam(u, v, 0.05);
    vec3 p = (1.f - t) * c0 + t * c1;
    
    gl_Position = camera.proj * camera.view * vec4(p, 1.0);

    fs_pos = p;
    fs_nor = n;
    fs_uv = vec2(u, v);
}
