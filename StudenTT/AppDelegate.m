//
//  AppDelegate.m
//  StudenTT
//
//  Created by Stan Potemkin on 11/19/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "AppDelegate.h"
#import "RealmHelper.h"


@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[RealmHelper generateDefaults];
	return YES;
}
@end
