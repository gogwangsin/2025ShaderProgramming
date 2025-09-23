#version 330

in vec3 a_Position;
in float a_Radius;
in vec4 a_Color;
in float a_STime;

out vec4 v_Color;

uniform float u_Time;

const float c_PI = 3.141592;
const vec2 c_G = vec2(0, -9.8);

void main()
{
	vec4 newPosition = vec4(a_Position, 1);
	float newTime = u_Time - a_STime;
	if ( newTime > 0)
	{
	//	float t = fract(u_Time / 2.f) * 2.f;

		float t = fract(newTime / 2.f) * 2.f;
		float tt = t * t;	
		float x = 0; 
		float y = 0.5 * c_G.y * tt; 
		newPosition.xy += vec2(x, y);
	}
	else 
	{
		newPosition.xy = vec2(-100000, 0);		
	}

	gl_Position = newPosition;

	v_Color = a_Color;
}
