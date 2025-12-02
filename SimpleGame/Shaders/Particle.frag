#version 330

layout(location=0) out vec4 FragColor;
layout(location=1) out vec4 FragColor1;

uniform sampler2D u_Texture;


in vec4 v_Color;
in vec2 v_UV;

/*void Textured()
{
	vec4 result = texture(u_Texture, v_UV) * v_Color;
	float brightness = dot(result.rgb, vec3(0.2126, 0.7152, 0.0722));

	FragColor = result;
	if(brightness > 1.0)
		FragColorHigh = result;
	else
		FragColorHigh = vec4(0);
}*/


void main()
{
	vec4 result = texture(u_Texture, v_UV) * v_Color * 2;
	float brightness = dot(result.rgb, vec3(0.2126, 0.7152, 0.0722));
	FragColor = result;

	if(brightness > 1.0)
		FragColor1 = result - vec4(1);
	else
		FragColor1 = vec4(0);





//	FragColor1 = vec4(v_UV, 0, 1);
//	FragColor1 = vec4(2, -1); 이렇게, 0~1로 Clamp되기에 1을 넘겨도 값이 같다
}
