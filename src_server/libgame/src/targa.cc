#include "../../libthecore/include/stdafx.h"
#include <stdio.h>
#include <string.h>
#include "targa.h"

CTargaImage::CTargaImage()
	: m_pbuf(NULL), m_x(0), m_y(0)
{
	memset( &m_header, 0, sizeof(m_header) );
}

static size_t GetImageSize(int32_t x, int32_t y)
{
    return (size_t) x * (size_t) y * sizeof(uint32_t);
}

CTargaImage::~CTargaImage()
{
    if (m_pbuf)
	delete [] m_pbuf;
}

char * CTargaImage::GetBasePointer(int32_t line)
{
    return m_pbuf + ((size_t) m_x * (size_t) line) * sizeof(uint32_t);
}

void CTargaImage::Create(int32_t x, int32_t y)
{
    size_t size = GetImageSize(x, y);

    memset(&m_header, 0, sizeof(m_header));

    m_header.imgType	= 2;
    m_header.width	= x;
    m_header.height	= y;
    m_header.colorBits	= 32;
    m_header.desc	= 0x20;

    m_pbuf = new char[size];
    memset(m_pbuf, 0, size);

    m_x = x;
    m_y = y;
}

bool CTargaImage::Save(const char * filename)
{
    FILE * fp = fopen(filename, "wb");

    if (!fp)
	return false;

    fwrite(&m_header, sizeof(TGA_HEADER), 1, fp);
    fwrite(m_pbuf, GetImageSize(m_x, m_y), 1, fp);

    fclose(fp);
    return true;
}

