#pragma once
#include <vector>

#include "SceneSetting.h"
#include "Camera.h"

// �B����T
struct RainInfo
{
	int posX;									// X ����m
	int posY;									// Y ����m
	int posZ;									// Z ����m

	int width;									// �B�Ӽe��

	// �C�ⳡ��
	int StartColor;								// �Y���C��
	int EndColor;								// ���ڪ��C��
};

// �B�I����T
struct RainDrop
{
	int posX;									// X ����m
	int posY;									// Y ����m
	int posZ;									// Z ����m
	int EndY;									// �W�L�o�Ӥ@�w�|�Q�屼

	int speed;									// �W���t��
	int dir;									// ���k���t��
	int color;									// �C��

	int RainDropLength;
};

using namespace std;
class RainClass
{
public:
	static vector<RainInfo> rainArray;
	static vector<RainDrop> rainDropArray;

	// �����H���B�w����T
	static void GenerateRain();
	static void MoveRain();
	static void MoveRainDrop();
	static void GenerateRainDrop(int, int, int, int, int);	// ����L�F��� Call �o�� Function �Ӳ��ͫB�w
	static void AddTime();									// �W�[�ɶ�

	static float Brightness();

	static const int RainLength = 40;
	static const int Speed = 30;

private:
	static int Time;
	static const int FirestBeSeenTime = 3 * 24;
	static const int BrightnessTimeGap = 1 * 24;
};

