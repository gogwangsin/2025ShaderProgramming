#version 330

layout(location = 0) out vec4 FragColor;

in vec2 v_UV;
uniform float u_Time;

const float PI = 3.141592;

void main()
{
    // 화면 중심 정규화
    vec2 uv = v_UV * 2.0 - 1.0;
    float r = length(uv);
    float angle = atan(uv.y, uv.x);

    // 🌀 꽃잎 패턴 (4엽 형태)
    float petal = cos(angle * 4.0);

    // 🌊 시간에 따라 퍼져나가는 원형 파동
    float wave = sin((r * 20.0 - u_Time * 6.0) + petal * 0.5);

    // 🌸 꽃잎 형태 강조 (sharpness 증가)
    float intensity = pow(abs(wave), 12.0) * (1.0 - r * 0.8);

    // 🌈 색상 변화 + 밝기
    vec3 color = 0.5 + 0.5 * cos(vec3(0.8, 0.4, 0.2) * 6.2831 + u_Time * 1.5 + angle * 1.2);
    
    // 🌟 원이 퍼져나가며 커지는 듯한 효과 (중심 확대)
    float radialWarp = 1.0 + 0.3 * sin(u_Time * 2.0 + r * 10.0);
    r *= radialWarp;

    // 💫 강도 적용
    float fade = smoothstep(0.0, 1.0, 1.0 - r);
    vec3 finalColor = color * intensity * fade * 2.0;

    FragColor = vec4(finalColor, 1.0);
}