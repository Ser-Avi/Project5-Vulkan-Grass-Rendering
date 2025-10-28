Vulkan Grass Rendering
==================================

**University of Pennsylvania, CIS 565: GPU Programming and Architecture, Project 5**

&nbsp;Avi Serebrenik

&nbsp;\* [LinkedIn](https://www.linkedin.com/in/avi-serebrenik-a7386426b), [Personal Website](https://aviserebrenik.wixsite.com/cvsite)

&nbsp;\* Tested on: Windows 11, i7-13620H @ 2.4GHz 32GB, RTX 4070 8GB (Laptop)

## Overview
<p align="center">
  <img width="100%" alt="image" src="Gif.gif" />
  <br>
  <em>Around 65000 tessalated grass blades blowing in the wind</em>
</p>

This grass simulation was built in Vulkan using a pipeline with a compute shader for force and culling evaluation and tessellation shaders to provide nice grass detail dynamically on the GPU for fast, large scenes. The 

The grass blades are created on the CPU as merely four vec4s: base, tip, a middle control point, and an up vector, which also contain information about direction, width, height, and stiffness in their 4th value.
These values are randomized within a realistic range, and then they are passed to the compute shader, which applies wind, gravity, and recovery forces, allowing for nice, realistic movement and look.
The compute shader also culls blades based on distance, orientation, and whether they're in the camera frustrum, optimizing performance before we pass these blades to the render pass.
Next, in the render pass, the values are simply multiplied by a model matrix in the vertex shader before being passed to the tessellation shaders.
The tessellation shaders then use our three given values to create a finer tessellated mesh dynamically on the GPU. To get nice curves for the blades, the middle control point is used in a Bezier curve
evaluation of the grass blade (together with the base and tip). The results speak for themselves.
Finally, in the fragment shader, the blades are simply colored with a Lambertian light evaluation.

The detailed methods and performance analysis of the project are below.

## Methods

The grass blade and Vulkan pipeline initialization are quite standard, and can be seen in the Blade.h and Blade.cpp files and the Renderer.cpp file, respectively. However, importantly, there are two buffers storing the grass blades. One, which is used to keep track of all blades, so that animation can persist from frame to frame even on culled blades, and a second, which only carries forward the blades that we currently want to render in the scene. These get evaluated in the compute shader.

The **Compute Shader** does the following in parallel on each grass blade:
  1. Compute wind flow using physically based Gerstner Waves for smooth water-like flow.
  2. Compute gravitational pull (which is statically 9.8 acceleration downwards, but can be adjusted for other scenes).
  3. Compute recovery force, which uses grass stiffness to make sure that the blades don't fall down from the gravity or get completely blown away.
  4. Resolve these forces on each grass blade.
  5. Cull grass blades based on orientation to the camera, distance from the camera, and whether they're in the camera's viewing frustrum.



Next, in the rendering pass,
