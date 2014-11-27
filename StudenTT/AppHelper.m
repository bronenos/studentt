//
//  RealmHelper.m
//  StudenTT
//
//  Created by Stan Potemkin on 11/22/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppHelper.h"
#import "ConfigRecord.h"
#import "DayRecord.h"
#import "NSDate+Utils.h"


static NSString * const kApplicationGroupID	= @"group.me.bronenos.studentt";


@implementation AppHelper
+ (RLMRealm *)sharedRealm
{
	static NSString *realmPath = nil;
	if (realmPath == nil) {
		NSFileManager *fm = [NSFileManager defaultManager];
		NSURL *containerURL = [fm containerURLForSecurityApplicationGroupIdentifier:kApplicationGroupID];
		realmPath = [[containerURL path] stringByAppendingPathComponent:@"db.realm"];
	}
	
	return [RLMRealm realmWithPath:realmPath];
}


+ (void)generateDefaults
{
	RLMRealm *realm = [AppHelper sharedRealm];
	
	if ([ConfigRecord allObjectsInRealm:realm].count == 0) {
		[realm transactionWithBlock:^{
			ConfigRecord *configRecord = [ConfigRecord new];
			configRecord.commonMode = YES;
			[realm addObject:configRecord];
		}];
	}
	
	if ([DayRecord allObjectsInRealm:realm].count == 0) {
		[realm transactionWithBlock:^{
			const NSInteger cnt = [NSDate sharedFormatter].weekdaySymbols.count;
			for (NSUInteger i=0; i<cnt; i++) {
				DayRecord *dayRecord;
				
				dayRecord = [DayRecord new];
				dayRecord.oddWeek = NO;
				dayRecord.weekday = i;
				[realm addObject:dayRecord];
				
				dayRecord = [DayRecord new];
				dayRecord.oddWeek = YES;
				dayRecord.weekday = i;
				[realm addObject:dayRecord];
			}
		}];
	}
}


+ (NSUInteger)indexOfObject:(id)object inResults:(RLMResults *)results
{
	for (NSInteger i=0, cnt=results.count; i<cnt; i++) {
		if ([results[i] isEqual:object]) {
			return i;
		}
	}
	
	return NSNotFound;
}


+ (NSArray *)objects:(id)objects sortedBy:(NSString *)key ascending:(BOOL)asc
{
	RLMResults *results = [objects sortedResultsUsingProperty:key ascending:asc];
	
	NSMutableArray *sortedObjects = [NSMutableArray array];
	for (id object in results) {
		[sortedObjects addObject:object];
	}
	
	return sortedObjects;
}


+ (day_config_t)todayConfig
{
	NSCalendarUnit units = NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear;
	NSDateComponents *comps = [[NSDate sharedCalendar] components:units fromDate:[NSDate date]];
	const BOOL oddWeek = comps.weekOfYear & 1;
	const int weekday = (int) comps.weekday;
	
	day_config_t dc;
	dc.is_odd = oddWeek;
	dc.weekday = weekday;
	return dc;
}


+ (DayRecord *)getDayRecord
{
	day_config_t dc = [AppHelper todayConfig];
	
	RLMResults *dayResults = [DayRecord objectsInRealm:[AppHelper sharedRealm]
												 where:@"weekday == %d AND oddWeek == %d",
							  dc.weekday, dc.is_odd];
	return [dayResults firstObject];
}
@end
