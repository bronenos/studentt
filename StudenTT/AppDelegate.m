//
//  AppDelegate.m
//  StudenTT
//
//  Created by Stan Potemkin on 11/19/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "AppDelegate.h"
#import "AppHelper.h"


@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[AppHelper generateDefaults];
	return YES;
}
@end
