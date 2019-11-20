#pragma once
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#include "SceneSetting.h"
#include "colorTransfer.cuh"
/*
5 x 7  的 LED 顯示器
O O O O X
O X X X O
O X X X O
O X X X O
O X X X O
O X X X O
O O O O X
*/
__constant__ int number0[] = { 1,2,3,5,9,10,13,14,15,17,19,20,21,24,25,29,31,32,33 };
__constant__ int number1[] = { 2,6,7,12,17,22,27,31,32,33 };
__constant__ int number2[] = { 1,2,3,5,9,14,18,22,26,30,31,32,33,34 };
__constant__ int number3[] = { 0,1,2,3,4,8,12,18,24,25,29,31,32,33 };
__constant__ int alphabetA[] = { 1,2,3,5,9,10,14,15,16,17,18,19,20,24,25,29,30,34 };
__constant__ int alphabetB[] = { 0,1,2,3,5,9,10,14,15,16,17,18,20,24,25,29,30,31,32,33 };
__constant__ int alphabetC[] = { 1,2,3,4,5,10,15,20,25,31,32,33,34 };
__constant__ int alphabetD[] = { 0,1,2,3,5,9,10,14,15,19,20,24,25,29,30,31,32,33 };
__constant__ int alphabetE[] = { 0,1,2,3,4,5,10,15,16,17,18,20,25,30,31,32,33,34 };
__constant__ int alphabetH[] = { 0,4,5,9,10,14,15,16,17,18,19,20,24,25,29,30,34 };
__constant__ int alphabetK[] = { 0,4,5,8,10,12,15,16,20,22,25,28,30,34 };
__constant__ int alphabetL[] = { 0,5,10,15,20,25,30,31,32,33,34 };
__constant__ int alphabetO[] = { 1,2,3,5,9,10,14,15,19,20,24,25,29,31,32,33 };
__constant__ int alphabetP[] = { 0,1,2,3,5,9,10,14,15,16,17,18,20,25,30 };
__constant__ int alphabetR[] = { 0,1,2,3,5,9,10,14,15,16,17,18,20,22,25,28,30,34 };
__constant__ int alphabetU[] = { 0,4,5,9,10,14,15,19,20,24,25,29,31,32,33 };
__constant__ int alphabetV[] = { 0,4,5,9,10,14,15,19,20,24,26,28,32 };
__constant__ int alphabetY[] = { 0,4,5,9,11,13,17,22,27,32 };
__constant__ int ExclamationMark[] = { 2,7,12,17,22,32 };
__constant__ int Colon[] = { 12,22 };


__constant__ int DotRadius = 2;
__constant__ int DotGap = 1;
__constant__ int WordGap = 5;

//__constant__


// 把點畫出來
__device__ void DrawDot(uint8_t *Map, int centerX, int centerY, float brightness)
{
	for (int i = -DotRadius; i <= DotRadius; i++)
		for (int j = -DotRadius; j <= DotRadius; j++)
			if (i * i + j * j <= DotRadius * DotRadius)
			{
				ColorV3 dotColor;
				dotColor.r = brightness * 50;
				dotColor.g = brightness * 235;
				dotColor.b = brightness * 255;

				RGBToYUV(Map, centerX + i, centerY + j, dotColor);
			}
}

// 跑每一個點
__device__ void WalkThrough(uint8_t *Map, Vector3 pos, int *alphatbet, int size, int wordIndex, float brightness)
{
	for (int i = 0; i < size; i++)
	{
		int rowIndex = alphatbet[i] % 5;
		int colIndex = alphatbet[i] / 5;

		int centerX = pos.x + (rowIndex - 1) * (DotRadius * 2 + DotGap) + DotRadius;
		centerX += wordIndex * (WordGap + 5 * 2 * DotRadius + 4 * DotGap);								// 每個字的間隔

		int centerY = pos.y + (colIndex - 1) * (DotRadius * 2 + DotGap) + DotRadius;
		DrawDot(Map, centerX, centerY, brightness);
	}
}

// 畫字母
__global__ void RenderAlphabet(uint8_t *Map, Vector3 pos, char *charSet, int size, float brightness, int CameraOffsetY)
{
	int index = blockIdx.x * blockDim.x + threadIdx.x;
	if (index < size && brightness != 0)
	{
		pos = WorldSpaceToScreenSpace(pos.x, pos.y, CameraOffsetY);
		switch (charSet[index])
		{
		case '0':
			WalkThrough(Map, pos, number0, sizeof(number0) / sizeof(int), index, brightness);
			break;
		case '1':
			WalkThrough(Map, pos, number1, sizeof(number1) / sizeof(int), index, brightness);
			break;
		case '2':
			WalkThrough(Map, pos, number2, sizeof(number2) / sizeof(int), index, brightness);
			break;
		case '3':
			WalkThrough(Map, pos, number3, sizeof(number3) / sizeof(int), index, brightness);
			break;
		case 'A':
			WalkThrough(Map, pos, alphabetA, sizeof(alphabetA) / sizeof(int), index, brightness);
			break;
		case 'B':
			WalkThrough(Map, pos, alphabetB, sizeof(alphabetB) / sizeof(int), index, brightness);
			break;
		case 'C':
			WalkThrough(Map, pos, alphabetC, sizeof(alphabetC) / sizeof(int), index, brightness);
			break;
		case 'D':
			WalkThrough(Map, pos, alphabetD, sizeof(alphabetD) / sizeof(int), index, brightness);
			break;
		case 'E':
			WalkThrough(Map, pos, alphabetE, sizeof(alphabetE) / sizeof(int), index, brightness);
			break;
		case 'H':
			WalkThrough(Map, pos, alphabetH, sizeof(alphabetH) / sizeof(int), index, brightness);
			break;
		case 'K':
			WalkThrough(Map, pos, alphabetK, sizeof(alphabetK) / sizeof(int), index, brightness);
			break;
		case 'L':
			WalkThrough(Map, pos, alphabetL, sizeof(alphabetL) / sizeof(int), index, brightness);
			break;
		case 'O':
			WalkThrough(Map, pos, alphabetO, sizeof(alphabetO) / sizeof(int), index, brightness);
			break;
		case 'P':
			WalkThrough(Map, pos, alphabetP, sizeof(alphabetP) / sizeof(int), index, brightness);
			break;
		case 'R':
			WalkThrough(Map, pos, alphabetR, sizeof(alphabetR) / sizeof(int), index, brightness);
			break;
		case 'U':
			WalkThrough(Map, pos, alphabetU, sizeof(alphabetU) / sizeof(int), index, brightness);
			break;
		case 'V':
			WalkThrough(Map, pos, alphabetV, sizeof(alphabetV) / sizeof(int), index, brightness);
			break;
		case 'Y':
			WalkThrough(Map, pos, alphabetY, sizeof(alphabetY) / sizeof(int), index, brightness);
			break;
		case '!':
			WalkThrough(Map, pos, ExclamationMark, sizeof(ExclamationMark) / sizeof(int), index, brightness);
			break;
		case ':':
			WalkThrough(Map, pos, Colon, sizeof(Colon) / sizeof(int), index, brightness);
			break;
		}
	}
}