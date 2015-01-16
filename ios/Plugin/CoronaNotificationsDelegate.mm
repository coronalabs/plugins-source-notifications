//
//  PluginLibrary.mm
//  TemplateApp
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoronaNotificationsDelegate.h"
#import "CoronaLua.h"
#import "CoronaRuntime.h"
#import "IPhoneNotificationEvent.h"

#import <UIKit/UIKit.h>

static int
SetLaunchArgs( UIApplication *application, NSDictionary *launchOptions, lua_State *L )
{
	int itemsPushed = 0;
	UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
	if ( localNotification )
	{
		IPhoneLocalNotificationEvent e(
									   localNotification, IPhoneNotificationEvent::ToApplicationState( application.applicationState ) );
		e.Push( L );
		itemsPushed = 1;
	}
	
	NSDictionary *remoteNotification =
		[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
	
	if ( remoteNotification )
	{
		IPhoneRemoteNotificationEvent e(
										remoteNotification, IPhoneNotificationEvent::ToApplicationState( application.applicationState ) );
		e.Push( L );
		itemsPushed = 1;
	}
	
	return itemsPushed;
}

@implementation CoronaNotificationsDelegate

- (void) dealloc
{
	[super dealloc];
}

- (void)willLoadMain:(id<CoronaRuntime>)runtime
{
}

- (int)execute:(id<CoronaRuntime>)runtime command:(NSString*)command param:(id)param
{
	lua_State *L = runtime.L;
	int itemsPushed = 0;
	if ( [command isEqualToString:@"pushLaunchArgKey"] )
	{
		lua_pushstring( L, "notification" );
		itemsPushed = 1;
	}
	else if ( [command isEqualToString:@"pushLaunchArgValue" ] )
	{
		itemsPushed = SetLaunchArgs( [UIApplication sharedApplication], param, L);
	}
	return itemsPushed;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
	IPhoneLocalNotificationEvent e(
								   notification, IPhoneNotificationEvent::ToApplicationState( application.applicationState ) );
	e.Dispatch(	self.runtime.L );
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	IPhoneRemoteNotificationEvent e( userInfo, IPhoneNotificationEvent::ToApplicationState( application.applicationState ) );
	e.Dispatch( self.runtime.L );
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
	IPhoneRemoteNotificationRegistrationEvent e( deviceToken );
	e.Dispatch(	self.runtime.L );
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	
	NSLog(@"AppDelegate.mm: didFailToRegisterForRemoteNotificationsWithError: %@", [error localizedDescription]);
	IPhoneRemoteNotificationRegistrationEvent e( error );
	e.Dispatch(	self.runtime.L );
}

- (void)didLoadMain:(id<CoronaRuntime>)runtime
{
	_runtime = runtime;
}

@end