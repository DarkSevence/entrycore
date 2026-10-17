#include "StdAfx.h"
#include "PythonLocaleManager.h"

#include "GameLocale.h"
#include "PythonNonPlayer.h"
#include "../EterPack/EterPackManager.h"
#include "../GameLib/ItemData.h"
#include "../GameLib/ItemManager.h"

#include <stdlib.h>
#include <sstream>

static CPythonLocaleManager s_kLocaleManager;

CPythonLocaleManager::CPythonLocaleManager()
	: m_isLocaleStringLoaded(false), m_isLocaleQuestLoaded(false)
{
}

CPythonLocaleManager::~CPythonLocaleManager()
{
}

void CPythonLocaleManager::Clear()
{
	m_localeStringMap.clear();
	m_localeQuestMap.clear();
	m_isLocaleStringLoaded = false;
	m_isLocaleQuestLoaded = false;
}

bool CPythonLocaleManager::LoadLocaleFile(const char* fileName, const char* logName, TLocaleStringMap& outputMap)
{
	char localeFilePath[256];
	snprintf(localeFilePath, sizeof(localeFilePath), "%s/%s", LocaleService_GetLocalePath(), fileName);

	CMappedFile file;
	const VOID* pvData;
	if (!CEterPackManager::Instance().Get(file, localeFilePath, &pvData))
	{
		TraceError("CPythonLocaleManager::%s: %s not found", logName, localeFilePath);
		return false;
	}

	CMemoryTextFileLoader textFileLoader;
	textFileLoader.Bind(file.Size(), pvData);

	CTokenVector tokens;
	for (DWORD dwLineIndex = 0; dwLineIndex < textFileLoader.GetLineCount(); ++dwLineIndex)
	{
		if (!textFileLoader.SplitLineByTab(dwLineIndex, &tokens) || tokens.size() < 2)
			continue;

		DWORD localeID = static_cast<DWORD>(strtoul(tokens[0].c_str(), NULL, 10));
		if (0 == localeID)
			continue;

		outputMap[localeID] = tokens[1];
	}

	return true;
}

bool CPythonLocaleManager::LoadLocaleString()
{
	if (m_isLocaleStringLoaded)
		return true;

	m_isLocaleStringLoaded = true;
	return LoadLocaleFile("locale_string.txt", "LoadLocaleString", m_localeStringMap);
}

bool CPythonLocaleManager::LoadLocaleQuest()
{
	if (m_isLocaleQuestLoaded)
		return true;

	m_isLocaleQuestLoaded = true;
	return LoadLocaleFile("locale_quest.txt", "LoadLocaleQuest", m_localeQuestMap);
}

const char* CPythonLocaleManager::GetString(DWORD localeID)
{
	if (!m_isLocaleStringLoaded)
		LoadLocaleString();

	TLocaleStringMap::const_iterator it = m_localeStringMap.find(localeID);
	if (it == m_localeStringMap.end())
		return NULL;

	return it->second.c_str();
}

const char* CPythonLocaleManager::GetQuestString(DWORD localeID)
{
	if (!m_isLocaleQuestLoaded)
		LoadLocaleQuest();

	TLocaleStringMap::const_iterator it = m_localeQuestMap.find(localeID);
	if (it == m_localeQuestMap.end())
		return NULL;

	return it->second.c_str();
}

bool CPythonLocaleManager::FormatQuestString(DWORD localeID, const TLocaleQuestArgumentVector& arguments, std::string& output)
{
	const char* localeText = GetQuestString(localeID);
	if (NULL == localeText)
	{
		std::ostringstream missing;
		missing << "[quest-locale:" << localeID << "]";
		output = missing.str();
		TraceError("CPythonLocaleManager::FormatQuestString: missing id %u", localeID);
		return false;
	}

	output = localeText;
	for (TLocaleQuestArgumentVector::const_iterator it = arguments.begin(); it != arguments.end(); ++it)
	{
		std::string renderedArgument;
		std::ostringstream numberStream;

		switch (it->type)
		{
			case LOCALE_QUEST_ARGUMENT_INT32:
				numberStream << static_cast<int32_t>(it->number);
				renderedArgument = numberStream.str();
				break;

			case LOCALE_QUEST_ARGUMENT_UINT32:
				numberStream << static_cast<uint32_t>(it->number);
				renderedArgument = numberStream.str();
				break;

			case LOCALE_QUEST_ARGUMENT_INT64:
				numberStream << static_cast<long long>(it->number);
				renderedArgument = numberStream.str();
				break;

			case LOCALE_QUEST_ARGUMENT_STRING:
				renderedArgument = it->text;
				break;

			case LOCALE_QUEST_ARGUMENT_ITEM_VNUM:
			{
				CItemData* itemData = NULL;
				if (CItemManager::Instance().GetItemDataPointer(static_cast<DWORD>(it->number), &itemData) && itemData)
					renderedArgument = itemData->GetName();
				else
				{
					numberStream << "[item:" << static_cast<DWORD>(it->number) << "]";
					renderedArgument = numberStream.str();
				}
				break;
			}

			case LOCALE_QUEST_ARGUMENT_MOB_VNUM:
			{
				const char* mobName = NULL;
				if (CPythonNonPlayer::Instance().GetName(static_cast<DWORD>(it->number), &mobName) && mobName)
					renderedArgument = mobName;
				else
				{
					numberStream << "[mob:" << static_cast<DWORD>(it->number) << "]";
					renderedArgument = numberStream.str();
				}
				break;
			}

			default:
				renderedArgument = "[arg]";
				break;
		}

		const std::string::size_type placeholder = output.find("{}");
		if (placeholder == std::string::npos)
		{
			TraceError("CPythonLocaleManager::FormatQuestString: too many arguments for id %u", localeID);
			return false;
		}

		output.replace(placeholder, 2, renderedArgument);
	}

	if (output.find("{}") != std::string::npos)
	{
		TraceError("CPythonLocaleManager::FormatQuestString: missing arguments for id %u", localeID);
		return false;
	}

	return true;
}
