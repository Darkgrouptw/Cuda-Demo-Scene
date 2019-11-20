#include "Building.h"

string Building::text = "HELLO C DA!!";
string Building::BrokenText = "U";
vector<Line> Building::lineSet;
int Building::Time = 0;

void Building::Init()
{
	if (!IsInit)
	{
		for (int i = 0; i < 14; i += 2)
		{
			Line temp;
			temp.posStartX = posXSet[i];
			temp.posStartY = posYSet[i];
			temp.posEndX = posXSet[i + 1];
			temp.posEndY = posYSet[i + 1];
			lineSet.push_back(temp);
		}
		IsInit = true;
	}
}
Vector3 Building::GetTextPos()
{
	Vector3 pos;
	pos.x = 215;
	pos.y = 380;
	pos.z = 0;
	return pos;
}
Vector3 Building::GetBrokenTextPos()
{
	Vector3 pos;
	pos.x = 418;
	pos.y = 380;
	pos.z = 0;
	return pos;
}

void Building::CheckIsHit()
{
	for (int i = 0; i < RainClass::rainArray.size(); i++)
	{
		RainInfo currentRain = RainClass::rainArray[i];
		if (-3 <= currentRain.posZ && currentRain.posZ <= 3)
			for (int j = 0; j < 3; j++)
				if (posXSet[hitIndex[j]] <= currentRain.posX && currentRain.posX <= posXSet[hitIndex[j + 1]] && posYSet[hitIndex[j]] >= currentRain.posY)
				{
					// 產生 Rain Drop
					RainClass::GenerateRainDrop(currentRain.posX, currentRain.posY, currentRain.posZ, currentRain.StartColor, currentRain.width);
					RainClass::rainArray.erase(RainClass::rainArray.begin() + i);				// 判斷已經碰到東西
					break;
				}
	}

	// Check Rain Drop
	for (int i = RainClass::rainDropArray.size() - 1; i >= 0; i--)
	{
		RainDrop currentRainDrop = RainClass::rainDropArray[i];
		if (-3 <= currentRainDrop.posZ && currentRainDrop.posZ <= 3)
			for (int j = 0; j < 3; j++)
				if (posXSet[hitIndex[j]] <= currentRainDrop.posX && currentRainDrop.posX <= posXSet[hitIndex[j + 1]] && posYSet[hitIndex[j]] >= currentRainDrop.posY)
				{
					RainClass::rainDropArray.erase(RainClass::rainDropArray.begin() + i);			// 判斷已經碰到東西
					break;
				}
				else if (currentRainDrop.posY <= currentRainDrop.EndY)
				{
					RainClass::rainDropArray.erase(RainClass::rainDropArray.begin() + i);			// 超過界線範圍
					break;
				}
	}
}
float Building::BuildingBrightness()
{
	if (Time < FirestBeSeenTime)
		return 0;

	if (Time < FirestBeSeenTime + BrightnessTimeGap)
		return (float)(Time - FirestBeSeenTime) / BrightnessTimeGap;
	else
		return 1;
}
float Building::BrokenTextBrightness()
{
	float wave = sin(Time / 12) + cos(5 * Time / 12);
	if (wave > 1.5f)
		return 1;
	else
		return (wave + 2) / 3.5f;
}

void Building::AddTime()
{
	Time++;
}

/*
Private 區塊
*/
bool Building::IsInit = false;
const int Building::posXSet[] = {
	// 建築物的牆
	600, 600,

	// 內框框
	200, 560,
	200, 200,
	200, 560,
	560, 560,

	// 連結到 Building
	560, 600,
	560, 600,
};
const int Building::posYSet[] = {
	800, 20,

	400, 400,
	400, 340,
	340, 340,
	400, 340,

	390, 390,
	350, 350,
};
const int Building::hitIndex[] = {
	2, 10, 12
};

