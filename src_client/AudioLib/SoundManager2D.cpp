#include "Stdafx.h"
#include "SoundManager2D.h"

CSoundManager2D::CSoundManager2D() {}
CSoundManager2D::~CSoundManager2D() {}

bool CSoundManager2D::Initialize()
{
    CSoundBase::Initialize();
    for (int i = 0; i < INSTANCE_MAX_COUNT; ++i)
        ms_Instances[i].Initialize();
    return true;
}

void CSoundManager2D::Destroy()
{
    for (int i = 0; i < INSTANCE_MAX_COUNT; ++i)
        ms_Instances[i].Destroy();
    CSoundBase::Destroy();
}

ISoundInstance* CSoundManager2D::GetInstance(const char* c_pszFileName)
{
    DWORD dwFileCRC = GetFileCRC(c_pszFileName);
    TSoundDataMap::iterator it = ms_dataMap.find(dwFileCRC);
    CSoundData* pSoundData = it == ms_dataMap.end() ? AddFile(dwFileCRC, c_pszFileName) : it->second;

    static DWORD k = 0;
    DWORD start = k++;
    for (DWORD i = 0; i < INSTANCE_MAX_COUNT; ++i)
    {
        CSoundInstance2D* pInstance = &ms_Instances[(start + i) % INSTANCE_MAX_COUNT];
        if (pInstance->IsDone())
        {
            if (!pInstance->SetSound(pSoundData))
                TraceError("CSoundManager2D::GetInstance - %s", c_pszFileName);
            return pInstance;
        }
    }
    return NULL;
}
