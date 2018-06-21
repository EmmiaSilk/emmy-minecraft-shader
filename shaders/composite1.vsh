#version 330
// INCLUDES
#include "/inc/matrices.glsl"
// END INCLUDES

layout(location=0) in vec4 a_Vertex;
layout(location=8) in vec4 a_MultiTexCoord0;

out vec2 texcoord;

void main()
{
  gl_Position = MAT_Screen_Normalized * a_Vertex;

  texcoord = (a_MultiTexCoord0).st;
  texcoord.x = texcoord.x;
}
