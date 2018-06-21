#version 330

#include "/inc/matrices.glsl"

layout(location=0) in vec4 a_Vertex;
layout(location=8) in vec4 a_MultiTexCoord0;

out vec4 texcoord;

void main()
{
  gl_Position = MAT_Screen_Normalized * a_Vertex;
  texcoord = a_MultiTexCoord0;
}
