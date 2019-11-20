#pragma once
#include <string>

#include "SceneSetting.h"

using namespace std;
class DevelopWord
{
public:
	static Vector3 GetPos();
	static Vector3 GetStartTimePos();
	static bool CanBeSeen();
	static float Brightness();
	static string FormatStartTime();
	static float FormatStartTimeBrightness();


	static int Time;
	static string word;

	static const int TimeCount = 24 * 5;				// 5¬í
private:
	static const int posX = 100;
	static const int posY = 300;
};

