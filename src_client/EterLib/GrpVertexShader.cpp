#include "StdAfx.h"
#include "GrpVertexShader.h"
#include "GrpD3DXBuffer.h"
#include "StateManager.h"

CVertexShader::CVertexShader()
{
	Initialize();
}

CVertexShader::~CVertexShader()
{
	Destroy();
}

void CVertexShader::Initialize()
{
	m_handle = NULL;
}

void CVertexShader::Destroy()
{
	if (m_handle)
	{
		m_handle->Release();

		m_handle = NULL;
	}
}

bool CVertexShader::CreateFromDiskFile(const char* c_szFileName, const DWORD* c_pdwVertexDecl)
{
	Destroy();
	(void)c_pdwVertexDecl;

	LPD3DXBUFFER lpd3dxShaderBuffer;
	LPD3DXBUFFER lpd3dxErrorBuffer;
	
	if (FAILED(
		D3DXAssembleShaderFromFile(c_szFileName, 0, NULL, 0, &lpd3dxShaderBuffer, &lpd3dxErrorBuffer)
	)) return false;

	CDirect3DXBuffer shaderBuffer(lpd3dxShaderBuffer);
	CDirect3DXBuffer errorBuffer(lpd3dxErrorBuffer);

	if (FAILED(
		ms_lpd3dDevice->CreateVertexShader(static_cast<const DWORD*>(shaderBuffer.GetPointer()), &m_handle)
		))
		return false;

	return true;
}

void CVertexShader::Set()
{
	STATEMANAGER.SetVertexShader(m_handle);
}
