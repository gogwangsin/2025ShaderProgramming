#version 330 core

layout(location = 0) out vec4 FragColor;

in vec2 v_UV;

uniform float u_Time;

const float c_PI = 3.141592;

void main()
{
    // 1️⃣ 중심 좌표 계산 (0~1 UV → -1~1 중심 정규화)
    vec2 uv = v_UV * 2.0 - 1.0;

    // 2️⃣ 원형 거리 계산
    float r = length(uv);

    // 3️⃣ 시간에 따라 물결이 바깥으로 퍼지도록 sin파 생성
    float wave = sin(r * 20.0 - u_Time * 4.0);  // 20: 주기, 4: 속도

    // 4️⃣ 파형 강조 (절댓값 후 감쇠)
    float intensity = pow(abs(wave), 8.0) * (1.0 - r); // 바깥 갈수록 사라지게

    // 5️⃣ 컬러 설정 (흰색 물결)
    vec3 color = vec3(intensity);

    FragColor = vec4(color, 1.0);
}