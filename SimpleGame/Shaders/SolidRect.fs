#version 330

layout(location=0) out vec4 FragColor;
// // 출력 색상(최종 픽셀 색)

in vec4 v_Color;
// // VS에서 보간된 정점 색상 입력

uniform vec4 u_Color;

void main()
{
	// FragColor = vec4(u_Color.r, u_Color.g, u_Color.b, u_Color.a);

	if(v_Color.b < 0.5)
		FragColor = v_Color;
	else
		discard;

}
