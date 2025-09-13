#version 330

layout(location=0) out vec4 FragColor;

in vec4 v_Color;
in vec4 v_ClipPos;

uniform vec4 u_Color;

void main()
{
	// FragColor = vec4(u_Color.r, u_Color.g, u_Color.b, u_Color.a);

	vec3 NDC = v_ClipPos.xyz / v_ClipPos.w;
	if(NDC.y < 0.5)
		FragColor = v_Color;
	else
		discard;

	//if(v_Color.b < 0.5)
	//	FragColor = v_Color;
	//else
	//	discard;

}
