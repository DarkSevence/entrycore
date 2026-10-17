#include "Stdafx.h"
#include "SoundManager3D.h"
#include "MiniAudioBackend.h"

CSoundManager3D::CSoundManager3D() : m_bInit(false) {}
CSoundManager3D::~CSoundManager3D() {}

bool CSoundManager3D::Initialize()
{
    CSoundBase::Initialize();
    if (m_bInit)
        return true;
    SetListenerPosition(0.0f, 0.0f, 0.0f);
    for (int i = 0; i < INSTANCE_MAX_COUNT; ++i)
    {
        m_Instances[i].Initialize();
        m_bLockingFlag[i] = false;
    }
    m_bInit = true;
    return true;
}

void CSoundManager3D::Destroy()
{
    if (!m_bInit)
        return;
    for (int i = 0; i < INSTANCE_MAX_COUNT; ++i)
        m_Instances[i].Destroy();
    CSoundBase::Destroy();
    m_bInit = false;
}

void CSoundManager3D::SetListenerDirection(float fxDir, float fyDir, float fzDir, float fxUp, float fyUp, float fzUp)
{
    CMiniAudioBackend::SetListenerDirection(fxDir, fyDir, fzDir, fxUp, fyUp, fzUp);
}
void CSoundManager3D::SetListenerPosition(float fX, float fY, float fZ)
{
    CMiniAudioBackend::SetListenerPosition(fX, fY, fZ);
}
void CSoundManager3D::SetListenerVelocity(float x, float y, float z, float)
{
    CMiniAudioBackend::SetListenerVelocity(x, y, z);
}

int CSoundManager3D::SetInstance(const char* c_pszFileName)
{
    DWORD crc = GetFileCRC(c_pszFileName);
    TSoundDataMap::iterator it = ms_dataMap.find(crc);
    CSoundData* pSoundData = it == ms_dataMap.end() ? AddFile(crc, c_pszFileName) : it->second;
    static DWORD k = 0;
    for (DWORD i = 0; i < INSTANCE_MAX_COUNT; ++i)
    {
        const DWORD index = (k++ % INSTANCE_MAX_COUNT);
        CSoundInstance3D* pInstance = &m_Instances[index];
        if (pInstance->IsDone())
        {
            if (!pInstance->SetSound(pSoundData))
            {
                TraceError("CSoundManager3D::SetInstance - %s", c_pszFileName);
                return -1;
            }
            return static_cast<int>(index);
        }
    }
    return -1;
}

ISoundInstance* CSoundManager3D::GetInstance(DWORD index)
{
    return index < INSTANCE_MAX_COUNT ? &m_Instances[index] : NULL;
}

__forceinline bool CSoundManager3D::IsValidInstanceIndex(int index)
{
    return index >= 0 && index < INSTANCE_MAX_COUNT;
}
void CSoundManager3D::Lock(int index) { if (IsValidInstanceIndex(index)) m_bLockingFlag[index] = true; }
void CSoundManager3D::Unlock(int index) { if (IsValidInstanceIndex(index)) m_bLockingFlag[index] = false; }