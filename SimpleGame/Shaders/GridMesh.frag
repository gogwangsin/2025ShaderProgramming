#version 330

layout(location=0) out vec4 FragColor;

in vec4 v_Color;

void main()
{
	float thi;

	FragColor = v_Color;

}
