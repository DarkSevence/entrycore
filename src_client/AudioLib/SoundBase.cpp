#include "Stdafx.h"
#include "SoundBase.h"
#include "MiniAudioBackend.h"

TSoundDataMap			CSoundBase::ms_dataMap;
int						CSoundBase::ms_iRefCount = 0;

CSoundBase::CSoundBase()
{
}

CSoundBase::~CSoundBase()
{
}

void CSoundBase::Destroy()
{
	if (ms_iRefCount > 1)
	{
		--ms_iRefCount;
		return;
	}

	ms_iRefCount = 0;

	if (!ms_dataMap.empty())
	{
		TSoundDataMap::iterator i;
		for (i = ms_dataMap.begin(); i != ms_dataMap.end(); ++i)
		{
			CSoundData * pSoundData = i->second;
			delete pSoundData;
		}

		ms_dataMap.clear();
	}

	CMiniAudioBackend::Destroy();
}

void CSoundBase::Initialize()
{
	++ms_iRefCount;

	if (ms_iRefCount > 1)
		return;
	
	ms_dataMap.clear();
	CMiniAudioBackend::Initialize();
}

DWORD CSoundBase::GetFileCRC(const char * filename)
{
	return GetCRC32(filename, strlen(filename));
}

CSoundData * CSoundBase::AddFile(DWORD dwFileCRC, const char* filename)
{
	CSoundData * pSoundData = new CSoundData;
	pSoundData->Assign(filename);
	ms_dataMap.insert(TSoundDataMap::value_type(dwFileCRC, pSoundData));
	return pSoundData;
}
