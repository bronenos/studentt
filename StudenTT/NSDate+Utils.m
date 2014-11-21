//
//  NSDate+Utils.m
//  StudenTT
//
//  Created by Stan Potemkin on 11/20/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "NSDate+Utils.h"


@implementation NSDate (Utils)
+ (NSDateFormatter *)dateFormatter
{
	static id __instance;
	static dispatch_once_t __onceToken;
	
	dispatch_once(&__onceToken, ^{
		__instance = [NSDateFormatter new];
	});
	
	return __instance;
}


+ (NSCalendar *)calendar
{
	static id __instance;
	static dispatch_once_t __onceToken;
	
	dispatch_once(&__onceToken, ^{
		__instance = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
	});
	
	return __instance;
}


- (NSString *)timeString
{
	NSDateFormatter *df = [[self class] dateFormatter];
	[df setDateFormat:@"h:mm"];
	return [df stringFromDate:self];
}


- (NSDate *)dateWithOnlyTime
{
	NSCalendar *cal = [[self class] calendar];
	NSCalendarUnit units = NSCalendarUnitHour | NSCalendarUnitMinute;
	NSDateComponents *comps = [cal components:units fromDate:self];
	return [cal dateFromComponents:comps];
}
@end
