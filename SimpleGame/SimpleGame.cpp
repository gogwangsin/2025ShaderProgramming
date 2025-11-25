/*
Copyright 2022 Lee Taek Hee (Tech University of Korea)

This program is free software: you can redistribute it and/or modify
it under the terms of the What The Hell License. Do it plz.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY.

💡 한 줄 요약:
“FreeGLUT + GLEW로 윈도우 만들고, 
Renderer 객체로 그림 그리고, 
이벤트와 Idle에서 화면 갱신하는 OpenGL 프로그램 구조”

Shader Fighting! asdfs
*/

#include "stdafx.h"
#include <iostream>
#include "Dependencies\glew.h"     // glew.h: OpenGL 확장 함수 사용
#include "Dependencies\freeglut.h" // freeglut.h: 윈도우, 입력, 렌더링 루프 관리

#include "Renderer.h"

Renderer *g_Renderer = NULL;
bool g_bNeedReloadShaderPrograms = false;

void RenderScene(void)
{
	if (g_bNeedReloadShaderPrograms)
	{
		g_Renderer->ReloadAllShaderPrograms();
		g_bNeedReloadShaderPrograms = false;
	}


	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); // 화면과 깊이 버퍼 초기화
	// g_Renderer->DrawFullScreenColor(0, 0, 0, 0.04);
	glClearColor(0.7f, 0.7f, 0.4f, 0.0f); // 배경색 설정 (0.0, 0.3, 0.3)

	// Renderer Test
	// g_Renderer->DrawSolidRect(0, 0, 0, 20, 1, 0, 1, 1);
	// g_Renderer->DrawTest();
	// g_Renderer->DrawParticle();
	// g_Renderer->DrawGridMesh();
	// g_Renderer->DrawFS();
	g_Renderer->DrawTexture(0, 0, 0, 0, 0);

	glutSwapBuffers(); // 더블 버퍼링 → 화면에 최종 출력
}

void Idle(void)
{
	RenderScene();
}

void MouseInput(int button, int state, int x, int y)
{
}

void KeyInput(unsigned char key, int x, int y)
{
	// 프로그램 실행중에 셰이더를 끄거나 켤 수 있도록
	// -> 셰이더 파일만 수정 저장하고 키 입력하면 다시 그려진다
	switch (key)
	{
	case '1':
		g_bNeedReloadShaderPrograms = true;
		break;


	default:
		break;
	}
}

void SpecialKeyInput(int key, int x, int y)
{
}

int main(int argc, char **argv)
{
	int winX = 500;
	int winY = 500;

	// Initialize GL things
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_DEPTH | GLUT_DOUBLE | GLUT_RGBA);
	glutInitWindowPosition(0, 0);
	glutInitWindowSize(winX, winY);
	glutCreateWindow("ShaderProgramming");
	// FreeGLUT 초기화
	// 디스플레이 모드 : 깊이 버퍼, 더블 버퍼, RGBA
	// 윈도우 생성 : 500x500, 제목 지정

	// GLEW 초기화 → OpenGL 확장 함수 사용 가능
	// OpenGL 3.0 지원 여부 확인
	glewInit();
	if (glewIsSupported("GL_VERSION_3_0")) {
		std::cout << " GLEW Version is 3.0\n ";
	}
	else {
		std::cout << "GLEW 3.0 not supported\n ";
	}

	// Initialize Renderer
	g_Renderer = new Renderer(winX, winY);
	if (!g_Renderer->IsInitialized())
	{
		std::cout << "Renderer could not be initialized.. \n";
	}

	glutDisplayFunc(RenderScene);

	// 모든 입력 이벤트에서 화면 다시 그리기 호출
	// Idle 상태에서도 계속 RenderScene() 실행 → 애니메이션 가능
	glutIdleFunc(Idle); // Idle 함수: CPU가 놀 때 실행
	glutKeyboardFunc(KeyInput);
	glutMouseFunc(MouseInput);
	glutSpecialFunc(SpecialKeyInput);

	glutMainLoop();

	delete g_Renderer;

    return 0;
}

