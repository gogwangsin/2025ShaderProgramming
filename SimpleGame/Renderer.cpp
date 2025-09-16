#include "stdafx.h"
#include "Renderer.h"

Renderer::Renderer(int windowSizeX, int windowSizeY)
{
	Initialize(windowSizeX, windowSizeY);
}

Renderer::~Renderer()
{
}

void Renderer::Initialize(int windowSizeX, int windowSizeY)
{
	//Set window size
	m_WindowSizeX = windowSizeX;
	m_WindowSizeY = windowSizeY;

	//Load shaders
	m_SolidRectShader = CompileShaders("./Shaders/SolidRect.vs", "./Shaders/SolidRect.fs");
	m_TestShader = CompileShaders("./Shaders/Test.vs", "./Shaders/Test.fs");

	//Create VBOs
	CreateVertexBufferObjects();

	if (m_SolidRectShader > 0 && m_VBORect > 0)
	{
		m_Initialized = true;
	}
}

bool Renderer::IsInitialized()
{
	return m_Initialized;
}

void Renderer::CreateVertexBufferObjects()
{
	// 사각형(Rectangle) 정점 데이터를 GPU에 올리는 과정
	// 좌표를 m_WindowSizeX, m_WindowSizeY로 나눠서 픽셀 단위 → NDC 비율로 변환
	float rect[] 
		=
	{
		-1.f / m_WindowSizeX, -1.f / m_WindowSizeY, 0.f, 
		-1.f / m_WindowSizeX,  1.f / m_WindowSizeY, 0.f, 
		 1.f / m_WindowSizeX,  1.f / m_WindowSizeY, 0.f, //Triangle1

		-1.f / m_WindowSizeX, -1.f / m_WindowSizeY, 0.f,  
		 1.f / m_WindowSizeX,  1.f / m_WindowSizeY, 0.f, 
		 1.f / m_WindowSizeX, -1.f / m_WindowSizeY, 0.f, //Triangle2
	};

	glGenBuffers(1, &m_VBORect);				// GPU에서 버텍스 버퍼 객체(VBO) 하나 생성, m_VBORect에 ID 저장
	glBindBuffer(GL_ARRAY_BUFFER, m_VBORect);   // 지금부터의 버퍼 작업을 m_VBORect에 적용, GL_ARRAY_BUFFER → 정점 데이터용 버퍼 타입
	glBufferData(GL_ARRAY_BUFFER, sizeof(rect), rect, GL_STATIC_DRAW);
	// sizeof(rect) → 배열 크기(Byte), rect → 실제 데이터 포인터, GL_STATIC_DRAW → 데이터는 자주 안 바뀜 힌트
	//	GPU 메모리에 정점 데이터를 복사


	// lecture2
	float temp = 0.5f;
	float size = 0.1f;
	float testPos[]
		=
	{
		(0.f - temp) * size, (0.f - temp) * size, 0.f,
		(1.f - temp) * size, (0.f - temp) * size, 0.f,
		(1.f - temp) * size, (1.f - temp) * size, 0.f, // triangle 1

		(0.f - temp) * size, (0.f - temp) * size, 0.f,
		(1.f - temp) * size, (1.f - temp) * size, 0.f,
		(0.f - temp) * size, (1.f - temp) * size, 0.f // triangle 2
	};
	// -> 반시계로

	glGenBuffers(1, &m_VBOTestPos);				 // 아직 GPU 메모리가 생성되지 않았음, int 숫자 ID만 받음
	glBindBuffer(GL_ARRAY_BUFFER, m_VBOTestPos); // GL_ARRAY_BUFFER라는 방 하나, 숫자ID(vbo)를 Array Buffer로 쓴다고 의미를 부여하는거로 이해 
	// 아낌없이 쓰도록 하자
	glBufferData(GL_ARRAY_BUFFER, sizeof(testPos), testPos, GL_STATIC_DRAW);
	// GPU에 데이터를 올려주는 작업

	// lecture3

	float testColor[]
		=
	{
		1.f, 0.f, 0.f, 1.f,
		0.f, 1.f, 0.f, 1.f,
		0.f, 0.f, 1.f, 1.f,    //Triangle1

		1.f, 0.f, 0.f, 1.f,
		0.f, 1.f, 0.f, 1.f,
		0.f, 0.f, 1.f, 1.f    //Triangle2
	};
	// -> 반시계로

	glGenBuffers(1, &m_VBOTestColor);
	glBindBuffer(GL_ARRAY_BUFFER, m_VBOTestColor);
	glBufferData(GL_ARRAY_BUFFER, sizeof(testColor), testColor, GL_STATIC_DRAW);
}

