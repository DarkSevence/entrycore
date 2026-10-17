#include "stdafx.h"
#include "SoundInstance.h"
#include "MiniAudioBackend.h"

CSoundInstanceStream::CSoundInstanceStream() : m_pSound(NULL) {}
CSoundInstanceStream::~CSoundInstanceStream() { Destroy(); }

void CSoundInstanceStream::Destroy()
{
    CMiniAudioBackend::DestroySound(m_pSound);
    m_pSound = NULL;
}

bool CSoundInstanceStream::Initialize() { return true; }

bool CSoundInstanceStream::SetStream(CSoundData* pSoundData)
{
    Destroy();
    if (!pSoundData)
        return false;

    LPVOID pData = pSoundData->Get();
    const bool success = CMiniAudioBackend::CreateSound(pData, pSoundData->GetSize(), true, false, &m_pSound);
    pSoundData->Release();
    return success;
}

bool CSoundInstanceStream::IsDone() const { return CMiniAudioBackend::IsDone(m_pSound); }
bool CSoundInstanceStream::IsData() const { return m_pSound != NULL; }
void CSoundInstanceStream::Play(int count, DWORD) const { CMiniAudioBackend::Play(m_pSound, count); }
void CSoundInstanceStream::Pause() const { CMiniAudioBackend::Pause(m_pSound); }
void CSoundInstanceStream::Resume() const { CMiniAudioBackend::Play(m_pSound, 1); }
void CSoundInstanceStream::Stop() { CMiniAudioBackend::Stop(m_pSound); }
void CSoundInstanceStream::GetVolume(float& rfVolume) const { rfVolume = CMiniAudioBackend::GetVolume(m_pSound); }
void CSoundInstanceStream::SetVolume(float volume) const { CMiniAudioBackend::SetVolume(m_pSound, max(0.0f, min(1.0f, volume))); }
bool CSoundInstanceStream::SetSound(CSoundData* pSound) { return SetStream(pSound); }
void CSoundInstanceStream::SetPosition(float, float, float) const { }
void CSoundInstanceStream::SetOrientation(float, float, float, float, float, float) const { }
void CSoundInstanceStream::SetVelocity(float, float, float, float) const { }