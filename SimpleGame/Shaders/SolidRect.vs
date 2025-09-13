#version 330

// in : 사용자가 정의한 입력값
// a_ : attribute의 약자
in vec3 a_Position;
in vec4 a_Color;

// Color를 출력하자
out vec4 v_Color;

uniform vec4 u_Trans;

void main()
{
	// u_Trans.w
	// u_Trans의 네 번째 값 → size 값.
	// → 정점 좌표를 이 값으로 스케일(scale) 해서 사각형의 크기 조절.
	// u_Trans.xy
	// 사각형을 그릴 위치 (newX, newY).
	// → 정점 좌표를 원하는 위치로 이동(translate).

	vec4 newPosition;
	newPosition.xy = a_Position.xy*u_Trans.w + u_Trans.xy;
	newPosition.z = 0;  // 2D 렌더링이라 깊이(Z)는 0.
	newPosition.w= 1;   // 동차 좌표(homogeneous coordinate) 기본값.
	gl_Position = newPosition;

	v_Color = a_Color;
}
