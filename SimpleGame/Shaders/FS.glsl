#version 330 core

layout(location = 0) out vec4 FragColor;

in vec2 v_UV;

uniform sampler2D u_RGBTexture;
uniform float u_Time;

const float PI = 3.141592;

void RGBTest()
{
    // distortion
    vec2 newUV = v_UV;
    float dx = 0.1 * sin(v_UV.y * 8 * PI + u_Time);
    float dy = 0.1 * sin(v_UV.x * 2 * PI + u_Time);
    newUV += vec2(dx, dy);
   vec4 sampleColor = texture(u_RGBTexture, newUV);

    FragColor = sampleColor;
}

void Circles()
{
    vec2 newUV = v_UV; // 0~1, left top (0, 0)
    vec2 center = vec2(0.5, 0.5);
    vec4 newColor = vec4(0);

    float d = distance(newUV, center);

    float value = sin(d * 4 * PI * 4 + u_Time);
    newColor = vec4(value);

    FragColor = newColor;
}

// FS는 버텍스를 옮길 수 없다
void Flag()
{
    vec2 newUV = vec2(v_UV.x, 1-v_UV.y - 0.5); // 0~1, left bottom(0, 0)
    // UV좌표를 수정했다.
    // 왼쪽 아래는    (0,-0.5)
    // 왼쪽 가운데는  (0,0)
    // 왼쪽 위는      (0,0.5)

    vec4 newColor = vec4(0);

    float halfwidth = 0.2 * (1 - newUV.x);
    // 뾰족한 깃발이 되도록, x가 늘어날 수록 값이 작아지게
    float sinValue = v_UV.x * 0.2 * sin(newUV.x * 2 * PI - u_Time * 2);
    // v_UV.x를 곱하는 이유는 왼쪽은 sinvalue 영향 안받게 0값으로 출력한 것
    // 이거 없으면 위상 이동하는 sin 그래프

    if(newUV.y < sinValue + halfwidth && newUV.y > sinValue - halfwidth)
    {
        newColor = vec4(1);
    }
    else
    {
        discard;
    }

    FragColor = newColor;
}

// 좌표 꼬아보기 
void Q1()
{
    vec2 newUV = vec2(v_UV.x, v_UV.y); // 0~1, left bottom(0, 0)

    float x = newUV.y; // 0~1 -> 1~0
    float y = 1 - newUV.x;     // 0~1

    vec4 newColor = texture(u_RGBTexture, vec2(x,y));

    FragColor = newColor;
}

// 좌표 꼬아보기 
void Q2()
{
    vec2 newUV = vec2(v_UV.x, v_UV.y); // 0~1, left bottom(0, 0)

    float x = fract(newUV.x * 3); // 0~3 -> fract 소수점만 취하기 -> 0,1 ~ 0,1 ~ 0,1 3번 반복된다
    float y = ((floor(newUV.x * 3))/3 - u_Time) + newUV.y / 3;     // 0~1


    vec4 newColor = texture(u_RGBTexture, vec2(x,y));

    FragColor = newColor;
}

void main()
{
    // RGBTest();
    // Circles();
    // Flag();
    // Q1();
    Q2();
}







// ------------------------------------------------------------------
const int DROPLETS = 5; // 물방울 개수

// 초기 위치
vec2 dropletCenters[DROPLETS] = vec2[](
    vec2(-0.5, 1.0),
    vec2(0.3, 1.5),
    vec2(0.7, 1.2),
    vec2(-0.7, 1.3),
    vec2(0.0, 1.8)
);

// 각 물방울별 시간 오프셋
float timeOffsets[DROPLETS] = float[](0.0, 1.2, 2.1, 0.7, 1.8);

// 각 물방울별 파동 속도/주기
float speeds[DROPLETS] = float[](0.3, 0.25, 0.35, 0.28, 0.32);
float waveScales[DROPLETS] = float[](20.0, 22.0, 18.0, 21.0, 19.0);

void ai()
{
    vec2 uv = v_UV * 2.0 - 1.0;
    vec3 finalColor = vec3(0.0);

    for(int i = 0; i < DROPLETS; i++)
    {
        // 🔹 물방울 별 시간 적용
        vec2 center = dropletCenters[i];
        float t = u_Time + timeOffsets[i];
        center.y -= mod(t * speeds[i], 3.0);

        vec2 diff = uv - center;
        float r = length(diff);
        float angle = atan(diff.y, diff.x);

        // 🌸 꽃잎 패턴
        float petal = cos(angle * 4.0);

        // 🌊 개별 파동
        float wave = sin((r * waveScales[i] - t * 6.0) + petal * 0.5);

        // 🌟 꽃잎 강조
        float intensity = pow(abs(wave), 12.0) * (1.0 - r * 0.8);

        // 💫 원형 팽창
        float radialWarp = 1.0 + 0.3 * sin(t * 2.0 + r * 10.0);
        r *= radialWarp;

        // 💧 최종 강도
        float fade = smoothstep(0.0, 1.0, 1.0 - r);
        vec3 color = 0.5 + 0.5 * cos(vec3(0.8, 0.4, 0.2) * 6.2831 + t * 1.5 + angle * 1.2);
        finalColor += color * intensity * fade * 2.0;
    }

    finalColor = clamp(finalColor, 0.0, 1.0);
    FragColor = vec4(finalColor, 1.0);
}