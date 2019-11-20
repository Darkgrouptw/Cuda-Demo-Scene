#include "lab1.h"

// Cuda 相關 .h
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#include "colorTransfer.cuh"

#include "SceneSetting.h"
#include "SceneSetting.cuh"

#include "RainClass.h"
#include "Rain_kernels.cuh"

#include "Ground.h"
#include "Ground_kernels.cuh"

#include "DigtalAlphabet_kernels.cuh"
#include "DevelopWord.h"

#include "Building.h"
#include "Building_kernels.cuh"

#pragma region 初始化設定
static const int NFRAME = 360;										// 總共的 Frame 數

static const int ThreadSize = 12;									// Thread 的 Size

struct Lab1VideoGenerator::Impl {
	int t = 0;
};
Lab1VideoGenerator::Lab1VideoGenerator(): impl(new Impl) {
}
Lab1VideoGenerator::~Lab1VideoGenerator() {}
void Lab1VideoGenerator::get_info(Lab1VideoInfo &info) 
{
	info.w = SceneSetting::Width;
	info.h = SceneSetting::Height;
	info.n_frame = NFRAME;

	// fps = 24/1 = 24
	info.fps_n = 24;
	info.fps_d = 1;
};
#pragma endregion

void Lab1VideoGenerator::Generate(uint8_t *yuv) 
{
	#pragma region 初始化
	cudaMemset(yuv, 0, SceneSetting::Width * SceneSetting::Height);
	cudaMemset(yuv + SceneSetting::Width * SceneSetting::Height, 128, SceneSetting::Width * SceneSetting::Height / 2);
	Building::Init();
	#pragma endregion
	#pragma region Camera 位移
	if (6 * 24 <= impl->t && impl->t < 7 * 24)
		Camera::offsetY -= Camera::MoveSpeed;
	#pragma endregion
	#pragma region RainClass 的相關
	RainClass::GenerateRain();
	RainClass::MoveRain();
	RainClass::MoveRainDrop();
	RainClass::AddTime();
	Building::AddTime();
	
	#pragma region 判斷雨是否有打到東西
	Building::CheckIsHit();
	Ground::CheckIsHit();
	#pragma endregion		
	#pragma region Rain 的 Cuda Part
	RainInfo *HostRainData, *DeviceRainData;
	HostRainData = RainClass::rainArray.data();
	size_t RainInfoSize = sizeof(RainInfo) * RainClass::rainArray.size();

	// Copy 上 Cuda
	cudaMalloc(&DeviceRainData, RainInfoSize);
	cudaMemcpy(DeviceRainData, HostRainData, RainInfoSize, cudaMemcpyHostToDevice);
	#pragma endregion
	#pragma region RainDrop 的 Cuda Part
	RainDrop *HostRainDropData, *DeviceRainDropData;
	HostRainDropData = RainClass::rainDropArray.data();
	size_t RainDropInfoSize = sizeof(RainDrop) * RainClass::rainDropArray.size();

	// Copy 上 Cuda
	cudaMalloc(&DeviceRainDropData, RainDropInfoSize);
	cudaMemcpy(DeviceRainDropData, HostRainDropData, RainDropInfoSize, cudaMemcpyHostToDevice);
	#pragma endregion
	#pragma endregion
	#pragma region 字母相關
	char *HostDevelopWord, *DeviceDevelopWord;
	HostDevelopWord = &DevelopWord::word[0u];
	size_t DevelopWordSize = sizeof(char) * DevelopWord::word.size();

	// Copy 上 Cuda
	cudaMalloc(&DeviceDevelopWord, DevelopWordSize);
	cudaMemcpy(DeviceDevelopWord, HostDevelopWord, DevelopWordSize, cudaMemcpyHostToDevice);

	char *HostStartTime, *DeviceStartTime;
	string currentTime = DevelopWord::FormatStartTime();
	HostStartTime = &currentTime[0u];
	size_t StartTimeSize = sizeof(char) * currentTime.size();

	// Copy 上 Cuda
	cudaMalloc(&DeviceStartTime, StartTimeSize);
	cudaMemcpy(DeviceStartTime, HostStartTime, StartTimeSize, cudaMemcpyHostToDevice);
	#pragma endregion
	#pragma region 房子相關
	Line *HostLineData, *DeviceLineData;
	HostLineData = Building::lineSet.data();
	size_t LineSize = sizeof(Line) * Building::lineSet.size();

	// Copy 上 Cuda
	cudaMalloc(&DeviceLineData, LineSize);
	cudaMemcpy(DeviceLineData, HostLineData, LineSize, cudaMemcpyHostToDevice);

	// 文字
	char *HostBuildingText, *DeviceBuildingText;
	HostBuildingText = &Building::text[0u];
	size_t BuildingTextSize = sizeof(char) * Building::text.size();

	// Copy 上 Cuda
	cudaMalloc(&DeviceBuildingText, BuildingTextSize);
	cudaMemcpy(DeviceBuildingText, HostBuildingText, BuildingTextSize, cudaMemcpyHostToDevice);

	// 破文字
	char *HostBrokenText, *DeviceBrokenText;
	HostBrokenText = &Building::BrokenText[0u];
	size_t BrokenTextSize = sizeof(char) * Building::BrokenText.size();

	// Copy 上 Cuda
	cudaMalloc(&DeviceBrokenText, BrokenTextSize);
	cudaMemcpy(DeviceBrokenText, HostBrokenText, BrokenTextSize, cudaMemcpyHostToDevice);
	#pragma endregion
	#pragma region 畫東西
	#pragma region 雨
	int RainBlockSize = RainClass::rainArray.size() / ThreadSize + 1;
	RenderRain << <RainBlockSize, ThreadSize >> > (yuv, DeviceRainData, RainClass::rainArray.size(), Camera::offsetY, RainClass::Brightness());
	
	int RainDropBlockSize = RainClass::rainDropArray.size() / ThreadSize + 1;
	RenderRainDrop << <RainDropBlockSize, ThreadSize >> > (yuv, DeviceRainDropData, RainClass::rainDropArray.size(), Camera::offsetY, RainClass::Brightness());
	#pragma endregion
	#pragma region 地面
	int GroundBlockSize = SceneSetting::Width / ThreadSize + 1;
	RenderGound << <GroundBlockSize, ThreadSize >> > (yuv, Camera::offsetY);
	#pragma endregion
	#pragma region 字母
	int AlphabetBlockSize = DevelopWord::word.size() / ThreadSize + 1;
	RenderAlphabet << <AlphabetBlockSize, ThreadSize >> > (yuv, DevelopWord::GetPos(), DeviceDevelopWord, DevelopWord::word.size(), DevelopWord::Brightness(), Camera::offsetY);

	int StartTimeBlockSize = currentTime.size() / ThreadSize + 1;
	RenderAlphabet << <StartTimeBlockSize, ThreadSize >> > (yuv, DevelopWord::GetStartTimePos(), DeviceStartTime, currentTime.size(), DevelopWord::FormatStartTimeBrightness(), Camera::offsetY);
	#pragma endregion
	#pragma region 房子
	int BuildingBlockSize = Building::lineSet.size() / ThreadSize + 1;
	RenderLine << <BuildingBlockSize, ThreadSize >> > (yuv, DeviceLineData, Building::lineSet.size(), Building::BuildingBrightness(), Camera::offsetY);

	int BuildingTextBlockSize = Building::text.size() / ThreadSize + 1;
	RenderAlphabet << <AlphabetBlockSize, ThreadSize >> > (yuv, Building::GetTextPos(), DeviceBuildingText, Building::text.size(), 1, Camera::offsetY);

	int BrokenTextBlockSize = Building::BrokenText.size() / ThreadSize + 1;
	RenderAlphabet << <BrokenTextBlockSize, ThreadSize >> > (yuv, Building::GetBrokenTextPos(), DeviceBrokenText, Building::BrokenText.size(), Building::BrokenTextBrightness(), Camera::offsetY);
	#pragma endregion
	#pragma endregion
	#pragma region 刪除拉機記憶體
	#pragma region 雨
	cudaFree(DeviceRainData);
	cudaFree(DeviceRainDropData);
	#pragma endregion
	#pragma region 字
	cudaFree(DeviceDevelopWord);
	#pragma endregion
	#pragma region 房子
	cudaFree(DeviceLineData);
	cudaFree(DeviceBuildingText);
	cudaFree(DeviceBrokenText);
	#pragma endregion
	#pragma endregion

	// 時間更新
	++(impl->t);
}
