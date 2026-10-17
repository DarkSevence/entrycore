#ifndef __AudioLib_CSOUNDDATA_H__
#define __AudioLib_CSOUNDDATA_H__

#include "../eterBase/MappedFile.h"

class CSoundData
{
	public:
		enum
		{
			FLAG_DATA_SIZE = 1,
		};

	public:
		static void		SetPackMode();

		CSoundData();
		virtual ~CSoundData();

		void			Assign(const char* filename);
		LPVOID			Get();
		DWORD				GetSize();
		void			Release();
		DWORD			GetAccessTime();
		const char *	GetFileName();

		void			SetPlayTime(DWORD dwPlayTime);
		DWORD			GetPlayTime();

	protected:
		bool			ReadFromDisk();
		void			Destroy();
		
	protected:
		char			m_filename[128];
		int				m_iRefCount;
		DWORD			m_dwAccessTime;
		DWORD			m_dwPlayTime;
		DWORD				m_size;
		LPVOID			m_data;
		long			m_flag;
		bool			m_assigned;

		CMappedFile		m_MappedFile;
};

#endif
