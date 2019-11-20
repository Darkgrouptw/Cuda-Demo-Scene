#pragma once
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#include "SceneSetting.h"
#include "Ground.h"

__global__ void RenderGound(uint8_t *Map, int CamerOffset)
{
	int index = blockIdx.x * blockDim.x + threadIdx.x;

	if (index < SceneSetting::Width)
	{
		int currentY = Ground::height;

		// 填白色的地面
		ColorV3 tempColor;
		tempColor.r = 255;
		tempColor.g = 255;
		tempColor.b = 255;

		Vector3 pos = WorldSpaceToScreenSpace(index, Ground::height, CamerOffset);
		for(int i = 0; i < Ground::pixelSize; i++)
			RGBToYUV(Map, pos.x, pos.y - Ground::pixelSize / 2 + i, tempColor);
	}
}