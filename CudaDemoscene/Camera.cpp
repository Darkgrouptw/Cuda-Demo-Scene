#include "Camera.h"

int Camera::offsetY = 48;

Vector3 Camera::WorldSpaceToScreenSpace(int x, int y)
{
	Vector3 tempV3;
	tempV3.x = x;
	tempV3.y = SceneSetting::Height - y + Camera::offsetY;
	tempV3.z = 0;
	return tempV3;
}
int Camera::GetCurrentHighestHeight()
{
	// 拿螢幕最上面的高 + Camera 的位移
	return SceneSetting::Height + offsetY;
}
bool Camera::CanBeSeen(int x, int y)
{
	Vector3 pos = WorldSpaceToScreenSpace(x, y);
	if (0 <= pos.x && pos.x < SceneSetting::Width && 0 <= pos.y && pos.y < SceneSetting::Height)
		return true;
	return false;
}
