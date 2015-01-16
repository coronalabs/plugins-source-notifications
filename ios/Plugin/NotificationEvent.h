// ----------------------------------------------------------------------------
// 
// Rtt_IPhoneNotificationEvent.h
// Copyright (c) 2011 Ansca, Inc. All rights reserved.
// 
// Reviewers:
// 		Walter
//
// ----------------------------------------------------------------------------

#ifndef _NotificationEvent_H__
#define _NotificationEvent_H__

// ----------------------------------------------------------------------------
#include "stdint.h"

struct lua_State;

class NotificationEvent
{
	public:
		typedef enum _Type
		{
			kLocal = 0,
			kRemote,
			kRemoteRegistration,
			
			kNumTypes
		}
		Type;

		typedef enum _ApplicationState
		{
			kBackground = 0,
			kActive,
			kInactive,

			kNumStates
		}
		ApplicationState;
		
	public:
		static const char* StringForType( Type type );
		static const char* StringForApplicationState( ApplicationState state );

	public:
		NotificationEvent( Type t, ApplicationState state );
		
	protected:
		virtual const char* Name() const;
		virtual int Push( lua_State *L ) const;
		virtual int PrepareDispatch( lua_State *L ) const;
	
	public:
		virtual void Dispatch( lua_State *L ) const;

	private:
		uint8_t fType;
		uint8_t fApplicationState;
};

// ----------------------------------------------------------------------------

#endif // _Rtt_IPhoneNotificationEvent_H__
