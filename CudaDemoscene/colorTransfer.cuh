#pragma once
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#include "SceneSetting.h"

// �N�쥻���Ϥ��q RGB YUV
__device__ void RGBToYUV(uint8_t *yuvMap, int indexX, int indexY, ColorV3 rgbMap)
{
	// �P�_���S���b�ù��̭�
	if (0 <= indexX  && indexX < SceneSetting::Width && 0 <= indexY && indexY < SceneSetting::Height)
	{
		#pragma region �ഫ�� Y U V
		float Y = 0.299f	* rgbMap.r + 0.587f	* rgbMap.g + 0.114f	* rgbMap.b;
		float U = -0.169f	* rgbMap.r + -0.331f	* rgbMap.g + 0.5f		* rgbMap.b + 128;
		float V = 0.5f		* rgbMap.r + -0.419f	* rgbMap.g + -0.081f	* rgbMap.b + 128;
		#pragma endregion
		#pragma region ��J Y U V �� Map ��
		// �����Ϥ� http://any2yuv.sourceforge.net/images/yuv_planar.png

		int index1D = indexY * SceneSetting::Width + indexX;
		yuvMap[index1D] = Y;

		index1D = indexY / 2 * SceneSetting::Width / 2 + indexX / 2;

		// �u�����W���~��
		if (indexX % 2 == 0 && indexY % 2 == 0)
		{
			yuvMap[SceneSetting::Width * SceneSetting::Height + index1D] = U;
			yuvMap[(int)(SceneSetting::Width * SceneSetting::Height * 1.25f) + index1D] = V;
		}
		#pragma endregion
	}
}
