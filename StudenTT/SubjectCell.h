//
//  LessonCell.h
//  StudenTT
//
//  Created by Stan Potemkin on 11/19/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SubjectRecord;


@interface SubjectCell : UITableViewCell
- (void)configureWithSubject:(SubjectRecord *)subject;
@end
