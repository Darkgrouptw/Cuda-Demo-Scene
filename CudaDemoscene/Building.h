#pragma once
#include <vector>
#include <cmath>

#include "SceneSetting.h"
#include "RainClass.h"

using namespace std;
struct Line
{
	int posStartX, posEndX;
	int posStartY, posEndY;
};
class Building
{
public:
	static string text;
	static string BrokenText;
	static vector<Line> lineSet;

	static Vector3 GetTextPos();
	static Vector3 GetBrokenTextPos();
	static void CheckIsHit();
	static float BuildingBrightness();
	static float BrokenTextBrightness();
	static void AddTime();

	static bool IsInit;
	static void Init();

	static const int lineWidth = 3;
private:
	static const int posXSet[];
	static const int posYSet[];
	static const int hitIndex[];					// 要判斷可以被打到的 index


	static int Time;
	static const int FirestBeSeenTime = 3 * 24;
	static const int BrightnessTimeGap = 1 * 24;
};

