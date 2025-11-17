#version 330


in vec3 a_Position;

out vec2 v_UV; 
// 텍스쳐 좌표, 샘플링하는 좌료로 사용하게 될 것
// 왼쪽 위를 0,0 우측 아래 1,1

// a_Position, -1~1, u: (x+1)/2 <- 0~1; v:(1-y)/2 <- 0~1;

void main()
{
	vec4 newPosition = vec4(a_Position, 1);
	
	gl_Position = newPosition;

	v_UV.x = (newPosition.x + 1) / 2;
	v_UV.y = (1 - newPosition.y) / 2;
}
