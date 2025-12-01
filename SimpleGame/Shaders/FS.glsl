#version 330 core

layout(location = 0) out vec4 FragColor;
layout(location = 1) out vec4 FragColor1; 
// 그린 것들을 다른 버퍼(다른 렌더타겟들)에 저장하고 동시 출력하면 drawcall 두번하는 것보다 효율적이지 않나

in vec2 v_UV;

uniform sampler2D u_RGBTexture;
uniform sampler2D u_DigitTexture;
uniform sampler2D u_NumTexture;
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

    float x = newUV.x; // 0~1
    float y = 1 - abs((v_UV.y - 0.5) * 2); // -0.5~0.5 => -1~1 => 1~0~1 => 0~1~0
    // abs가 뽀인트
    // -1 ~ 1 => [-1] [-0.5] [0.0] [0.5] [1.0] => [1 ~ 0 ~ 1]

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

// 좌표 꼬아보기 
void Q3()
{
    vec2 newUV = vec2(v_UV.x, v_UV.y); // 0~1, left bottom(0, 0)

    float x = fract(newUV.x * 3) - u_Time; // 0~3 -> fract 소수점만 취하기 -> 0,1 ~ 0,1 ~ 0,1 3번 반복된다
    float y = ((v_UV.y - 0.5) * 2);     // 0~1

    vec4 newColor = texture(u_RGBTexture, vec2(x,y));

    FragColor = newColor;
}

void Brick_Horizontal()
{
    vec2 newUV = vec2(v_UV.x, v_UV.y);
    float rCount = 3; 
    float sAmount = 0.2;
    float x = fract(newUV.x * rCount) + floor(newUV.y * rCount + 1) * sAmount;// 0~1, 0~1
    float y = fract(newUV.y * rCount);

    vec4 newColor = texture(u_RGBTexture, vec2(x,y));

    FragColor = newColor;
}

void Brick_Vertical()
{
    vec2 newUV = vec2(v_UV.x, v_UV.y);

    float x = fract(newUV.x * 2);// 0~1, 0~1
    float y = fract(newUV.y * 2) + floor(newUV.x * 2) * 0.5; 

    vec4 newColor = texture(u_RGBTexture, vec2(x,y));

    FragColor = newColor;
}

void Brick_Horizontal_AI()
{
vec2 newUV = vec2(v_UV.x, v_UV.y);
    
    float rCount = 3.0; 
    float sAmount = 0.2; // 기본 오프셋 양
    
    // 1. 현재 행(Row)의 인덱스를 계산
    float rowIndex = floor(newUV.y * rCount + 1.0);
    
    // 2. 시간 기반 흔들림 오프셋 계산
    // cos 함수를 사용하여 주기적인 움직임을 만듭니다.
    // rowIndex를 곱하여 각 행이 독립적으로 움직이거나 다른 위상으로 움직이게 할 수 있습니다.
    // 0.1은 흔들림의 강도, 2.0은 흔들림의 속도를 조절합니다.
    float swingOffset = cos(u_Time * 2.0 + rowIndex * 0.5) * 0.1; 
    
    // 3. 최종 X 오프셋 계산: 기본 오프셋 + 흔들림 오프셋
    float xOffset = (rowIndex * sAmount) + swingOffset;
    
    // 4. U (x) 좌표 계산
    float x = fract(newUV.x * rCount) + xOffset;
    
    // 5. V (y) 좌표 계산
    float y = fract(newUV.y * rCount);

    // 6. 새로운 UV를 사용해 텍스처에서 색상 샘플링
    vec4 newColor = texture(u_RGBTexture, vec2(x, y));

    // 7. (선택 사항) 시간 기반 색상 변화 추가
    // HSL이나 RGB 채널을 직접 조작하여 색상 변화를 줄 수 있습니다.
    // 예를 들어, 시간에 따라 색조(Hue)를 변경하거나, RGB 값에 사인파를 적용할 수 있습니다.
    // 아래는 단순하게 R, G, B 채널에 시간에 따른 변화를 주는 예시입니다.
     newColor.r += sin(u_Time * 1.0) * 0.1;
     newColor.g += cos(u_Time * 1.5) * 0.1;
     newColor.b += sin(u_Time * 2.0) * 0.1;
     newColor = clamp(newColor, 0.0, 1.0); // 색상 값을 0~1 범위로 유지

    FragColor = newColor;
}

void Digit()
{
    FragColor = texture(u_DigitTexture, v_UV);
}

void Digit_Num()
{
    // 1. 현재 시간에서 00-99 사이의 두 자릿수 계산
    int currentNum = int(u_Time) % 100;
    int tensDigit = currentNum / 10;      // 십의 자리 숫자 (예: 54 -> 5)
    int unitsDigit = currentNum % 10;    // 일의 자리 숫자 (예: 54 -> 4)

    int digitIndex; // 최종적으로 선택된 숫자 (0~9)
    vec2 localUV;   // 각 숫자 영역(왼쪽/오른쪽) 내에서 0.0 ~ 1.0으로 재매핑된 UV

    // 2. 화면의 절반을 기준으로 어느 숫자를 그릴지 결정
    
    // 화면 왼쪽 절반 (v_UV.x < 0.5): 십의 자리 출력
    if (v_UV.x < 0.5) {
        digitIndex = tensDigit;
        // X 좌표를 0.0~0.5 범위에서 0.0~1.0 범위로 확장 (좌표 재매핑)
        localUV.x = v_UV.x * 2.0; 
    } 
    // 화면 오른쪽 절반 (v_UV.x >= 0.5): 일의 자리 출력
    else {
        digitIndex = unitsDigit;
        // X 좌표를 0.5~1.0 범위에서 0.0~1.0 범위로 재매핑
        localUV.x = (v_UV.x - 0.5) * 2.0; 
    }
    
    localUV.y = v_UV.y; // Y 좌표는 그대로 유지

    // 3. 텍스처 타일 오프셋 계산 (원본 Digit_Num 로직 재사용)
    // 원본 함수와 동일한 방식으로 tileIndex를 계산
    int tileIndex = (digitIndex + 9) % 10; 
    
    // 텍스처 시트가 5x2 배열이라고 가정하고 오프셋 계산
    // offX: 타일의 가로 위치 (0/5, 1/5, 2/5, 3/5, 4/5)
    float offX = float(tileIndex % 5) / 5.0; 
    // offY: 타일의 세로 위치 (0/2, 1/2)
    float offY = floor(float(tileIndex) / 5.0) / 2.0;

    // 4. 최종 텍스처 좌표 계산 및 색상 샘플링
    // localUV.x(0.0~1.0)에 1/5 스케일링을 적용하여 타일 너비(0.2)를 만듭니다.
    float tx = localUV.x / 5.0 + offX;
    // localUV.y(0.0~1.0)에 1/2 스케일링을 적용하여 타일 높이(0.5)를 만듭니다.
    float ty = localUV.y / 2.0 + offY;
    
    FragColor = texture(u_NumTexture, vec2(tx, ty));
}

void main()
{
    // RGBTest();
    // Circles();
    // Flag();
    // Q1();
    // Q2();
    // Q3();
    // Brick_Horizontal();
    // Brick_Vertical();
    // Brick_Horizontal_AI();
    // Digit();
    Digit_Num();

    FragColor1 = vec4(1, 0, 0, 1);
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