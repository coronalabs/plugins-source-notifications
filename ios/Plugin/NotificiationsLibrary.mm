//
//  PluginLibrary.mm
//  TemplateApp
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoronaLua.h"
#import "NotificationsLibrary.h"
#import "IPhoneNotificationEvent.h"

#include "CoronaRuntime.h"

#import <UIKit/UIKit.h>

// ----------------------------------------------------------------------------
static const char *kNotificationMetatable = "notification";

static int
TypeForString( const char *value )
{
	int result;
	if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
	{
		result = UIUserNotificationTypeNone;
		
		if ( 0 == strcmp( value, "badge" ) )
		{
			result = UIUserNotificationTypeBadge;
		}
		else if ( 0 == strcmp( value, "sound" ) )
		{
			result = UIUserNotificationTypeSound;
		}
		else if ( 0 == strcmp( value, "alert" ) )
		{
			result = UIUserNotificationTypeAlert;
		}
	}
	else
	{
		result = UIRemoteNotificationTypeNone;
		
		if ( 0 == strcmp( value, "badge" ) )
		{
			// Note that if the app also specifies "newsstand" then its badge wont be updated
			// (presumably because badges are handled differently for newsstand apps)
			result = UIRemoteNotificationTypeBadge;
		}
		else if ( 0 == strcmp( value, "sound" ) )
		{
			result = UIRemoteNotificationTypeSound;
		}
		else if ( 0 == strcmp( value, "alert" ) )
		{
			result = UIRemoteNotificationTypeAlert;
		}
		else if ( 0 == strcmp( value, "newsstand" ) )
		{
			// See comment above on "badge"
			result = UIRemoteNotificationTypeNewsstandContentAvailability;
		}
	}
	
	return result;
}

