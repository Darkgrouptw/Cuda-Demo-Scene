#pragma once
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#include "SceneSetting.h"

// 將原本的圖片從 RGB YUV
__device__ void RGBToYUV(uint8_t *yuvMap, int indexX, int indexY, ColorV3 rgbMap)
{
	// 判斷有沒有在螢幕裡面
	if (0 <= indexX  && indexX < SceneSetting::Width && 0 <= indexY && indexY < SceneSetting::Height)
	{
		#pragma region 轉換成 Y U V
		float Y = 0.299f	* rgbMap.r + 0.587f	* rgbMap.g + 0.114f	* rgbMap.b;
		float U = -0.169f	* rgbMap.r + -0.331f	* rgbMap.g + 0.5f		* rgbMap.b + 128;
		float V = 0.5f		* rgbMap.r + -0.419f	* rgbMap.g + -0.081f	* rgbMap.b + 128;
		#pragma endregion
		#pragma region 填入 Y U V 的 Map 裡
		// 說明圖片 http://any2yuv.sourceforge.net/images/yuv_planar.png

		int index1D = indexY * SceneSetting::Width + indexX;
		yuvMap[index1D] = Y;

		index1D = indexY / 2 * SceneSetting::Width / 2 + indexX / 2;

		// 只有左上角才填
		if (indexX % 2 == 0 && indexY % 2 == 0)
		{
			yuvMap[SceneSetting::Width * SceneSetting::Height + index1D] = U;
			yuvMap[(int)(SceneSetting::Width * SceneSetting::Height * 1.25f) + index1D] = V;
		}
		#pragma endregion
	}
}
