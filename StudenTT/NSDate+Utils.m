//
//  NSDate+Utils.m
//  StudenTT
//
//  Created by Stan Potemkin on 11/20/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "NSDate+Utils.h"
#import "LessonRecord.h"


@implementation NSDate (Utils)
+ (NSDateFormatter *)sharedFormatter
{
	static id __instance;
	static dispatch_once_t __onceToken;
	
	dispatch_once(&__onceToken, ^{
		__instance = [NSDateFormatter new];
	});
	
	return __instance;
}


+ (NSCalendar *)sharedCalendar
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
	NSDateFormatter *df = [[self class] sharedFormatter];
	[df setDateFormat:@"h:mm"];
	return [df stringFromDate:self];
}


- (NSDate *)dateWithOnlyTimeAndSeconds:(BOOL)seconds
{
	NSCalendar *cal = [[self class] sharedCalendar];
	NSCalendarUnit units = NSCalendarUnitHour | NSCalendarUnitMinute | (seconds ? NSCalendarUnitSecond : 0);
	
	NSDateComponents *comps = [cal components:units fromDate:self];
	return [cal dateFromComponents:comps];
}


- (NSDate *)dateWithTodayDate
{
	NSCalendar *cal = [[self class] sharedCalendar];
	NSCalendarUnit units = NSCalendarUnitWeekday - 1;
	
	NSDateComponents *comps = [cal components:units fromDate:[NSDate date]];
	NSDateComponents *setComps = [cal components:units fromDate:self];
	
	comps.hour = setComps.hour;
	comps.minute = setComps.minute;
	comps.second = setComps.second;
	
	return [cal dateFromComponents:comps];
}


- (BOOL)isBeforeLesson:(LessonRecord *)lessonRecord
{
	if (self.timeIntervalSince1970 > lessonRecord.startTime.timeIntervalSince1970) {
		return NO;
	}
	
	return YES;
}


- (BOOL)isDuringLesson:(LessonRecord *)lessonRecord
{
	if (self.timeIntervalSince1970 < lessonRecord.startTime.timeIntervalSince1970) {
		return NO;
	}
	
	if (self.timeIntervalSince1970 > lessonRecord.endTime.timeIntervalSince1970) {
		return NO;
	}
	
	return YES;
}
@end
