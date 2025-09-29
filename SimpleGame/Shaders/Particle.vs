#version 330

// attribute로 in으로 받는거 -> Per Vertex Data
in vec3 a_Position;
in float a_Radius;
in vec4 a_Color;
in float a_STime;
in vec3 a_Vel;
in float a_LifeTime;
in float a_Mass;

out vec4 v_Color;

// 전체 쉐이더에 동일한 데이터 -> Per Shader Data
uniform float u_Time;
uniform vec3 u_Force;

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

		float forceX = u_Force.x * 20 + c_G.x * a_Mass;
		float forceY = u_Force.y + c_G.y * a_Mass;

		float aX = forceX / a_Mass;
		float aY = forceY / a_Mass;

		float x = a_Vel.x * t + 0.5 * aX * tt; 
		float y = a_Vel.y * t + 0.5 * aY * tt; 

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
