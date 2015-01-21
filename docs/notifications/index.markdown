# notifications.*

> --------------------- ------------------------------------------------------------------------------------------
> __Type__				[Library][api.type.library]
> __Revision__			[REVISION_LABEL](REVISION_URL)
> __Keywords__			notification, notifications
> __Availability__		Starter, Basic, Pro, Enterprise
> __Platforms__			Android, iOS
> --------------------- ------------------------------------------------------------------------------------------

## Overview

Gives access to local and push notifications.

## Syntax

    local notifications = require( "plugin.notifications" )

    
## Functions

#### [notifications.registerForPushNotifications()][plugin.notifications.registerForPushNotifications]

#### [notifications.cancelNotification()][plugin.notifications.cancelNotification]

#### [notifications.scheduleNotification()][plugin.notifications.scheduleNotification]

## Project Settings

To use this plugin, add an entry into the `plugins` table of `build.settings`. When added, the build server will integrate the plugin during the build phase.

``````lua
settings =
{
    plugins =
    {
        ["plugin.notifications"] =
        {
            publisherId = "com.coronalabs"
        },
    },      
}
``````