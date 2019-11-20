#include "DevelopWord.h"
string DevelopWord::word = "DEVELOPED BY DARK";
int DevelopWord::Time = 0;

Vector3 DevelopWord::GetPos()
{
	Vector3 tempPos;
	tempPos.x = posX;
	tempPos.y = posY;
	tempPos.z = 0;

	return tempPos;
}
Vector3 DevelopWord::GetStartTimePos()
{
	Vector3 tempPos;
	tempPos.x = posX + 150;
	tempPos.y = posY - 100;
	tempPos.z = 0;

	return tempPos;
}

bool DevelopWord::CanBeSeen()
{
	if (Time < TimeCount)
	{
		// ®É¶¡++
		Time++;

		return true;
	}
	return false;
}

float DevelopWord::Brightness()
{
	if (CanBeSeen())
	{
		// 0 ~ 1
		if (Time < TimeCount / 5)
			return (float)Time * 5 / TimeCount;

		// 1 ~ 4
		if (Time / 5 <= Time && Time < TimeCount * 4 / 5)
			return 1;

		// 5
		if (TimeCount * 4 / 5 <= Time)
			return  1.0f - (float)(Time - TimeCount * 4 / 5) / (TimeCount / 5);
	}
	return 0;
}

string DevelopWord::FormatStartTime()
{
	if (Time < 3 * 24)
	{
		int sec = 3 - Time / 24;
		return "00:0" + to_string(sec);
	}
	else
		return "00:00";
}

float DevelopWord::FormatStartTimeBrightness()
{
	if (Time < 3 * 24)
		return 1;
	else if (Time < 4 * 24)
		return 1.0f - (float)(Time - 3 * 24) / 24;
	else
		return 0;
}
