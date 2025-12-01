#version 330

layout(location=0) out vec4 FragColor;
// 이 0이 GL_COLOR_ATTACHMENT0 이거 0이랑 같은 곳을 가리키는 것이다 - 아마

uniform sampler2D u_TexID;
uniform float u_Time;

in vec2 v_Tex;

// 해시 함수: pseudo-random
float hash(vec2 p)
{
    p = fract(p * vec2(123.34, 345.45));
    p += dot(p, p + 34.23);
    return fract(p.x * p.y);
}

// 2D 노이즈 (간단 버전)
float noise(vec2 p)
{
    vec2 i = floor(p);
    vec2 f = fract(p);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

vec4 Lens()
{
    vec2 uv = v_Tex;

    //---------------------------------------
    // 1. 물방울 패턴 (큰 물방울 유지)
    //---------------------------------------
    float rainScale = 10.0;
    float n = noise(uv * rainScale);

    float dropMask = smoothstep(0.70, 0.90, n);

    //---------------------------------------
    // 2. ★ 물방울이 아래로 흐르는 애니메이션
    //---------------------------------------
    // 시간에 따라 y축만 흐르게 (속도는 0.05)
    float flowSpeed = -0.05;
    float flow = fract(uv.y + u_Time * flowSpeed);

    // 흐르는 방향으로 노이즈도 약간 끌려가도록
    float movingDrops = noise(vec2(uv.x, flow) * rainScale);
    float movingMask = smoothstep(0.70, 0.90, movingDrops);

    // 원래 dropMask와 합성 → 너무 흐르지 않도록 균형 유지
    float finalDrop = max(dropMask, movingMask);

    //---------------------------------------
    // 3. 굴절 (더 강한 refraction)
    //---------------------------------------
    float refractPower = 0.12;
    vec2 refractUV = uv + (finalDrop - 0.5) * refractPower;
    refractUV = clamp(refractUV, 0.0, 1.0);

    vec4 refractColor = texture(u_TexID, refractUV);

    //---------------------------------------
    // 4. 블러 (유리창 흐림)
    //---------------------------------------
    float blurSize = 3.0 / 1080.0;
    vec4 blur =
        texture(u_TexID, uv + vec2(-blurSize, 0.0)) +
        texture(u_TexID, uv + vec2( blurSize, 0.0)) +
        texture(u_TexID, uv + vec2(0.0, -blurSize)) +
        texture(u_TexID, uv + vec2(0.0,  blurSize));
    blur *= 0.25;

    vec4 baseColor = texture(u_TexID, uv);

    vec4 mixedColor =
        refractColor * finalDrop +
        mix(baseColor, blur, 0.75) * (1.0 - finalDrop);

    //---------------------------------------
    // 5. ★ 물방울 하이라이트(빛 번짐)
    //---------------------------------------
    float highlight = smoothstep(0.85, 1.0, n);  // 밝은 가장자리
    mixedColor.rgb += highlight * 0.15;          // 0.15 정도만 더함

    //---------------------------------------
    // 6. 푸른 톤 유지
    //---------------------------------------
    float blueBias = 0.10;
    float coolTone = 0.05;
    mixedColor.rgb = vec3(
        mixedColor.r * (1.0 - coolTone),
        mixedColor.g * (1.0 - coolTone * 0.5),
        mixedColor.b + blueBias
    );

    return mixedColor;
}

void main()
{
	//FragColor = texture(u_TexID, vec2(v_Tex.x, 1 - v_Tex.y));  // x는 그대로, y는 반전으로 그리기
	FragColor = Lens();

	// FragColor = vec4(v_Tex, 0, 1); - 디버깅 하는 팁 좌표가 잘 전달됐는지.
}
