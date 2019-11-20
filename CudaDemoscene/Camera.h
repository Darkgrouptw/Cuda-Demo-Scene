#pragma once
#include "SceneSetting.h"

class Camera
{
public:
	static Vector3 WorldSpaceToScreenSpace(int, int);		// Space �ഫ => (Z �S����)
	static int GetCurrentHighestHeight();					// ����ثe Camera ��Ө�̰���Height
	static bool CanBeSeen(int, int);						// �i�H�Q�ݨ�

	// Camera ���@�ǰѼ�
	//static const int HighestHeight = 530;					// �̰������׬O�h�� (H = 480 + �@�I�I)
	static int offsetY;										// Offset �� Y

	static const int MoveSpeed = 2;							// �첾 (24 �� Frame) 
};

/*
||									O <= (Width, Height + offsetY)
||
||
||
||
||
||
||
0,offsetY = = = = = = = = = = = = = = =
*/
