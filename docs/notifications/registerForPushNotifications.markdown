# notifications.registerForPushNotifications()

> --------------------- ------------------------------------------------------------------------------------------
> __Type__              [Function][api.type.Function]
> __Library__           [notifications.*][plugin.notifications]
> __Return value__      none
> __Revision__          [REVISION_LABEL](REVISION_URL)
> __Keywords__          notification, notifications
> __See also__          [Local/Push Notifications][guide.events.appNotification]
>                        [notifications.scheduleNotification()][plugin.notifications.scheduleNotification]
> --------------------- ------------------------------------------------------------------------------------------


## Overview

Register for push notifications on iOS. This will show the popup which asks the user if they want to enable push notifications. After the first call, subsequent calls will not show the popup again.


## Gotchas

This function does nothing on Android.


## Syntax

    notifications.registerForPushNotifications()


## Examples

``````lua
local notifications = require( "plugin.notifications" )

notifications.registerForPushNotifications()
``````