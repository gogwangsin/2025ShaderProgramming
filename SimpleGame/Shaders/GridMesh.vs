#version 330

in vec3 a_Position;

out vec4 v_Color;

uniform float u_Time;

const float c_PI = 3.141592;
const vec4 c_Points[3] = vec4[](vec4(0, 0, 3, 0.8), vec4(0.7, -0.1, 2, 1.5), vec4(-0.5, 0.3, 1, 1));

void Flag()
{
	// a_Position.x => -0.5 ~ +0.5
	vec4 newPosition = vec4(a_Position, 1);	

	float value = a_Position.x + 0.5; // 0 ~ 1

	newPosition.y = newPosition.y * (1-value); // value가 1일 때 y가 0이 된다.

	float deltaX = 0; // sin(2 * value * c_PI);	
	float deltaY = value * 0.5 * sin(2 * value * c_PI - (u_Time * 80));	
	float newColor = (sin(2 * value * c_PI - (u_Time * 20)) + 2 ) / 2;	

	newPosition += vec4(deltaX, deltaY, 0, 0);

	gl_Position = newPosition;

	v_Color = vec4(newColor);
}

void Wave()
{
	vec4 newPosition = vec4(a_Position, 1);	

	float dX = 0;
	float dY = 0;
	
	vec2 pos = vec2(a_Position.xy);
	vec2 center = vec2(0,0);
	float dis = distance(pos, center); // 거리가 가까울 수록 0에 가깝다 -> 색을 칠하면 바깥으로 갈 수록 밝아질 것 
	float v = 2 * clamp(0.5 - dis, 0, 1);

	// 0 ~ 1
	float newColor = v * sin(dis * 4 * c_PI * 10 - u_Time * 30); // 0 ~ 2PI


	newPosition += vec4(dX, dY, 0, 0);	
	gl_Position = newPosition;
	

	v_Color = vec4(newColor);
}

void RainDrop()
{
	vec4 newPosition = vec4(a_Position, 1);	

	float dX = 0;
	float dY = 0;
	
	vec2 pos = vec2(a_Position.xy);
	float newColor = 0;
	

	for(int i = 0; i < 3; ++i)
	{
		float startTime = c_Points[i].z;
		float lifeTime = c_Points[i].w;
		float newTime = u_Time - startTime;

		if( newTime > 0 )
		{
			float baseTime = fract(newTime / lifeTime);
			float oneMinus = 1 - baseTime; // 처음엔 1, 나중엔 0으로 바뀌는 애

			float t = newTime * lifeTime;
			float range = baseTime * lifeTime / 3;
			vec2 center = c_Points[i].xy;
			float dis = distance(pos, center); // 거리가 가까울 수록 0에 가깝다 -> 색을 칠하면 바깥으로 갈 수록 밝아질 것 

			float v = 20 * clamp(range - dis, 0, 1); // 2*(0~1) 
			newColor += oneMinus * v * sin(dis * 4 * c_PI * 10 - t * 20); // 0 ~ 2PI
		}

	}

	newPosition += vec4(dX, dY, 0, 0);	
	gl_Position = newPosition;
	

	v_Color = vec4(newColor);
}

void main()
{
	// Flag();
	// Wave();
	RainDrop();
}