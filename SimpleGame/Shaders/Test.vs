#version 330

in vec3 a_Position;
in vec4 a_Color;

out vec4 v_Color;

uniform float u_Time;

void main()
{
	float value = fract(u_Time) * 2 - 1; // -1 ~ 1

	vec4 newPosition = vec4(a_Position, 1);
	// newPosition.xy = newPosition.xy - vec2(0.5);
	newPosition.xy = newPosition.xy + vec2(value, 0);
	

	gl_Position = newPosition;
	v_Color = a_Color;
}
