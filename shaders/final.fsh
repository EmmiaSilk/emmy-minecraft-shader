#version 330
// INCLUDES
#include "/inc/math_utils.glsl"
// END INCLUDES

#define TOON_SHADER

in vec4 texcoord;

uniform sampler2D gcolor;
uniform sampler2D depthtex0;
uniform sampler2D gdepth;
uniform sampler2D gnormal;
uniform sampler2D composite;

uniform sampler2D noisetex;
uniform sampler2D colortex4;

uniform float viewWidth;
uniform float viewHeight;

// Edge detect stroke width
#define STROKE_WIDTH_1 3.5
#define STROKE_WIDTH_2 1.0

#define EDGE_BIAS_1 0.25
#define EDGE_BIAS_2 0.02

float getEdge(vec2 texelScale, float strokeWidth, sampler2D depthTexture, sampler2D normalTexture) {
  // Strong edges
  texelScale = texelScale * strokeWidth/2;

  float edge_depth = sobel(gdepth, texcoord.st, texelScale).x;
  return edge_depth;
}


void main()
{
  vec4 color = texture2D(gcolor, texcoord.st);
  vec4 normal = texture2D(gnormal, texcoord.st);
  vec4 depth = texture2D(gdepth, texcoord.st);

  vec4 material = texture2D(colortex4, texcoord.st);

  // color = color/2 + normal;

  // Edge detect
  #ifdef TOON_SHADER
  // Thin edges
  vec2 texelScale = vec2(1/viewWidth, 1/viewHeight);

  float edge_depth = getEdge(texelScale, STROKE_WIDTH_1, gdepth, gnormal);
  if(edge_depth > EDGE_BIAS_1) {
    color.rgb = color.rgb * 0.1;
  }

  edge_depth = getEdge(texelScale, STROKE_WIDTH_2, gdepth, gnormal);
  if(edge_depth > EDGE_BIAS_2) {
    color.rgb = color.rgb * 0.5;
  }
  #endif

  gl_FragColor = color;
}
