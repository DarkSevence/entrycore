#pragma once

class CMiniAudioBackend
{
public:
	static bool Initialize();
	static void Destroy();

	static bool CreateSound(const void* data, unsigned int size, bool stream, bool spatial, void** ppSound);
	static void DestroySound(void* pSound);
	static void Play(void* pSound, int loopCount);
	static void Pause(void* pSound);
	static void Stop(void* pSound);
	static bool IsDone(void* pSound);
	static void SetVolume(void* pSound, float volume);
	static float GetVolume(void* pSound);
	static void SetPosition(void* pSound, float x, float y, float z);
	static void SetVelocity(void* pSound, float x, float y, float z);

	static void SetListenerPosition(float x, float y, float z);
	static void SetListenerDirection(float xForward, float yForward, float zForward, float xUp, float yUp, float zUp);
	static void SetListenerVelocity(float x, float y, float z);
};
