#include "RainClass.h"

vector<RainInfo> RainClass::rainArray;
vector<RainDrop> RainClass::rainDropArray;
int RainClass::Time = 0;

void RainClass::GenerateRain()
{
	// 總共要產生幾個點
	int randomNumber = rand() % 20;
	
	int currentHeight = Camera::GetCurrentHighestHeight();
	for (int i = 0; i < randomNumber; i++)
	{
		// 雨的參數
		RainInfo temp;
		temp.posX = rand() % SceneSetting::Width - 60;					// Building 的大小
		temp.posY = currentHeight + rand() % 40 + Camera::offsetY;
		temp.posZ = rand() % 9 - 5;										// 深度
		temp.width = rand() % 2 + 1;
		temp.StartColor = rand() % 100 + 120;
		temp.EndColor = rand() % 50 + 50;

		rainArray.push_back(temp);
	}
}
void RainClass::MoveRain()
{
	for (int i = rainArray.size() - 1; i >= 0; i--)
		rainArray[i].posY -= Speed;
}
void RainClass::MoveRainDrop()
{
	for (int i = rainDropArray.size() - 1; i >= 0; i--)
	{
		rainDropArray[i].posX += rainDropArray[i].dir;
		rainDropArray[i].posY += rainDropArray[i].speed;
		rainDropArray[i].speed -= 2;
	}
}

void RainClass::GenerateRainDrop(int posX, int posY, int posZ, int color, int rainWidth)
{
	// 總共要產生幾個點
	int randomNumber = rand() % 8 + 2;
	for (int i = 0; i < randomNumber; i++)
	{
		RainDrop temp;
		temp.color = color;
		temp.dir = rand() % 11 - 6;
		temp.speed = rand() % 9 + 1;
		temp.posX = posX;
		temp.posY = posY + temp.speed;
		temp.EndY = posY - rand() % 2;
		temp.posZ = posZ;
		temp.RainDropLength = rainWidth * 2;
		rainDropArray.push_back(temp);
	}
}

void RainClass::AddTime()
{
	Time++;
}
float RainClass::Brightness()
{
	if (Time < FirestBeSeenTime)
		return 0;

	if (Time < FirestBeSeenTime + BrightnessTimeGap)
		return (float)(Time - FirestBeSeenTime) / BrightnessTimeGap;
	else
		return 1;
}
