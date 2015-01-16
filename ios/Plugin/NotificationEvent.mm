// ----------------------------------------------------------------------------
// 
// Rtt_IPhoneNotificationEvent.cpp
// Copyright (c) 2011 Ansca, Inc. All rights reserved.
// 
// Reviewers:
// 		Walter
//
// ----------------------------------------------------------------------------

#include "IPhoneNotificationEvent.h"

#include "CoronaEvent.h"
#include "CoronaLua.h"
#include "CoronaLuaIOS.h"

const char*
NotificationEvent::StringForType( Type type )
{
	static const char kLocalString[] = "local";
	static const char kRemoteString[] = "remote";
	static const char kRemoteRegistrationString[] = "remoteRegistration";

	const char *result = kLocalString;

	switch ( type )
	{
		case kRemote:
			result = kRemoteString;
			break;
		case kRemoteRegistration:
			result = kRemoteRegistrationString;
		default:
			break;
	}

	return result;
}

const char*
NotificationEvent::StringForApplicationState( ApplicationState state )
{
	static const char kBackgroundString[] = "background";
	static const char kActiveString[] = "active";
	static const char kInactiveString[] = "inactive";

	const char *result = kBackgroundString;
	switch ( state )
	{
		case kActive:
			result = kActiveString;
			break;
		case kInactive:
			result = kInactiveString;
			break;
		default:
			break;
	}

	return result;
}

NotificationEvent::NotificationEvent( Type t, ApplicationState state )
:	fType( t ),
	fApplicationState( state )
{
}

int
NotificationEvent::PrepareDispatch( lua_State *L ) const
{
	CoronaLuaPushRuntime( L );
	lua_getfield( L, -1, "dispatchEvent" );
	lua_insert( L, -2 ); // swap stack positions for "Runtime" and "dispatchEvent"
	return 1 + Push( L );
}

void
NotificationEvent::Dispatch( lua_State *L ) const
{
	// Invoke Lua code: "Runtime:dispatchEvent( eventKey )"
	int nargs = PrepareDispatch( L );
	CoronaLuaDoCall( L, nargs, 0 );
}

const char*
NotificationEvent::Name() const
{
	static const char kName[] = "notification";
	return kName;
}

int
NotificationEvent::Push( lua_State *L ) const
{
	CoronaLuaNewEvent( L, Name() );

	lua_pushstring( L, StringForType( (Type)fType ) );
	lua_setfield( L, -2, CoronaEventTypeKey() );

	lua_pushstring( L, StringForApplicationState( (ApplicationState)fApplicationState ) );
	lua_setfield( L, -2, "applicationState" );

	return 1;
}
// ----------------------------------------------------------------------------

