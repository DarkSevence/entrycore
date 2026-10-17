#ifndef __INC_METIN_II_VID_H__
#define __INC_METIN_II_VID_H__

#include <boost/container_hash/hash.hpp>

class VID
{
	public:
		VID() : m_id(0), m_crc(0) {}
		VID(DWORD id, DWORD crc) : m_id(id), m_crc(crc) {}

		VID(const VID &rvid) { *this = rvid; }

		const VID & operator = (const VID & rhs)
		{
			m_id = rhs.m_id;
			m_crc = rhs.m_crc;
			return *this;
		}

		bool operator == (const VID & rhs) const
		{
			return (m_id == rhs.m_id) && (m_crc == rhs.m_crc);
		}

		bool operator != (const VID & rhs) const
		{
			return !(*this == rhs);
		}

		operator DWORD() const { return m_id; }

		void Reset() { m_id = 0; m_crc = 0; }

		friend std::size_t hash_value(VID const& v) noexcept
		{
			std::size_t seed = 0;
			boost::hash_combine(seed, v.m_id);
			boost::hash_combine(seed, v.m_crc);
			return seed;
		}

	private:
		DWORD m_id;
		DWORD m_crc;
};

#endif
