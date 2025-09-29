#version 330

in vec3 a_Position;
in float a_Radius;
in vec4 a_Color;
in float a_STime;
in vec3 a_Vel;
in float a_LifeTime;

out vec4 v_Color;

uniform float u_Time;

const float c_PI = 3.141592;
const vec2 c_G = vec2(0, -9.8);

void main()
{
	float newAlpha = 1.0;
	vec4 newPosition = vec4(a_Position, 1);
	float newTime = u_Time - a_STime;
	if ( newTime > 0)
	{
		float t = fract(newTime / a_LifeTime) * a_LifeTime * 3;  // t: 0 ~ lifeTime
		float tt = t * t;	

		float x = a_Vel.x * t + 0.5 * c_G.x * tt; 
		float y = a_Vel.y * t + 0.5 * c_G.y * tt; 

		newPosition.xy += vec2(x, y);
		newAlpha = 1.0 - t/a_LifeTime; // 1~0
	}
	else 
	{
		newPosition.xy = vec2(-100000, 0);		
	}

	gl_Position = newPosition;
 

	v_Color = vec4(a_Color.rgb, newAlpha);
}
