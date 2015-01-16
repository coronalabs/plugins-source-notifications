# notification.registerForPushNotifications()

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [Function][api.type.Function]
> __Library__           [notifications.*][plugin.notifications]
> __Return value__      none
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          notification
> __See also__          [Local/Push Notifications][guide.events.appNotification]<br/>[notifications.scheduleNotification()][plugin.notifications.scheduleNotification]
> --------------------- ------------------------------------------------------------------------------------------


## Overview

Register for push notifications.  Does nothing on Android.  On iOS this will cause the popup to show which asks the user if they want to enable push notifications.  After the first call, subsequent calls will not show the popup again.

## Syntax
    local notifications = require("plugin.notifications")
    
    notifications.registerForPushNotifications()


## Examples

``````lua
local notifications = require("plugin.notifications")

notifications.registerForPushNotifications()
``````
