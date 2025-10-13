#version 330

in vec3 a_Position;

out vec4 v_Color;

uniform float u_Time;

const float c_PI = 3.141592;

void main()
{
	// a_Position.x => -0.5 ~ +0.5

	vec4 newPosition = vec4(a_Position, 1);	

	float value = a_Position.x + 0.5; // 0 ~ 1

	float deltaX = 0; // sin(2 * value * c_PI);	
	float deltaY = sin(2 * value * c_PI + u_Time); // 더하면 된다.	

	newPosition += vec4(deltaX, deltaY, 0, 0);

	gl_Position = newPosition;

	v_Color = vec4(1, 1, 1, 1);
}
