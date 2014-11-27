//
//  RealmHelper.h
//  StudenTT
//
//  Created by Stan Potemkin on 11/22/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLMRealm.h"
#import "RLMResults.h"


typedef struct {
	bool is_odd;
	int weekday;
} day_config_t;


@class DayRecord;


@interface AppHelper : NSObject
+ (RLMRealm *)sharedRealm;
+ (void)generateDefaults;

+ (NSUInteger)indexOfObject:(id)object inResults:(RLMResults *)results;
+ (NSArray *)objects:(id)objects sortedBy:(NSString *)key ascending:(BOOL)asc;

+ (day_config_t)todayConfig;
+ (DayRecord *)getDayRecord;
@end
