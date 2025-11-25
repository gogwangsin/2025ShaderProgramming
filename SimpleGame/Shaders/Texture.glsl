#version 330

layout(location=0) out vec4 FragColor;
// 이 0이 GL_COLOR_ATTACHMENT0 이거 0이랑 같은 곳을 가리키는 것이다 - 아마

uniform sampler2D u_TexID;

in vec2 v_Tex;

void main()
{
//	FragColor = texture(u_TexID, v_Tex);
	FragColor = texture(u_TexID, vec2(v_Tex.x, 1 - v_Tex.y));  // x는 그대로, y는 반전으로 그리기


	// FragColor = vec4(v_Tex, 0, 1); - 디버깅 하는 팁 좌표가 잘 전달됐는지.
}
