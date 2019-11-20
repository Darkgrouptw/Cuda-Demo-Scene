#pragma once
#include <vector>

#include "SceneSetting.h"
#include "Camera.h"

// 雨的資訊
struct RainInfo
{
	int posX;									// X 的位置
	int posY;									// Y 的位置
	int posZ;									// Z 的位置

	int width;									// 雨個寬度

	// 顏色部分
	int StartColor;								// 頭的顏色
	int EndColor;								// 尾巴的顏色
};

// 雨點的資訊
struct RainDrop
{
	int posX;									// X 的位置
	int posY;									// Y 的位置
	int posZ;									// Z 的位置
	int EndY;									// 超過這個一定會被砍掉

	int speed;									// 上的速度
	int dir;									// 左右的速度
	int color;									// 顏色

	int RainDropLength;
};

using namespace std;
class RainClass
{
public:
	static vector<RainInfo> rainArray;
	static vector<RainDrop> rainDropArray;

	// 產生隨機雨滴的資訊
	static void GenerateRain();
	static void MoveRain();
	static void MoveRainDrop();
	static void GenerateRainDrop(int, int, int, int, int);	// 讓其他東西來 Call 這個 Function 來產生雨滴
	static void AddTime();									// 增加時間

	static float Brightness();

	static const int RainLength = 40;
	static const int Speed = 30;

private:
	static int Time;
	static const int FirestBeSeenTime = 3 * 24;
	static const int BrightnessTimeGap = 1 * 24;
};

