//
//  LessonRecord.m
//  StudenTT
//
//  Created by Stan Potemkin on 11/20/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "LessonRecord.h"


@implementation LessonRecord
- (instancetype)copy
{
	LessonRecord *copy = [[self class] new];
	copy.startTime = self.startTime;
	copy.endTime = self.endTime;
	copy.subject = self.subject;
	return copy;
}
@end
