//
//  PluginLibrary.h
//  TemplateApp
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef _CoronaNotificationsDelegate_H__
#define _CoronaNotificationsDelegate_H__

#include "CoronaDelegate.h"
#import "CoronaLua.h"

@interface CoronaNotificationsDelegate : NSObject<CoronaDelegate>
@property(retain) id<CoronaRuntime> runtime;
@end
#endif // _PluginLibrary_H__
