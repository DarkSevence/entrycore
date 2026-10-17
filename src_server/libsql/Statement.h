#ifndef __INC_METIN_II_LIBSQL_STATEMENT_H__
#define __INC_METIN_II_LIBSQL_STATEMENT_H__

#include "AsyncSQL.h"

#include <string>
#include <cstddef>
#include <cstdint>
#include <vector>

class CStmt
{
	public:
		CStmt();
		virtual ~CStmt();

		bool    Prepare(CAsyncSQL * sql, const char * c_pszQuery);
		bool    BindParam(enum_field_types type, void * p, unsigned long iMaxLen=0);
		bool    BindResult(enum_field_types type, void * p, unsigned long iMaxLen=0);
		int32_t	Execute();
		bool    Fetch();

		void    Error(const char * c_pszMsg);

	public:
		uint64_t	iRows;

	private:
		void    Destroy();

		MYSQL_STMT *            m_pkStmt;

		std::string             m_stQuery;

		std::vector<MYSQL_BIND> m_vec_param;
		size_t                  m_uiParamCount;
		unsigned long *	m_puiParamLen;

		std::vector<MYSQL_BIND> m_vec_result;
		size_t                  m_uiResultCount;
};  

#endif
