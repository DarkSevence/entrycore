#pragma once

#include <map>
#include <stdint.h>
#include <string>
#include <vector>

enum ELocaleQuestArgumentType
{
	LOCALE_QUEST_ARGUMENT_NONE = 0,
	LOCALE_QUEST_ARGUMENT_INT32 = 1,
	LOCALE_QUEST_ARGUMENT_UINT32 = 2,
	LOCALE_QUEST_ARGUMENT_INT64 = 3,
	LOCALE_QUEST_ARGUMENT_STRING = 4,
	LOCALE_QUEST_ARGUMENT_ITEM_VNUM = 5,
	LOCALE_QUEST_ARGUMENT_MOB_VNUM = 6,
};

enum
{
	LOCALE_QUEST_MAX_ARGUMENTS = 4,
	LOCALE_QUEST_MAX_STRING_LENGTH = 255,
};

struct SLocaleQuestArgument
{
	BYTE type;
	int64_t number;
	std::string text;

	SLocaleQuestArgument()
		: type(LOCALE_QUEST_ARGUMENT_NONE), number(0)
	{
	}
};

typedef std::vector<SLocaleQuestArgument> TLocaleQuestArgumentVector;

class CPythonLocaleManager : public CSingleton<CPythonLocaleManager>
{
public:
	CPythonLocaleManager();
	virtual ~CPythonLocaleManager();

	void Clear();
	bool LoadLocaleString();
	bool LoadLocaleQuest();
	const char* GetString(DWORD localeID);
	const char* GetQuestString(DWORD localeID);
	bool FormatQuestString(DWORD localeID, const TLocaleQuestArgumentVector& arguments, std::string& output);

protected:
	typedef std::map<DWORD, std::string> TLocaleStringMap;
	bool LoadLocaleFile(const char* fileName, const char* logName, TLocaleStringMap& outputMap);

	TLocaleStringMap m_localeStringMap;
	TLocaleStringMap m_localeQuestMap;
	bool m_isLocaleStringLoaded;
	bool m_isLocaleQuestLoaded;
};
