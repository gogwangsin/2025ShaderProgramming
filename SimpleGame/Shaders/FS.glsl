#version 330

layout(location=0) out vec4 FragColor;

in vec2 v_UV;
// RS 지나고하면 도형이 차지하는 화면의 픽셀만큼 들어온다.

const float c_PI = 3.141592;

void main()
{
	vec4 newColor = vec4(0);
	
//	float xValue = sin(v_UV.x * 2 * c_PI * 4);
	float xValue = pow(abs(sin(v_UV.x * 2 * c_PI * 4)), 10); // 0.5도 해볼것

	newColor = vec4(vec3(xValue), 1);
	

	FragColor = newColor;
}
