#version 330

in vec3 a_Position;
in vec4 a_Color;

out vec4 v_Color;

uniform float u_Time;

const float c_PI = 3.141592;
const float c_Amplitude = 0.5;

void main()
{
	float value = fract(u_Time) * 2 - 1; // -1 ~ 1
	float rad = (value + 1) * c_PI;      //  0 ~ 2 // 0 ~ 2PI 
	float y = sin(rad);
	float x = cos(rad);

	// float my_y = sin(u_Time * c_PI * 2);

	vec4 newPosition = vec4(a_Position, 1);
	// newPosition.xy = newPosition.xy - vec2(0.5);
	newPosition.xy = newPosition.xy + vec2(x, y) * fract(u_Time / 2);
	

	gl_Position = newPosition;
	v_Color = a_Color;
}
