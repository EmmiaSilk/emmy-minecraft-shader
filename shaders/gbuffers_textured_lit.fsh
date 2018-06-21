#version 330 compatibility

in vec4 v_color;
in vec4 v_texcoord;
in vec4 v_lightmapCoord;
in vec4 v_normal;

// Entity textures
uniform sampler2D texture;
uniform sampler2D specular;
uniform sampler2D normals;
// World textures
uniform sampler2D lightmap;
uniform sampler2D shadow;
uniform sampler2D noisetex;


// Outputs
layout(location = 0) out vec4 gAlbedo;
layout(location = 1) out vec4 gDepth;
layout(location = 2) out vec4 gNormal;
layout(location = 3) out vec4 gComposite; // What do I use this for?
layout(location = 4) out vec4 gMaterial;
layout(location = 5) out vec4 gLightmap;
layout(location = 6) out vec4 gAux3;
layout(location = 7) out vec4 gAux4;

uniform ivec2 eyeBrightnessSmooth;


void main()
{
  vec2 texCoords = v_texcoord.st;
  // Material
  vec4 material = texture2D(specular, texCoords.st);
  gMaterial = material;

  // Brightness of objects
  vec4 albedo = texture2D(texture, texCoords.st);
  albedo = albedo * v_color;
  gAlbedo = albedo;

  // Normal
  vec4 normal = texture2D(normals, texCoords.st);
  gNormal = normal;

  // Brightness value
  vec4 brightness = texture2D(lightmap, v_lightmapCoord.st);
  brightness = brightness;
  gLightmap = brightness;

  // Depth
  float depth = gl_FragCoord.z;
  gDepth = vec4(depth, depth, depth, 1);

}
