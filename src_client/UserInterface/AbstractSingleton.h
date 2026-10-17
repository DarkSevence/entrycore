#pragma once

template <typename T> 
class TAbstractSingleton
{ 
	static T * ms_singleton;
	
public: 
	TAbstractSingleton()
	{ 
		assert(!ms_singleton);
		ms_singleton = static_cast<T*>(this);
	} 

	virtual ~TAbstractSingleton()
	{ 
		assert(ms_singleton);
		ms_singleton = 0; 
	}

	__forceinline static T & GetSingleton()
	{
		assert(ms_singleton!=NULL);
		return (*ms_singleton);
	}	
};

template <typename T> T * TAbstractSingleton <T>::ms_singleton = 0;
