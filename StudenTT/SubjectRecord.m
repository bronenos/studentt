//
//  LessonRecord.m
//  StudenTT
//
//  Created by Stan Potemkin on 11/19/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "SubjectRecord.h"


@implementation SubjectRecord
- (BOOL)isEqual:(id)object
{
	if ([self class] != [object class]) {
		return NO;
	}
	
	if ([self.title isEqualToString:[object title]] == NO) {
		return NO;
	}
	
	if ([self.location isEqualToString:[object location]] == NO) {
		return NO;
	}
	
	if ([self.teacher isEqualToString:[object teacher]] == NO) {
		return NO;
	}
	
	return YES;
}
@end
