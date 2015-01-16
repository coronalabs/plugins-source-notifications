# notification.cancelNotification()

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [Function][api.type.Function]
> __Library__           [notifications.*][plugin.notifications]
> __Return value__      none
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          notification
> __See also__          [Local/Push Notifications][guide.events.appNotification]<br/>[notifications.scheduleNotification()][plugin.notifications.scheduleNotification]
> --------------------- ------------------------------------------------------------------------------------------


## Overview

Removes the specified notification from the scheduler, status bar, or notification center.

## Syntax
	local notifications = require("plugin.notifications")
	
    -- cancel all notifications
	notifications.cancelNotification()

    -- cancel notification corresponding to 'notificationId'
	notifications.cancelNotification( notificationId )

##### notificationId ~^(optional)^~
A notification reference ID returned by [notifications.scheduleNotification()][plugin.notifications.scheduleNotification]. If no id is passed, then all notifications are cancelled.


## Examples

``````lua
local notifications = require("plugin.notifications")

-- Schedule a notification.
local options = { alert = "Wake up!" }
local notificationId = notifications.scheduleNotification( 60, options )

-- Cancel the above notification.
notifications.cancelNotification( notificationId )
``````
