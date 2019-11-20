#pragma once
#include "SceneSetting.h"
#include "RainClass.h"

class Ground
{
public:
	static void CheckIsHit();								// 判斷雨有打到地面
			
	// 陸地的 info
	static const int height = 20;							// 寬度
	static const int pixelSize = 3;							// 地面要畫幾個 pixel
};

