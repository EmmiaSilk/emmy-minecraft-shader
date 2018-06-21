#ifndef INCLUDE_MATH_UTILS
#define INCLUDE_MATH_UTILS INCLUDE_MATH_UTILS

float LinearDepthCompressed (float z, float near, float far) {
  return (2.0 * near) / (far + near - z * (far - near));
}

/*
 *
 */
 float LinearDepth (float z, float near, float far) {
   return LinearDepthCompressed(z, near, far) * far;
 }

 vec4 sobel(sampler2D tex, vec2 coord, vec2 texelScale) {
  vec4 n[9];

  n[0] = texture2D(tex, coord + vec2(-texelScale.x, -texelScale.y));
  n[1] = texture2D(tex, coord + vec2( 0           , -texelScale.y));
  n[2] = texture2D(tex, coord + vec2( texelScale.x, -texelScale.y));
  n[3] = texture2D(tex, coord + vec2(-texelScale.x,  0           ));
  n[4] = texture2D(tex, coord + vec2( 0           ,  0           ));
  n[5] = texture2D(tex, coord + vec2( texelScale.x,  0           ));
  n[6] = texture2D(tex, coord + vec2(-texelScale.x,  texelScale.y));
  n[7] = texture2D(tex, coord + vec2( 0           ,  texelScale.y));
  n[8] = texture2D(tex, coord + vec2( texelScale.x,  texelScale.y));

  vec4 sobel_edge_h = n[2] + (2.0*n[5]) + n[8] - (n[0] + (2.0*n[3]) + n[6]);
  vec4 sobel_edge_v = n[0] + (2.0*n[1]) + n[2] - (n[6] + (2.0*n[7]) + n[8]);

  return sqrt((sobel_edge_h * sobel_edge_h) + (sobel_edge_v * sobel_edge_v));
 }

#endif
