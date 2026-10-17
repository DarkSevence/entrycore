#include "StdAfx.h"
#include "ActorInstance.h"
#include "WeaponTrace.h"

void CActorInstance::TraceProcess()
{
	if (!m_WeaponTraceVector.empty())
	{
		std::vector<CWeaponTrace*>::iterator it;
		for(it = m_WeaponTraceVector.begin(); it != m_WeaponTraceVector.end(); ++it)
		{
			CWeaponTrace * pWeaponTrace = (*it);
			pWeaponTrace->SetPosition(m_x, m_y, m_z);
			pWeaponTrace->SetRotation(m_fcurRotation);
			pWeaponTrace->Update(__GetReachScale());
		}
	}
}

void CActorInstance::RenderTrace()
{
	for (auto* trace : m_WeaponTraceVector)
	{
		if (trace)
			trace->Render();
	}
}

void CActorInstance::__DestroyWeaponTrace()
{
	std::for_each(m_WeaponTraceVector.begin(), m_WeaponTraceVector.end(), CWeaponTrace::Delete);
	m_WeaponTraceVector.clear();
}

void CActorInstance::__ShowWeaponTrace()
{
	for (auto* trace : m_WeaponTraceVector)
	{
		if (trace)
			trace->TurnOn();
	}
}

void CActorInstance::__HideWeaponTrace()
{
	for (auto* trace : m_WeaponTraceVector)
	{
		if (trace)
			trace->TurnOff();
	}
}

