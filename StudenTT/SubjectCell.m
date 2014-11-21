//
//  LessonCell.m
//  StudenTT
//
//  Created by Stan Potemkin on 11/19/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "SubjectCell.h"
#import "SubjectRecord.h"


@implementation SubjectCell
#pragma mark - Public
- (void)configureWithSubject:(SubjectRecord *)subject
{
	self.textLabel.text = subject.title;
	self.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", subject.location, subject.teacher];
}
@end
