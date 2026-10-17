#include "stdafx.h"
#include "SoundManager2D.h"
#include "MiniAudioBackend.h"

CSoundInstance2D::CSoundInstance2D() : m_pSound(NULL), m_pSoundData(NULL)
{
}

CSoundInstance2D::~CSoundInstance2D()
{
    Destroy();
}

void CSoundInstance2D::Destroy()
{
    CMiniAudioBackend::DestroySound(m_pSound);
    m_pSound = NULL;
    SAFE_RELEASE(m_pSoundData);
}

bool CSoundInstance2D::Initialize()
{
    return true;
}

bool CSoundInstance2D::SetSound(CSoundData* pSoundData)
{
    if (!pSoundData)
        return false;

    Destroy();
    LPVOID pData = pSoundData->Get();
    if (!CMiniAudioBackend::CreateSound(pData, pSoundData->GetSize(), false, false, &m_pSound))
    {
        pSoundData->Release();
        TraceError("CSoundInstance2D::SetSound - cannot decode %s", pSoundData->GetFileName());
        return false;
    }

    m_pSoundData = pSoundData;
    return true;
}

bool CSoundInstance2D::IsDone() const
{
    return CMiniAudioBackend::IsDone(m_pSound);
}

void CSoundInstance2D::Play(int iLoopCount, DWORD) const
{
    CMiniAudioBackend::Play(m_pSound, iLoopCount);
}

void CSoundInstance2D::Pause() const { CMiniAudioBackend::Pause(m_pSound); }
void CSoundInstance2D::Resume() const { CMiniAudioBackend::Play(m_pSound, 1); }
void CSoundInstance2D::Stop() { CMiniAudioBackend::Stop(m_pSound); }
void CSoundInstance2D::GetVolume(float& rfVolume) const { rfVolume = CMiniAudioBackend::GetVolume(m_pSound); }
void CSoundInstance2D::SetVolume(float volume) const { CMiniAudioBackend::SetVolume(m_pSound, max(0.0f, min(1.0f, volume))); }
void CSoundInstance2D::SetPosition(float, float, float) const { assert(!"2D sound has no position"); }
void CSoundInstance2D::SetOrientation(float, float, float, float, float, float) const { assert(!"2D sound has no orientation"); }
void CSoundInstance2D::SetVelocity(float, float, float, float) const { assert(!"2D sound has no velocity"); }