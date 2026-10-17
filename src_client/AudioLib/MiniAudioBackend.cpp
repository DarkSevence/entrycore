#include "Stdafx.h"
#include "MiniAudioBackend.h"

#define MINIAUDIO_IMPLEMENTATION
#include "../../third_party/client/miniaudio/miniaudio.h"

namespace
{
	struct SMiniSound
	{
		ma_decoder decoder;
		ma_sound sound;
		bool decoderInitialized;
		bool soundInitialized;
	};

	ma_engine g_engine;
	bool g_initialized = false;
}

bool CMiniAudioBackend::Initialize()
{
	if (g_initialized)
		return true;

	if (ma_engine_init(NULL, &g_engine) != MA_SUCCESS)
	{
		TraceError("CMiniAudioBackend::Initialize - ma_engine_init failed");
		return false;
	}

	g_initialized = true;
	return true;
}

void CMiniAudioBackend::Destroy()
{
	if (!g_initialized)
		return;

	ma_engine_uninit(&g_engine);
	g_initialized = false;
}

bool CMiniAudioBackend::CreateSound(const void* data, unsigned int size, bool stream, bool spatial, void** ppSound)
{
	if (!ppSound || !data || !size || !g_initialized)
		return false;

	*ppSound = NULL;
	SMiniSound* pSound = new SMiniSound;
	ZeroMemory(pSound, sizeof(*pSound));

	if (ma_decoder_init_memory(data, size, NULL, &pSound->decoder) != MA_SUCCESS)
	{
		delete pSound;
		return false;
	}
	pSound->decoderInitialized = true;

	ma_uint32 flags = stream ? MA_SOUND_FLAG_STREAM : MA_SOUND_FLAG_DECODE;
	if (ma_sound_init_from_data_source(&g_engine, &pSound->decoder, flags, NULL, &pSound->sound) != MA_SUCCESS)
	{
		ma_decoder_uninit(&pSound->decoder);
		delete pSound;
		return false;
	}
	pSound->soundInitialized = true;

	if (spatial)
	{
		ma_sound_set_spatialization_enabled(&pSound->sound, MA_TRUE);
		ma_sound_set_attenuation_model(&pSound->sound, ma_attenuation_model_inverse);
		ma_sound_set_min_distance(&pSound->sound, 100.0f);
		ma_sound_set_max_distance(&pSound->sound, 20000.0f);
	}

	*ppSound = pSound;
	return true;
}

void CMiniAudioBackend::DestroySound(void* pHandle)
{
	SMiniSound* pSound = static_cast<SMiniSound*>(pHandle);
	if (!pSound)
		return;

	if (pSound->soundInitialized)
		ma_sound_uninit(&pSound->sound);
	if (pSound->decoderInitialized)
		ma_decoder_uninit(&pSound->decoder);
	delete pSound;
}

void CMiniAudioBackend::Play(void* pHandle, int loopCount)
{
	SMiniSound* pSound = static_cast<SMiniSound*>(pHandle);
	if (!pSound)
		return;

	ma_sound_set_looping(&pSound->sound, loopCount != 1 ? MA_TRUE : MA_FALSE);
	ma_sound_start(&pSound->sound);
}

void CMiniAudioBackend::Pause(void* pHandle)
{
	SMiniSound* pSound = static_cast<SMiniSound*>(pHandle);
	if (pSound)
		ma_sound_stop(&pSound->sound);
}

void CMiniAudioBackend::Stop(void* pHandle)
{
	SMiniSound* pSound = static_cast<SMiniSound*>(pHandle);
	if (!pSound)
		return;

	ma_sound_stop(&pSound->sound);
	ma_sound_seek_to_pcm_frame(&pSound->sound, 0);
}

bool CMiniAudioBackend::IsDone(void* pHandle)
{
	SMiniSound* pSound = static_cast<SMiniSound*>(pHandle);
	return !pSound || !ma_sound_is_playing(&pSound->sound);
}

void CMiniAudioBackend::SetVolume(void* pHandle, float volume)
{
	SMiniSound* pSound = static_cast<SMiniSound*>(pHandle);
	if (pSound)
		ma_sound_set_volume(&pSound->sound, volume);
}

float CMiniAudioBackend::GetVolume(void* pHandle)
{
	SMiniSound* pSound = static_cast<SMiniSound*>(pHandle);
	return pSound ? ma_sound_get_volume(&pSound->sound) : 0.0f;
}

void CMiniAudioBackend::SetPosition(void* pHandle, float x, float y, float z)
{
	SMiniSound* pSound = static_cast<SMiniSound*>(pHandle);
	if (pSound)
		ma_sound_set_position(&pSound->sound, x, y, -z);
}

void CMiniAudioBackend::SetVelocity(void* pHandle, float x, float y, float z)
{
	SMiniSound* pSound = static_cast<SMiniSound*>(pHandle);
	if (pSound)
		ma_sound_set_velocity(&pSound->sound, x, y, -z);
}

void CMiniAudioBackend::SetListenerPosition(float x, float y, float z)
{
	if (g_initialized)
		ma_engine_listener_set_position(&g_engine, 0, x, y, -z);
}

void CMiniAudioBackend::SetListenerDirection(float xForward, float yForward, float zForward, float xUp, float yUp, float zUp)
{
	if (g_initialized)
	{
		ma_engine_listener_set_direction(&g_engine, 0, xForward, yForward, -zForward);
		ma_engine_listener_set_world_up(&g_engine, 0, xUp, yUp, -zUp);
	}
}

void CMiniAudioBackend::SetListenerVelocity(float x, float y, float z)
{
	if (g_initialized)
		ma_engine_listener_set_velocity(&g_engine, 0, x, y, -z);
}
