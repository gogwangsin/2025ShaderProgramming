#version 330

// in : 사용자가 정의한 입력값
// a_ : attribute의 약자
in vec3 a_Position;
in vec4 a_Color;

out vec4 v_ClipPos;

// Color를 출력하자
out vec4 v_Color;

uniform vec4 u_Trans;

void main()
{
	vec4 newPosition;
	newPosition.xy = a_Position.xy*u_Trans.w + u_Trans.xy;
	newPosition.z = 0;
	newPosition.w= 1;
	gl_Position = newPosition;

	v_ClipPos = gl_Position; // Clip Space 그대로 FS로 전달

	v_Color = a_Color;
}
