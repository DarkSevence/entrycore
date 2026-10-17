#include "StdAfx.h"
#include "SoundData.h"

#include "../EterPack/EterPackManager.h"
#include "../eterBase/Timer.h"

const char* CSoundData::GetFileName()
{
    return m_filename;
}

void CSoundData::Assign(const char* filename)
{
    assert(!m_assigned);
    strncpy(m_filename, filename, sizeof(m_filename) - 1);
    m_filename[sizeof(m_filename) - 1] = '\0';
    m_assigned = true;
}

LPVOID CSoundData::Get()
{
    ++m_iRefCount;
    m_dwAccessTime = ELTimer_GetMSec();
    if (!m_data)
        ReadFromDisk();
    return m_data;
}

DWORD CSoundData::GetSize()
{
    if (!m_data)
        Get();
    return m_size;
}

void CSoundData::Release()
{
    if (m_iRefCount > 0)
        --m_iRefCount;
    m_dwAccessTime = ELTimer_GetMSec();
}

DWORD CSoundData::GetPlayTime()
{
    return m_dwPlayTime;
}

void CSoundData::SetPlayTime(DWORD dwPlayTime)
{
    m_dwPlayTime = dwPlayTime;
}

DWORD CSoundData::GetAccessTime()
{
    return m_dwAccessTime;
}

bool CSoundData::ReadFromDisk()
{
    assert(m_assigned);
    LPCVOID pData = NULL;
    if (!CEterPackManager::Instance().Get(m_MappedFile, m_filename, &pData) || !pData)
        return false;

    m_data = const_cast<LPVOID>(pData);
    m_size = m_MappedFile.Size();
    return m_size != 0;
}

void CSoundData::SetPackMode()
{
}

void CSoundData::Destroy()
{
    m_MappedFile.Destroy();
    m_data = NULL;
    m_size = 0;
}

CSoundData::CSoundData() :
    m_assigned(false),
    m_iRefCount(0),
    m_dwPlayTime(0),
    m_dwAccessTime(ELTimer_GetMSec()),
    m_size(0),
    m_data(NULL),
    m_flag(0)
{
}

CSoundData::~CSoundData()
{
    Destroy();
}
