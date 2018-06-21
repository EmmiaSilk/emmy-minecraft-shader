#ifndef INCLUDE_MATRIXES
#define INCLUDE_MATRIXES INCLUDE_MATRIXES

// Replacement for model view matrix
const mat4 MAT_Screen_Normalized = mat4(
  vec4(2, 0, 0, 0),
  vec4(0, 2, 0, 0),
  vec4(0, 0, 2, 0),
  vec4(-1, -1, -1, 1));

const mat4 MAT_Shadow_Normalized = mat4(
  vec4(0.5, 0,   0, 0),
  vec4(0,   0.5, 0, 0),
  vec4(0,   0,   0.5, 0),
  vec4(0.5, 0.5, 0.5, 1)
  );

#endif
