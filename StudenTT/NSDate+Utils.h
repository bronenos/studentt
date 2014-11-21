//
//  NSDate+Utils.h
//  StudenTT
//
//  Created by Stan Potemkin on 11/20/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSDate (Utils)
+ (NSDateFormatter *)dateFormatter;
+ (NSCalendar *)calendar;

- (NSString *)timeString;
- (NSDate *)dateWithOnlyTime;
@end
