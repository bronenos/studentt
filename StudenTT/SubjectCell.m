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
- (void)configureWithSubject:(SubjectRecord *)subjectRecord
{
	self.textLabel.text = subjectRecord.title;
	self.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", subjectRecord.location, subjectRecord.teacher];
}


- (void)configureWithSubject:(SubjectRecord *)subjectRecord isActive:(BOOL)active
{
	[self configureWithSubject:subjectRecord];
	self.accessoryType = active ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}
@end
