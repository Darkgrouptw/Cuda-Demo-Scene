#pragma once
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#include "colorTransfer.cuh"

#include "SceneSetting.h"
#include "SceneSetting.cuh"

#include "RainClass.h"


// 假設 Start 一定會比 End 大
__device__ int lerp(int Start, int End, float CurrentProgress)
{
	if (1 <= CurrentProgress)
		return Start;
	if (0 >= CurrentProgress)
		return End;
	return (Start - End) * CurrentProgress + End;
}

__global__ void RenderRain(uint8_t *Map, RainInfo* data, int size, int CameraOffsetY, float Brightness)
{
	int index = blockIdx.x * blockDim.x + threadIdx.x;
	if (index < size && Brightness != 0)
	{
		// 填雨的點
		RainInfo currentInfo = data[index];
		Vector3 ScreenSpacePos = WorldSpaceToScreenSpace(currentInfo.posX, currentInfo.posY, CameraOffsetY);

		// 要把她拉長
		for (int i = ScreenSpacePos.y; i >= ScreenSpacePos.y - RainClass::RainLength; i--)
		{
			// 代表雨出去了~~
			if (i < 0)
				break;

			// 狀態
			float progress = (float)(ScreenSpacePos.y - i) / RainClass::RainLength;
			int color = lerp(currentInfo.StartColor, currentInfo.EndColor, 1 - progress);

			// 填顏色
			ColorV3 tempColor;
			tempColor.r = Brightness * color;
			tempColor.g = Brightness * color;
			tempColor.b = Brightness * color;

			for(int j = 0; j < currentInfo.width; j++)
				RGBToYUV(Map, ScreenSpacePos.x + j - currentInfo.width / 2, i, tempColor);
		}
	}
}
__global__ void RenderRainDrop(uint8_t * Map, RainDrop *data, int size, int CameraOffsetY, float Brightness)
{
	int index = blockIdx.x * blockDim.x + threadIdx.x;
	if (index < size && Brightness != 0)
	{
		// 填雨滴的點
		RainDrop currentInfo = data[index];
		Vector3 ScreenSpacePos = WorldSpaceToScreenSpace(currentInfo.posX, currentInfo.posY, CameraOffsetY);

		// 要把她拉長
		for (int i = ScreenSpacePos.y; i >= ScreenSpacePos.y - RainClass::RainLength; i--)
		{
			// 代表雨出去了~~
			if (i < 0)
				break;

			// 填顏色
			ColorV3 tempColor;
			tempColor.r = Brightness * currentInfo.color;
			tempColor.g = Brightness * currentInfo.color;
			tempColor.b = Brightness * currentInfo.color;

			for (int j = 0; j < currentInfo.RainDropLength; j++)
				for (int k = 0; k < currentInfo.RainDropLength; k++)
					RGBToYUV(Map, ScreenSpacePos.x - currentInfo.RainDropLength / 2 + j, ScreenSpacePos.y - currentInfo.RainDropLength / 2 + k, tempColor);
		}
	}
}