#pragma once
#include "SceneSetting.h"

__device__ Vector3 WorldSpaceToScreenSpace(int X, int Y, int CameraOffsetY)
{
	Vector3 tempV3;
	tempV3.x = X;
	tempV3.y = SceneSetting::Height - Y + CameraOffsetY;
	tempV3.z = 0;
	return tempV3;
}