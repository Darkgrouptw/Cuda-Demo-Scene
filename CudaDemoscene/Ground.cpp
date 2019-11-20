#include "Ground.h"

void Ground::CheckIsHit()
{
	// Check Rain
	for (int i = RainClass::rainArray.size() - 1; i >= 0; i--)
	{
		RainInfo currentRain = RainClass::rainArray[i];
		if (currentRain.posY <= Ground::height)
		{
			// ���� Rain Drop
			RainClass::GenerateRainDrop(currentRain.posX, currentRain.posY, currentRain.posZ, currentRain.StartColor, currentRain.width);
			RainClass::rainArray.erase(RainClass::rainArray.begin() + i);			// �P�_�w�g�I��a�O
		}
	}

	// Check Rain Drop
	for (int i = RainClass::rainDropArray.size() - 1; i >= 0; i--)
	{
		RainDrop currentInfo = RainClass::rainDropArray[i];
		if (currentInfo.posY <= Ground::height)
			RainClass::rainDropArray.erase(RainClass::rainDropArray.begin() + i);			// �P�_�w�g�I��a�O
	}
}