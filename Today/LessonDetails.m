//
//  LessonDetails.m
//  StudenTT
//
//  Created by Stan Potemkin on 12/2/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "LessonDetails.h"
#import "LessonRecord.h"
#import "SubjectRecord.h"
#import "NSDate+Utils.h"


@implementation LessonDetails
+ (instancetype)lessonDetailsWithRecord:(LessonRecord *)lessonRecord
{
	LessonDetails *details = [self new];
	details.title = lessonRecord.subject.title;
	details.startTime = [lessonRecord.startTime timeString];
	details.endTime = [lessonRecord.endTime timeString];
	details.location = lessonRecord.subject.location;
	details.teacher = lessonRecord.subject.teacher;
	return details;
}


- (NSString *)subjectTimeString
{
	return [NSString stringWithFormat:@"%@, %@ - %@",
			self.title, self.startTime, self.endTime];
}


- (NSString *)locationTeacherString
{
	return [NSString stringWithFormat:@"%@, %@",
			self.location, self.teacher];
}


- (NSString *)subjectLocationString
{
	return [NSString stringWithFormat:@"%@, %@",
			self.title, self.location];
}
@end
