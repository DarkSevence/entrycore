
#include "../../common/stl.h"
#include <cstdint>

class CMapLocation : public singleton<CMapLocation>
{
	public:
		typedef struct SLocation
		{
			int64_t     addr;
			WORD        port;
		} TLocation;    

		bool    Get(int64_t x, int64_t y, int64_t & lMapIndex, int64_t & lAddr, WORD & wPort);
		bool    Get(int64_t x, int64_t y, int64_t & lMapIndex, int32_t & lAddr, WORD & wPort);
		bool	Get(int64_t iIndex, int64_t & lAddr, WORD & wPort);
		bool	Get(int64_t iIndex, int32_t & lAddr, WORD & wPort);
		void    Insert(int64_t lIndex, const char * c_pszHost, WORD wPort);

	protected:
		std::map<int64_t, TLocation> m_map_address;
};      
