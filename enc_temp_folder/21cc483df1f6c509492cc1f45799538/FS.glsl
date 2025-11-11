#version 330 core

layout(location = 0) out vec4 FragColor;

in vec2 v_UV;
uniform float u_Time;

const float c_PI = 3.141592;

void main()
{
    // 🌀 중심 정규화 (-1 ~ 1)
    vec2 uv = v_UV * 2.0 - 1.0;

    // 🔄 회전 효과 (시간에 따라 중심이 도는 느낌)
    float rot = u_Time * 0.4;
    mat2 rotation = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
    uv = rotation * uv;

    // 🔹 거리와 각도 계산
    float r = length(uv);
    float angle = atan(uv.y, uv.x);

    // 🌊 각도 기반의 복합 파형 — 방사형 & 원형 동시 진동
    float angularWave = sin(angle * 8.0 + u_Time * 3.0);     // 방사형 줄무늬
    float radialWave  = sin(r * 40.0 - u_Time * 10.0);       // 원형 물결

    // 💫 원형 외곽을 일렁이게 (각도와 반지름 혼합)
    r += sin(angle * 6.0 + u_Time * 5.0) * 0.03;
    r += sin(r * 10.0 - u_Time * 2.0) * 0.02;

    // 🔁 프랙탈 반복 (fract 기반)
    float zoom = pow(1.3, sin(u_Time * 0.7) * 3.0);
    float repeated = fract(r * zoom * 8.0);

    // 🌟 파형 조합 — 중심 코어 빛과 결합
    float wave = sin(repeated * 60.0 - u_Time * 8.0 + angularWave * 2.0);
    float intensity = smoothstep(0.35, 1.0, abs(wave)) * (1.0 - r * 0.8);

    // 🎨 색상: 각도 기반으로 스펙트럼 변조
    vec3 baseColor = 0.5 + 0.5 * cos(vec3(0.3, 0.7, 1.0) * 6.2831 + angle * 2.0 + u_Time);
    vec3 finalColor = baseColor * intensity * 2.0;

    // 💎 중심 빛 번짐
    finalColor += vec3(1.0, 0.9, 0.6) * exp(-r * 10.0) * 1.5;

    FragColor = vec4(finalColor, 1.0);
}