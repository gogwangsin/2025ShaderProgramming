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
    float d = distance(newUV, center);

    vec4 newColor = vec4(d);

    FragColor = newColor;
}

void main()
{
    // RGBTest();
    Circles();
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