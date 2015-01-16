// ----------------------------------------------------------------------------
// 
// Rtt_IPhoneNotificationEvent.h
// Copyright (c) 2011 Ansca, Inc. All rights reserved.
// 
// Reviewers:
// 		Walter
//
// ----------------------------------------------------------------------------

#ifndef _IPhoneNotificationEvent_H__
#define _IPhoneNotificationEvent_H__

#import "NotificationEvent.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// ----------------------------------------------------------------------------

@class UILocalNotification;
@class NSData;
@class NSDictionary;

struct lua_State;

// ----------------------------------------------------------------------------

class IPhoneNotificationEvent : public NotificationEvent
{
	public:
		typedef NotificationEvent Super;

	public:
		static NotificationEvent::ApplicationState ToApplicationState( UIApplicationState state );

	public:
		IPhoneNotificationEvent( Type t, ApplicationState state, id notification );
		virtual ~IPhoneNotificationEvent();

	public:
		id GetNotification() const { return fNotification; }

	private:
		id fNotification;
};

// ----------------------------------------------------------------------------

class IPhoneLocalNotificationEvent : public IPhoneNotificationEvent
{
	public:
		typedef IPhoneNotificationEvent Super;

	public:
		// expects arg 'index' to be fireTime and arg 'index + 1' to be the options table
		static UILocalNotification* CreateAndSchedule( lua_State *L, int index ); 

	public:
		IPhoneLocalNotificationEvent( UILocalNotification *notification, ApplicationState state );

	public:
		virtual int Push( lua_State *L ) const;
};

// ----------------------------------------------------------------------------

class IPhoneRemoteNotificationRegistrationEvent : public NotificationEvent
{
	public:
		typedef NotificationEvent Super;

	public:
		IPhoneRemoteNotificationRegistrationEvent( NSData *token );
		IPhoneRemoteNotificationRegistrationEvent( NSError *error );
		virtual ~IPhoneRemoteNotificationRegistrationEvent();

	public:
		virtual int Push( lua_State *L ) const;

	private:
		NSData *fToken;
		NSError *fError;
};

// ----------------------------------------------------------------------------

class IPhoneRemoteNotificationEvent : public IPhoneNotificationEvent
{
	public:
		typedef IPhoneNotificationEvent Super;

	public:
		IPhoneRemoteNotificationEvent( NSDictionary *notification, ApplicationState state );

	public:
		virtual int Push( lua_State *L ) const;
};

// ----------------------------------------------------------------------------

#endif // _Rtt_IPhoneNotificationEvent_H__
