#include "stdafx.h"
#include "SoundManager3D.h"
#include "MiniAudioBackend.h"
#include "../eterBase/Timer.h"

CSoundInstance3D::CSoundInstance3D() : m_pSound(NULL), m_pSoundData(NULL)
{
}

CSoundInstance3D::~CSoundInstance3D()
{
    Destroy();
}

void CSoundInstance3D::Destroy()
{
    CMiniAudioBackend::DestroySound(m_pSound);
    m_pSound = NULL;
    SAFE_RELEASE(m_pSoundData);
}

bool CSoundInstance3D::Initialize()
{
    return true;
}

bool CSoundInstance3D::SetSound(CSoundData* pSoundData)
{
    if (!pSoundData)
        return false;

    Destroy();
    LPVOID pData = pSoundData->Get();
    if (!CMiniAudioBackend::CreateSound(pData, pSoundData->GetSize(), false, true, &m_pSound))
    {
        pSoundData->Release();
        TraceError("CSoundInstance3D::SetSound - cannot decode %s", pSoundData->GetFileName());
        return false;
    }

    m_pSoundData = pSoundData;
    CMiniAudioBackend::SetPosition(m_pSound, 0.0f, 0.0f, 0.0f);
    return true;
}

bool CSoundInstance3D::IsDone() const { return CMiniAudioBackend::IsDone(m_pSound); }

void CSoundInstance3D::Play(int iLoopCount, DWORD dwPlayCycleTimeLimit) const
{
    if (!m_pSoundData)
        return;
    DWORD dwCurTime = ELTimer_GetMSec();
    if (dwCurTime - m_pSoundData->GetPlayTime() < dwPlayCycleTimeLimit)
        return;
    m_pSoundData->SetPlayTime(dwCurTime);
    CMiniAudioBackend::Play(m_pSound, iLoopCount);
}

void CSoundInstance3D::Pause() const { CMiniAudioBackend::Pause(m_pSound); }
void CSoundInstance3D::Resume() const { CMiniAudioBackend::Play(m_pSound, 1); }
void CSoundInstance3D::Stop() { CMiniAudioBackend::Stop(m_pSound); }
void CSoundInstance3D::GetVolume(float& rfVolume) const { rfVolume = CMiniAudioBackend::GetVolume(m_pSound); }
void CSoundInstance3D::SetVolume(float volume) const { CMiniAudioBackend::SetVolume(m_pSound, max(0.0f, min(1.0f, volume))); }
void CSoundInstance3D::SetPosition(float x, float y, float z) const { CMiniAudioBackend::SetPosition(m_pSound, x, y, z); }
void CSoundInstance3D::SetOrientation(float, float, float, float, float, float) const { }
void CSoundInstance3D::SetVelocity(float x, float y, float z, float) const { CMiniAudioBackend::SetVelocity(m_pSound, x, y, z); }
void CSoundInstance3D::UpdatePosition(float) { }