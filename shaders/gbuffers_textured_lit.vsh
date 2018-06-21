#version 330 compatibility

// Vertex attributes
in vec4 at_tangent;
layout (location=0) in vec4 at_Vertex;
layout (location=2) in vec4 at_Normal;
layout (location=3) in vec4 at_Color;
layout (location=8) in vec4 at_MultiTexCoord0;
layout (location=9) in vec4 at_MultiTexCoord1;

uniform vec3 cameraPosition;

out vec4 v_color;
out vec4 v_lightmapCoord;
out vec4 v_texcoord;
out vec4 v_normal;
// No uniforms for: gl_ModelViewMatrix and gl_ModelViewProjectionMatrix
mat4 m_ModelViewProjectionMatrix = gl_ModelViewProjectionMatrix;

void main() {

	v_texcoord = gl_TextureMatrix[0] * at_MultiTexCoord0;
	v_lightmapCoord = gl_TextureMatrix[1] * at_MultiTexCoord1;
	v_normal = at_Normal;
	v_color = at_Color;
	gl_Position = gl_ModelViewProjectionMatrix * at_Vertex;
	gl_FogFragCoord = gl_Position.z;

}