void Renderer::AddShader(GLuint ShaderProgram, const char* pShaderText, GLenum ShaderType)
{
	// 목적: 특정 쉐이더(버텍스 또는 프래그먼트)를 프로그램에 추가

	// 쉐이더 오브젝트 생성
	GLuint ShaderObj = glCreateShader(ShaderType);

	if (ShaderObj == 0) {
		fprintf(stderr, "Error creating shader type %d\n", ShaderType);
	}

	const GLchar* p[1];
	p[0] = pShaderText;
	GLint Lengths[1];

	size_t slen = strlen(pShaderText);
	if (slen > INT_MAX) {
		// Handle error
	}
	GLint len = (GLint)slen;

	Lengths[0] = len;
	//쉐이더 코드를 쉐이더 오브젝트에 할당
	glShaderSource(ShaderObj, 1, p, Lengths);

	//할당된 쉐이더 코드를 컴파일
	glCompileShader(ShaderObj);

	GLint success;
	// ShaderObj 가 성공적으로 컴파일 되었는지 확인
	glGetShaderiv(ShaderObj, GL_COMPILE_STATUS, &success);
	if (!success) {
		GLchar InfoLog[1024];

		//OpenGL 의 shader log 데이터를 가져옴
		glGetShaderInfoLog(ShaderObj, 1024, NULL, InfoLog);
		fprintf(stderr, "Error compiling shader type %d: '%s'\n", ShaderType, InfoLog);
		printf("%s \n", pShaderText);
	}

	// ShaderProgram 에 attach!!
	glAttachShader(ShaderProgram, ShaderObj);
}

bool Renderer::ReadFile(char* filename, std::string* target)
{
	std::ifstream file(filename);
	if (file.fail())
	{
		std::cout << filename << " file loading failed.. \n";
		file.close();
		return false;
	}
	std::string line;
	while (getline(file, line)) {
		target->append(line.c_str());
		target->append("\n");
	}
	// 1. getline(file, line)
	//	파일(file)에서 한 줄씩 읽어서 line 문자열에 저장, 줄바꿈 문자는 포함되지 않음

	// 2. target->append(line.c_str())
	//	 읽은 한 줄을** 목표 문자열(target)** 에 추가
	//
	//   c_str()로 C 스타일 문자열로 변환해 append 가능
	//	line.c_str() → 내부 버퍼(const char*) 포인터 반환

	// 3.target->append("\n")
	//	원래 줄바꿈을 복원
	//  쉐이더 코드는 줄 단위로 의미가 있기 때문에 반드시 필요

	return true;
}

GLuint Renderer::CompileShaders(char* filenameVS, char* filenameFS)
{
	// 목적: 버텍스/프래그먼트 쉐이더 파일을 읽어 컴파일 + 링크 + 검증 후 프로그램 반환

	GLuint ShaderProgram = glCreateProgram(); 
	// 빈 쉐이더 프로그램 생성 -> 여러 쉐이더를 묶는 컨테이너 역할

	if (ShaderProgram == 0) { // 쉐이더 프로그램이 만들어졌는지 확인
		fprintf(stderr, "Error creating shader program\n");
	}

	std::string vs, fs;

	//shader.vs 가 vs 안으로 로딩됨
	if (!ReadFile(filenameVS, &vs)) {
		printf("Error compiling vertex shader\n");
		return -1;
	};

	//shader.fs 가 fs 안으로 로딩됨
	if (!ReadFile(filenameFS, &fs)) {
		printf("Error compiling fragment shader\n");
		return -1;
	};

	// ShaderProgram 에 vs.c_str() 버텍스 쉐이더를 컴파일한 결과를 attach함
	AddShader(ShaderProgram, vs.c_str(), GL_VERTEX_SHADER);

	// ShaderProgram 에 fs.c_str() 프래그먼트 쉐이더를 컴파일한 결과를 attach함
	AddShader(ShaderProgram, fs.c_str(), GL_FRAGMENT_SHADER);

	GLint Success = 0;
	GLchar ErrorLog[1024] = { 0 };

	//Attach 완료된 shaderProgram을 링킹함 -> GPU에서 실제 사용 가능한 상태로 연결
	// 연결된 여러 쉐이더 객체들을 통합해 연결하는 것
	glLinkProgram(ShaderProgram);

	//링크가 성공했는지 확인
	glGetProgramiv(ShaderProgram, GL_LINK_STATUS, &Success);

	if (Success == 0) {
		// shader program 로그를 받아옴
		glGetProgramInfoLog(ShaderProgram, sizeof(ErrorLog), NULL, ErrorLog);
		std::cout << filenameVS << ", " << filenameFS << " Error linking shader program\n" << ErrorLog;
		return -1;
	}

	glValidateProgram(ShaderProgram);
	glGetProgramiv(ShaderProgram, GL_VALIDATE_STATUS, &Success);
	if (!Success) {
		glGetProgramInfoLog(ShaderProgram, sizeof(ErrorLog), NULL, ErrorLog);
		std::cout << filenameVS << ", " << filenameFS << " Error validating shader program\n" << ErrorLog;
		return -1;
	}

	glUseProgram(ShaderProgram); // 이후 그리기 호출 시 이 프로그램 사용
	std::cout << filenameVS << ", " << filenameFS << " Shader compiling is done.";

	return ShaderProgram;
}

