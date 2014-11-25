//
//  NSDate+Utils.h
//  StudenTT
//
//  Created by Stan Potemkin on 11/20/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LessonRecord;


@interface NSDate (Utils)
+ (NSDateFormatter *)sharedFormatter;
+ (NSCalendar *)sharedCalendar;

- (NSString *)timeString;
- (NSDate *)dateWithOnlyTimeAndSeconds:(BOOL)seconds;
- (NSDate *)dateWithTodayDate;

- (BOOL)isBeforeLesson:(LessonRecord *)lessonRecord;
- (BOOL)isDuringLesson:(LessonRecord *)lessonRecord;
@end
