#version 330 core

layout(location = 0) out vec4 FragColor;

in vec2 v_UV;
uniform float u_Time;

const float c_PI = 3.141592;

void main()
{
    // 🌸 중심 좌표 (-1 ~ 1)
    vec2 uv = v_UV * 2.0 - 1.0;
    float r = length(uv);
    float angle = atan(uv.y, uv.x);

    // 🌀 부드러운 회전 (느리게 도는 꽃잎)
    float rot = u_Time * 0.3;
    mat2 rotation = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
    uv = rotation * uv;
    r = length(uv);
    angle = atan(uv.y, uv.x);

    // 🌺 꽃잎 모양: 각도에 따른 패턴 (잎 개수 조절)
    float petals = 6.0; // ← 4~8 사이 조절 가능
    float petalShape = pow(abs(sin(angle * petals)), 3.0);

    // 🌊 반지름 방향 파동
    float radialWave = sin(r * 40.0 - u_Time * 8.0);

    // 💎 조합: 각도 기반 꽃잎 + 반지름 기반 물결
    float pattern = petalShape * abs(radialWave);

    // 🌈 프랙탈 반복
    float zoom = pow(1.25, sin(u_Time * 0.7) * 3.0);
    float repeated = fract(r * zoom * 6.0 + petalShape * 0.2);

    // 🌟 빛의 세기 (더 강한 대비)
    float intensity = smoothstep(0.6, 0.95, pattern) * (1.0 - r * 0.8);

    // 🎨 색상 변조 — 보석처럼
    vec3 base = 0.5 + 0.5 * cos(vec3(0.2, 0.7, 1.0) * 6.2831 + angle * 1.5 + u_Time * 0.5);
    vec3 color = base * intensity * 2.0;

    // 🌤 중심부 밝기 강조 (빛나는 코어)
    color += vec3(1.0, 0.9, 0.7) * exp(-r * 8.0) * 1.5;

    FragColor = vec4(color, 1.0);
}