static int
scheduleNotification( lua_State *L )
{
	UILocalNotification *notification = IPhoneLocalNotificationEvent::CreateAndSchedule( L, 1 );
	
	Class cls = NSClassFromString(@"UIUserNotificationSettings");
	if ( cls )
	{
		int type = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
		id settings = [cls settingsForTypes:type categories:nil];
		[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
	}
	
	[[UIApplication sharedApplication] scheduleLocalNotification:notification];
	
	if ( notification )
	{
		CoronaLuaPushUserdata( L, notification, kNotificationMetatable );
	}
	else
	{
		lua_pushnil( L );
	}
	
	return 1;
}

static int
cancelNotification( lua_State *L )
{
	if ( lua_isuserdata( L, 1 ) || lua_isnoneornil( L, 1 ) )
	{
		void *notificationId = lua_isnone( L, 1 ) ? NULL : CoronaLuaCheckUserdata( L, 1, kNotificationMetatable );
		
		UIApplication *application = [UIApplication sharedApplication];
		
		if ( notificationId )
		{
			UILocalNotification *notification = (UILocalNotification*)notificationId;
			
			[application cancelLocalNotification:notification];
		}
		else
		{
			[application cancelAllLocalNotifications];
			application.applicationIconBadgeNumber = 0;
		}
	}
	
	
	
	return 0;
}

static void
registerUserNotificationSettings(long types)
{
	// These functions were added in iOS 8 and have to be called or notifications won't work correctly.  Even though this part if just for setting notifications, we're asking for the other permissions because
	// once you call this function once it won't ask again when you call it again with new permissions.  In the alert dialog thats shown, it doesn't specify which permissions are asked for
	// anyways.
	Class cls = NSClassFromString(@"UIUserNotificationSettings");
	if ( cls )
	{
		id settings = [cls settingsForTypes:types categories:nil];
		[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
	}
}

static int
registerForPushNotifications( lua_State *L )
{
	// Looks in config.lua to see if the following table exists:
	//	application =
	//	{
	//		notification =
	//		{
	//			iphone =
	//			{
	//				types =
	//				{
	//					"badge",
	//					"sound",
	//					"alert",
	//					"newsstand",
	//				}
	//			},
	//		},
	//	}
	UIApplication *application = [UIApplication sharedApplication];
	UIRemoteNotificationType types = UIRemoteNotificationTypeNone;
	
	int top = lua_gettop( L );
	
	lua_getglobal( L, "package" );
	lua_getfield( L, -1, "loaded" );
	lua_getfield( L, -1, "config" );
	int type = lua_type( L, -1 );
	
	lua_getglobal( L, "require" );
	lua_pushstring( L, "config" );
	lua_call( L, 1, 0 );
	
	lua_getglobal( L, "application" );
	if ( lua_istable( L, -1 ) )
	{
		lua_getfield( L, -1, "notification" );
		if ( lua_istable( L, -1 ) )
		{
			lua_getfield( L, -1, "iphone" );
			if ( lua_istable( L, -1 ) )
			{
				lua_getfield( L, -1, "types" );
				if ( lua_istable( L, -1 ) )
				{
					int index = lua_gettop( L );
					for ( int i = 1, iMax = lua_objlen( L, index ); i <= iMax; i++ )
					{
						lua_rawgeti( L, index, i );
						
						int t = TypeForString( lua_tostring( L, -1 ) );
						types = (int)( types | t );
						
						lua_pop( L, 1 );
					}
				}
			}
		}
	}
	
	// Clean up so that if the require("config") was already called it won't wipe that out
	if ( type == LUA_TNIL )
	{
		// application = nil
		lua_pushnil( L );
		lua_setglobal( L, "application" );
		// package.loaded.config = nil
		lua_getglobal( L, "package" );
		lua_getfield( L, -1, "loaded" );
		lua_pushnil( L );
		lua_setfield( L, -2, "config" );
	}
	
	if ( UIRemoteNotificationTypeNone != types )
	{
		if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
		{
			registerUserNotificationSettings(types);
			[application registerForRemoteNotifications];
		}
		else
		{
			[application registerForRemoteNotificationTypes:types];
		}
	}
	
	// pop values
	lua_settop( L, top );
	return 0;
}

class NotificationsLibrary
{
	public:
		typedef NotificationsLibrary Self;

	public:
		static const char kName[];
		static const char kEvent[];

	protected:
		NotificationsLibrary();

	public:
		bool Initialize( CoronaLuaRef listener );

	public:
		CoronaLuaRef GetListener() const { return fListener; }

	public:
		static int Open( lua_State *L );

	protected:
		static int Finalizer( lua_State *L );

	public:
		static Self *ToLibrary( lua_State *L );

	private:
		CoronaLuaRef fListener;
};

// ----------------------------------------------------------------------------

// This corresponds to the name of the library, e.g. [Lua] require "plugin.library"
const char NotificationsLibrary::kName[] = "plugin.notifications";

// This corresponds to the event name, e.g. [Lua] event.name
const char NotificationsLibrary::kEvent[] = "pluginlibraryevent";

NotificationsLibrary::NotificationsLibrary()
:	fListener( NULL )
{
}

bool
NotificationsLibrary::Initialize( CoronaLuaRef listener )
{
	// Can only initialize listener once
	bool result = ( NULL == fListener );

	if ( result )
	{
		fListener = listener;
	}

	return result;
}

int
NotificationsLibrary::Open( lua_State *L )
{
	// Register __gc callback
	const char kMetatableName[] = __FILE__; // Globally unique string to prevent collision
	CoronaLuaInitializeGCMetatable( L, kMetatableName, Finalizer );

	// Functions in library
	const luaL_Reg kVTable[] =
	{
		{ "scheduleNotification", scheduleNotification },
		{ "cancelNotification", cancelNotification },
		{ "registerForPushNotifications", registerForPushNotifications},

		{ NULL, NULL }
	};

	// Set library as upvalue for each library function
	Self *library = new Self;
	CoronaLuaPushUserdata( L, library, kMetatableName );

	luaL_openlib( L, kName, kVTable, 1 ); // leave "library" on top of stack

	return 1;
}

int
NotificationsLibrary::Finalizer( lua_State *L )
{
	Self *library = (Self *)CoronaLuaToUserdata( L, 1 );

	CoronaLuaDeleteRef( L, library->GetListener() );

	delete library;

	return 0;
}

NotificationsLibrary *
NotificationsLibrary::ToLibrary( lua_State *L )
{
	// library is pushed as part of the closure
	Self *library = (Self *)CoronaLuaToUserdata( L, lua_upvalueindex( 1 ) );
	return library;
}

// ----------------------------------------------------------------------------

CORONA_EXPORT int luaopen_plugin_notifications( lua_State *L )
{
	return NotificationsLibrary::Open( L );
}
