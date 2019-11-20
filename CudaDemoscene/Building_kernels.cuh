#pragma once
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#include "SceneSetting.h"
#include "SceneSetting.cuh"
#include "colorTransfer.cuh"
#include "Building.h"

__global__ void RenderLine(uint8_t *Map, Line *data, int size, float Brightness, int CameraOffset)
{
	int index = blockIdx.x * blockDim.x + threadIdx.x;
	if (index < size && Brightness != 0)
	{
		Vector3 posStart = WorldSpaceToScreenSpace(data[index].posStartX, data[index].posStartY, CameraOffset);
		Vector3 posEnd = WorldSpaceToScreenSpace(data[index].posEndX,data[index].posEndY,CameraOffset);

		ColorV3 tempColor;
		tempColor.r = Brightness * 255;
		tempColor.g = Brightness * 255;
		tempColor.b = Brightness * 255;

		if (posStart.x == posEnd.x)
		{
			int dy;
			if (posEnd.y > posStart.y)
				dy = 1;
			else
				dy = -1;
			for (int i = posStart.y; i <= posEnd.y; i += dy)
				for(int j = 0; j < Building::lineWidth; j++)
					RGBToYUV(Map, posStart.x + j - Building::lineWidth / 2, i , tempColor);
		}
		else
		{
			int dx;
			if (posEnd.x > posStart.x)
				dx = 1;
			else
				dx = -1;
			for (int i = posStart.x; i <= posEnd.x; i += dx)
				for (int j = 0; j < Building::lineWidth; j++)
					RGBToYUV(Map, i, posStart.y + j - Building::lineWidth / 2, tempColor);
		}
	}
}