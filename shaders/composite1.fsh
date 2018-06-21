#version 330

in vec2 texcoord;

uniform sampler2D colortex0;

/* DRAWBUFFERS:0 */
layout(location=0) out vec4 cColor;

void main()
{
  /* code */
  vec4 color = texture(colortex0, texcoord);
  cColor = color;
}
