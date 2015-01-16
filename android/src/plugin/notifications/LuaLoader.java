//
//  LuaLoader.java
//  TemplateApp
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

// This corresponds to the name of the Lua library,
// e.g. [Lua] require "plugin.library"
package plugin.notifications;

import android.app.Activity;
import android.util.Log;
import com.naef.jnlua.LuaState;
import com.naef.jnlua.JavaFunction;
import com.naef.jnlua.NamedJavaFunction;
import com.ansca.corona.Bridge;
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
public class LuaLoader implements JavaFunction {
	/** This corresponds to the event name, e.g. [Lua] event.name */
	private static final String EVENT_NAME = "pluginlibraryevent";


	/**
	 * Creates a new Lua interface to this plugin.
	 * <p>
	 * Note that a new LuaLoader instance will not be created for every CoronaActivity instance.
	 * That is, only one instance of this class will be created for the lifetime of the application process.
	 * This gives a plugin the option to do operations in the background while the CoronaActivity is destroyed.
	 */
	public LuaLoader() {
	}

	/**
	 * Called when this plugin is being loaded via the Lua require() function.
	 * <p>
	 * Note that this method will be called everytime a new CoronaActivity has been launched.
	 * This means that you'll need to re-initialize this plugin here.
	 * <p>
	 * Warning! This method is not called on the main UI thread.
	 * @param L Reference to the Lua state that the require() function was called from.
	 * @return Returns the number of values that the require() function will return.
	 *         <p>
	 *         Expected to return 1, the library that the require() function is loading.
	 */
	@Override
	public int invoke(LuaState L) {
		// Register this plugin into Lua with the following functions.
		NamedJavaFunction[] luaFunctions = new NamedJavaFunction[] {
			new ScheduleNotificationWrapper(),
			new CancelNotificationWrapper(),
			new RegisterForPushNotificationsWrapper()
		};
		String libName = L.toString( 1 );
		L.register(libName, luaFunctions);

		// Returning 1 indicates that the Lua require() function will return the above Lua library.
		return 1;
	}

	protected int scheduleNotification(LuaState L) {
		return Bridge.scheduleNotification(L, 1);
	}

	protected int cancelNotification(LuaState L) {
		if (L.isNone(1)) {
			Bridge.cancelAllNotifications();
		} else {
			int id = Double.valueOf(L.toNumber(-1)).intValue();
			Bridge.cancelNotification(id);
		}
		return 0;
	}

	/** Implements the library.init() Lua function. */
	private class ScheduleNotificationWrapper implements NamedJavaFunction {
		/**
		 * Gets the name of the Lua function as it would appear in the Lua script.
		 * @return Returns the name of the custom Lua function.
		 */
		@Override
		public String getName() {
			return "scheduleNotification";
		}
		
		/**
		 * This method is called when the Lua function is called.
		 * <p>
		 * Warning! This method is not called on the main UI thread.
		 * @param luaState Reference to the Lua state.
		 *                 Needed to retrieve the Lua function's parameters and to return values back to Lua.
		 * @return Returns the number of values to be returned by the Lua function.
		 */
		@Override
		public int invoke(LuaState L) {
			return scheduleNotification(L);
		}
	}

	/** Implements the library.show() Lua function. */
	private class CancelNotificationWrapper implements NamedJavaFunction {
		/**
		 * Gets the name of the Lua function as it would appear in the Lua script.
		 * @return Returns the name of the custom Lua function.
		 */
		@Override
		public String getName() {
			return "cancelNotification";
		}
		
		/**
		 * This method is called when the Lua function is called.
		 * <p>
		 * Warning! This method is not called on the main UI thread.
		 * @param luaState Reference to the Lua state.
		 *                 Needed to retrieve the Lua function's parameters and to return values back to Lua.
		 * @return Returns the number of values to be returned by the Lua function.
		 */
		@Override
		public int invoke(LuaState L) {
			return cancelNotification(L);
		}
	}

	private class RegisterForPushNotificationsWrapper implements NamedJavaFunction {
		@Override
		public String getName() {
			return "registerForPushNotifications";
		}

		@Override
		public int invoke(LuaState L) {
			return 0;
		}
	}
}
