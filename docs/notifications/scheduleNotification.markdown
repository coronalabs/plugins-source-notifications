# notifications.scheduleNotification()

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [Function][api.type.Function]
> __Library__           [notifications.*][plugin.notifications]
> __Return value__      [Userdata][api.type.Userdata]
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          notification
> __See also__          [Local/Push Notifications][guide.events.appNotification]
>                               [notifications.cancelNotification()][plugin.notifications.cancelNotification]
>                               [native.setProperty()][api.library.native.setProperty]
> --------------------- ------------------------------------------------------------------------------------------


## Overview

Schedules a local notification event to be delivered in the future. This function returns a reference ID that can be used to cancel the notification. This ID is a memory address (pointer) to an object, thus it cannot be saved and it will not be available the next time the program runs.

## Syntax

    local notifications = require("plugin.notifications")

    notifications.scheduleNotification( secondsFromNow [, options] )

    notifications.scheduleNotification( coordinatedUniversalTime [, options] )

##### secondsFromNow ~^(required)^~
_[Number][api.type.Number]._ Number of seconds from now when the notification should be delivered.

##### coordinatedUniversalTime ~^(required)^~
_[Table][api.type.Table]._ Table containing same properties as returned by `os.date( "!*t" )`. A common pitfall is to pass `"*t"` (instead of `"!*t"`) resulting in a time given in your current time zone instead of a UTC time.

##### options ~^(optional)^~
_[Table][api.type.Table]._ A table that specifies details about the notification to be scheduled — see the next section for details.

## Options Reference

The `options` table contains details about the notification to be scheduled.

##### alert ~^(optional)^~
_[String][api.type.String]_ The notification message to be displayed to the user. If the application is not currently running, a system alert will display this message.

##### badge ~^(optional)^~
_[Number][api.type.Number]_ The badge number to be displayed on the application icon when the scheduled notification triggers. Replaces the last badge number that was applied. Set to zero to not show a badge number. (This is not supported on Android.)

##### sound ~^(optional)^~
_[String][api.type.String]_ Name of the sound file in the Resource directory to be played when the scheduled notification triggers. This sound is only played if the app is not currently in the foreground. On iOS, there are limitations on the kinds of sound that can be played (consult Apple's [documentation](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/IPhoneOSClientImp.html#//apple_ref/doc/uid/TP40008194-CH103-SW1) for more details).

##### custom ~^(optional)^~
_[Table][api.type.Table]._ A table that will be delivered with the notification event to pass custom information with it.


## Gotchas

### Android
Unlike iOS, local notifications on Android are managed by the application and not by the operating system. This means that all scheduled notifications and status bar notifications will be cleared when the application process terminates. However, pressing the __Back__ key to exit the application window will not terminate the application process. This only destroys the application window that hosts the Corona runtime, which runs your project's Lua scripts and will receive the `"applicationExit"` system event just before being destroyed. The application process will continue to run in the background. This is standard Android application behavior and allows its notifications to continue to be available. If the application process does get terminated, then Corona will automatically restore all pending notifications when the application restarts.

That said, calling [os.exit()][api.library.os.exit] will terminate the application process and clear all notifications. If you need to close the application window, then you should call [native.requestExit()][api.library.native.requestExit] instead, which only exits the application window and keeps the application process alive, which in turn keeps your notifications alive.

Also note that all scheduled notifications and status bar notifications will be cleared after rebooting the Android device. In order to restore all notifications, you must set the following permission in your `build.settings` file to set up your application to be started in the background after the Android device boots up.

### iOS
Scheduling a notification on application suspend can cause the application to crash.

``````lua
settings =
{
    android =
    {
        usesPermissions =
        {
            "android.permission.RECEIVE_BOOT_COMPLETED",
        },
    },
}
``````


## Example

``````lua
local notifications = require("plugin.notifications")

-- Get the app's launch arguments in case it was started when the user tapped on a notification.
local launchArgs = ...

-- Set up notification options.
local options = {
    alert = "Wake up!",
    badge = 2,
    sound = "alarm.caf",
    custom = { foo = "bar" }
}
 
-- Schedule a notification to occur 60 seconds from now.
local notificationId = notifications.scheduleNotification( 60, options )
 
-- Schedule a notification using UTC (Coordinated Universal Time).
local utcTime = os.date( "!*t", os.time() + 60 )
notificationId = notifications.scheduleNotification( utcTime, options )

-- Listen for notifications.
local onNotification = function( event )
    print( event.name ) -- ==> "notification"
    if event.custom then
        print( event.custom.foo ) -- ==> "bar"
    end
end 
Runtime:addEventListener( "notification", onNotification )

-- The app's launch arguments will provide a notification event if this app was started
-- when the user tapped on a notification. You must call the notification listener manually.
if launchArgs and launchArgs.notification then
    onNotification( launchArgs.notification )
end
``````
