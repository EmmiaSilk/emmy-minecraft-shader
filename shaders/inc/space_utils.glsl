#ifndef INCLUDE_SPACE_CONVERSIONS
#define INCLUDE_SPACE_CONVERSIONS INCLUDE_SPACE_CONVERSIONS

#include "/inc/matrices.glsl"

uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;

uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

vec4 Cameraspace_From_Screencoords(vec2 coord, float depth) {
  vec4 screenCoords = MAT_Screen_Normalized * vec4(coord.st, depth, 1.0);
  vec4 worldspace = gbufferProjectionInverse * screenCoords;

  return worldspace / worldspace.w;
}

vec4 Worldspace_From_Screencoords(vec2 coord, float depth) {
  vec4 positionCameraSpace = Cameraspace_From_Screencoords(coord, depth);
  vec4 positionWorldSpace = gbufferModelViewInverse * positionCameraSpace;
  positionWorldSpace.xyz += cameraPosition.xyz;

  return positionWorldSpace;
}

vec3 ShadowSpace_From_Screencoords(vec2 coord, float depth) {
  vec4 positionWorldSpace = Worldspace_From_Screencoords(coord, depth);
  positionWorldSpace.xyz -= cameraPosition.xyz;

  vec4 positionShadowSpace = shadowModelView * positionWorldSpace;
  positionShadowSpace = shadowProjection * positionShadowSpace;
  positionShadowSpace /= positionShadowSpace.w;
  positionShadowSpace = MAT_Shadow_Normalized * positionShadowSpace;

  return positionShadowSpace.xyz;
}

#endif
