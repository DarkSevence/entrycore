#include "StdAfx.h"
#include "PythonNetworkStream.h"

void CPythonNetworkStream::OnRemoteDisconnect()
{
	TraceError("NET_DISCONNECT: phase=%s direct=%d security=%d", m_strPhase.c_str(), __DirectEnterMode_IsSet(), IsSecurityMode());
	PyCallClassMemberFunc(m_poHandler, "SetLoginPhase", Py_BuildValue("()"));
}

void CPythonNetworkStream::OnDisconnect()
{
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// Main Game
void CPythonNetworkStream::OnScriptEventStart(int iSkin, int iIndex)
{
	PyCallClassMemberFunc(m_apoPhaseWnd[PHASE_WINDOW_GAME], "OpenQuestWindow", Py_BuildValue("(ii)", iSkin, iIndex));
}