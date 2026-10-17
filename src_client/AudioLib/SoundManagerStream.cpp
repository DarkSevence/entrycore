#include "stdafx.h"
#include "SoundManagerStream.h"

CSoundManagerStream::CSoundManagerStream() {}
CSoundManagerStream::~CSoundManagerStream() {}

bool CSoundManagerStream::Initialize()
{
    CSoundBase::Initialize();
    for (int i = 0; i < MUSIC_INSTANCE_MAX_NUM; ++i)
        m_Instances[i].Initialize();
    return true;
}

void CSoundManagerStream::Destroy()
{
    for (int i = 0; i < MUSIC_INSTANCE_MAX_NUM; ++i)
        m_Instances[i].Destroy();
    CSoundBase::Destroy();
}

bool CSoundManagerStream::SetInstance(DWORD dwIndex, const char* filename)
{
    if (!CheckInstanceIndex(dwIndex))
        return false;

    const DWORD crc = GetFileCRC(filename);
    TSoundDataMap::iterator it = ms_dataMap.find(crc);
    CSoundData* pSoundData = it == ms_dataMap.end() ? AddFile(crc, filename) : it->second;
    if (!m_Instances[dwIndex].SetStream(pSoundData))
    {
        TraceError("CSoundManagerStream::SetInstance - Failed to decode %s", filename);
        return false;
    }
    return true;
}

CSoundInstanceStream* CSoundManagerStream::GetInstance(DWORD dwIndex)
{
    return CheckInstanceIndex(dwIndex) ? &m_Instances[dwIndex] : NULL;
}

bool CSoundManagerStream::CheckInstanceIndex(DWORD dwIndex)
{
    return dwIndex < DWORD(MUSIC_INSTANCE_MAX_NUM);
}