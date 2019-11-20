#pragma once
#include "SceneSetting.h"

class Camera
{
public:
	static Vector3 WorldSpaceToScreenSpace(int, int);		// Space 轉換 => (Z 沒有用)
	static int GetCurrentHighestHeight();					// 拿到目前 Camera 能照到最高的Height
	static bool CanBeSeen(int, int);						// 可以被看見

	// Camera 的一些參數
	//static const int HighestHeight = 530;					// 最高的高度是多少 (H = 480 + 一點點)
	static int offsetY;										// Offset 的 Y

	static const int MoveSpeed = 2;							// 位移 (24 個 Frame) 
};

/*
||									O <= (Width, Height + offsetY)
||
||
||
||
||
||
||
0,offsetY = = = = = = = = = = = = = = =
*/
