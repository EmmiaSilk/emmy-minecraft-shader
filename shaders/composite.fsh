#version 330
const int shadowMapResolution = 4096;
const int noiseTextureResolution = 256;
// const float shadowMapFov = 90.0;
const int RGBA16 = 1;
const int gcolorFormat = RGBA16;

// INCLUDES
#include "/inc/math_utils.glsl"
#include "/inc/space_utils.glsl"
// END INCLUDES

// Shadow stuff
uniform sampler2D shadowtex0;

// Noise
uniform sampler2D noisetex;
uniform float viewWidth;
uniform float viewHeight;

in vec2 texcoord;

uniform sampler2D colortex0;
uniform sampler2D gnormal;
uniform sampler2D depthtex0;
uniform sampler2D gaux1;

uniform float near;
uniform float far;

#define RANDOM_MULT 0.75
#define SHADOW_BIAS 0.0005
#define SHADOW_SAMPLES 1 // [1 2 3]
const int SHADOW_SAMPLE_FIRST = (-SHADOW_SAMPLES+1);
const int SHADOW_SAMPLE_LAST = (+SHADOW_SAMPLES-1);
const float sunPathRotation = 0.1f;

/* DRAWBUFFERS:012 */
layout(location=0) out vec4 cColor;
layout(location=1) out vec4 cDepth;
layout(location=2) out vec4 cNormal;
layout(location=4) out vec4 cMaterial;

mat2 getRotationMatrix(vec2 coord) {
  float rotationAmount = texture(
    noisetex,
    coord * vec2(
      viewWidth / noiseTextureResolution,
      viewHeight / noiseTextureResolution
      )
    ).r * RANDOM_MULT;

  return mat2(
      cos(rotationAmount), -sin(rotationAmount),
      sin(rotationAmount), cos(rotationAmount)
    );
}

int getShadowViability(float depth) {
  // No shadows on the sky
  if(depth < 1) {
    return 1;
  }

  else {
    return 0;
  }
}

float getSunVisibility(vec2 screenCoord, float depth) {
  if(getShadowViability(depth) == 0) {
    return 1;
  }

  vec3 shadowCoord = ShadowSpace_From_Screencoords(screenCoord, depth);

  float visibility = 0;
  mat2 rotationMatrix = getRotationMatrix(screenCoord);
  for(int x = SHADOW_SAMPLE_FIRST; x <= SHADOW_SAMPLE_LAST; x++) {
    for(int y = SHADOW_SAMPLE_FIRST; y <= SHADOW_SAMPLE_LAST; y++) {
      vec2 offset = (vec2(x, y) / shadowMapResolution / SHADOW_SAMPLES);
      offset = rotationMatrix * offset;
      float shadowMapSample = texture(shadowtex0, shadowCoord.st + offset).r;
      visibility += step(shadowCoord.z - shadowMapSample, SHADOW_BIAS);
    }
  }

  return visibility / exp2((SHADOW_SAMPLES*2)-1);

}

void main()
{
  vec4 depth = texture(depthtex0, texcoord);
  float newdepth = LinearDepthCompressed(depth.x, near, far);
  cDepth = vec4(vec3(newdepth), 1);

  // Color
  vec4 albedo = texture(colortex0, texcoord);

  float sunVisibility = getSunVisibility(texcoord, depth.x) * 0.75;
  // sunVisibility = 0;
  float ambient = 0.3;
  vec4 sunlight_color = albedo * (sunVisibility + ambient);

  vec4 color = sunlight_color;
  // color = albedo;
  cColor = color;

  // Normals
  vec4 normals = texture(gnormal, texcoord);
  cNormal = normals;

  // Material
  vec4 material = texture(gaux1, texcoord);
  cNormal = normals;
}
