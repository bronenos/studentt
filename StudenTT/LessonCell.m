//
//  LectureCell.m
//  StudenTT
//
//  Created by Stan Potemkin on 11/20/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "LessonCell.h"
#import "LessonRecord.h"
#import "NSDate+Utils.h"


@implementation LessonCell
#pragma mark - Public
- (void)configureWithLesson:(LessonRecord *)lesson
{
	NSString *title = lesson.subject.title;
	NSString *location = lesson.subject.location;
	NSString *startTime = [lesson.startTime timeString];
	NSString *endTime = [lesson.endTime timeString];
	
	self.textLabel.text = [NSString stringWithFormat:@"%@, %@", title, location];
	self.detailTextLabel.text = [NSString stringWithFormat:@"%@ – %@", startTime, endTime];
}
@end