void Renderer::DrawSolidRect(float x, float y, float z, float size, float r, float g, float b, float a)
{
	float newX, newY;

	GetGLPosition(x, y, &newX, &newY);

	//Program select
	glUseProgram(m_SolidRectShader);

	// u_Trans: 사각형 위치(x, y), z, 크기(size)
	glUniform4f(glGetUniformLocation(m_SolidRectShader, "u_Trans"), newX, newY, 0, size);
	glUniform4f(glGetUniformLocation(m_SolidRectShader, "u_Color"), r, g, b, a);

	int attribPosition = glGetAttribLocation(m_SolidRectShader, "a_Position"); // a_Position → 쉐이더에서 각 정점 좌표 받는 변수
	glEnableVertexAttribArray(attribPosition);
	glBindBuffer(GL_ARRAY_BUFFER, m_VBORect); // VBO(m_VBORect) 바인딩 → GPU에 올라간 사각형 정점 사용
	glVertexAttribPointer(attribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 3, 0); // VBO 데이터와 쉐이더 속성 연결

	glDrawArrays(GL_TRIANGLES, 0, 6); // 6개의 정점 → 2개의 삼각형 → 사각형

	glDisableVertexAttribArray(attribPosition); // 정점 속성 비활성화 → 다른 그리기 코드에 영향 안 주도록

	glBindFramebuffer(GL_FRAMEBUFFER, 0); // 프레임버퍼 바인딩 해제 → 기본 화면으로 복귀
}

void Renderer::DrawTest()
{
	//Program select
	glUseProgram(m_TestShader);

	// Location 포지션 받고, Enable하고, 바인드, 바인드되어 있는 포인터와 시작점을 받아오기
	int aPosLoc = glGetAttribLocation(m_TestShader, "a_Position");
	int aColorLoc = glGetAttribLocation(m_TestShader, "a_Color");

	glEnableVertexAttribArray(aPosLoc);
	glBindBuffer(GL_ARRAY_BUFFER, m_VBOTestPos);
	glVertexAttribPointer(aPosLoc, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 3, 0);
	// → 즉, "0번 슬롯(a_Position)은 이 VBO에서 vec3(float 3개) 형태로 읽어라" 라고 알려주는 거죠.
	glDrawArrays(GL_TRIANGLES, 0, 6); // 정짐 개수만 늘어났다 3->6

	glEnableVertexAttribArray(aColorLoc);
	glBindBuffer(GL_ARRAY_BUFFER, m_VBOTestColor);
	glVertexAttribPointer(aColorLoc, 4, GL_FLOAT, GL_FALSE, sizeof(float) * 4, 0);
	glDrawArrays(GL_TRIANGLES, 0, 6);

	// 위 4가지 방법을 동일하게 하면 된다.
	// ( glGetAttribLocation, glEnableVertexAttribArray, glBindBuffer, glVertexAttribPointer )

	glDisableVertexAttribArray(aPosLoc);

	glBindFramebuffer(GL_FRAMEBUFFER, 0);
	// 어떤 프레임버퍼에 렌더링할지를 선택하는 OpenGL 함수
	// 0 = 기본 윈도우 프레임버퍼
	// 다른 숫자 = glGenFramebuffers로 만든 Frame Buffer Object
}


void Renderer::GetGLPosition(float x, float y, float* newX, float* newY)
{
	// 윈도우 좌표를 OpenGL NDC 좌표로 변환하는 역할
	// x, y : 윈도우(픽셀) 좌표, 예: (0 ~ m_WindowSizeX, 0 ~ m_WindowSizeY)
	// 
	// OpenGL **NDC(Normalized Device Coordinates)**는 좌표 범위가 [-1, 1]
	// 하지만 이 함수는 단순히 0~2 범위로 매핑

	*newX = x * 2.f / m_WindowSizeX;
	*newY = y * 2.f / m_WindowSizeY;
}