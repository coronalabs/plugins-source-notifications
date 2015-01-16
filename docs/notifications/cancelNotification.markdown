# notifications.cancelNotification()

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [Function][api.type.Function]
> __Library__           [notifications.*][plugin.notifications]
> __Return value__      none
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          notification, notifications
> __See also__          [Local/Push Notifications][guide.events.appNotification]
>						[notifications.scheduleNotification()][plugin.notifications.scheduleNotification]
> --------------------- ------------------------------------------------------------------------------------------


## Overview

Removes the specified notification (or all notifications) from the scheduler, status bar, and/or notification center.

## Syntax

	notifications.cancelNotification( [notificationId] )

##### notificationId ~^(optional)^~
A notification reference ID returned by [notifications.scheduleNotification()][plugin.notifications.scheduleNotification]. If no ID is passed, all notifications are cancelled.


## Example

``````lua
local notifications = require( "plugin.notifications" )

-- Schedule a notification
local options = { alert = "Wake up!" }
local notificationId = notifications.scheduleNotification( 60, options )

-- Cancel the above notification
notifications.cancelNotification( notificationId )
``````