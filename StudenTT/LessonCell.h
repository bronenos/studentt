//
//  LectureCell.h
//  StudenTT
//
//  Created by Stan Potemkin on 11/20/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LessonRecord;


@interface LessonCell : UITableViewCell
- (void)configureWithLesson:(LessonRecord *)lesson;
@end
