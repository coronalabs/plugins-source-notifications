//
//  LuaLoader.java
//  TemplateApp
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// This corresponds to the name of the Lua library,
// e.g. [Lua] require "plugin.library"
package com.ansca.corona;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import com.naef.jnlua.LuaState;
import com.naef.jnlua.JavaFunction;
import com.naef.jnlua.NamedJavaFunction;
import com.ansca.corona.CoronaActivity;
import com.ansca.corona.CoronaEnvironment;
import com.ansca.corona.CoronaLua;
import com.ansca.corona.CoronaRuntime;


/**
 * Implements the Lua interface for a Corona plugin.
 * <p>
 * Only one instance of this class will be created by Corona for the lifetime of the application.
 * This instance will be re-used for every new Corona activity that gets created.
 */
public class Bridge extends NativeToJavaBridge {
	public Bridge(Context context) {
		super(context);
	}

	public static int scheduleNotification(LuaState L, int index) {
		int id = notificationSchedule(L, index);
		L.pushInteger(id);
		return 1;
	}

	public static void cancelNotification(int id) {
		callNotificationCancel(id);
	}

	public static void cancelAllNotifications() {
		callNotificationCancelAll(null);
	}
}
