#ifndef __POLY_SYMTABLE_H__
#define __POLY_SYMTABLE_H__

#include <stdint.h>

#include <string>

class CSymTable  
{
    public:
	CSymTable(int32_t aTok, std::string aStr);
	virtual ~CSymTable();

	double		dVal;
	int32_t		token;
	std::string	strlex;
};

#endif 
