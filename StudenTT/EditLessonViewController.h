//
//  EditLessonViewController.h
//  StudenTT
//
//  Created by Stan Potemkin on 11/20/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DayRecord;
@class LessonRecord;


@interface EditLessonViewController : UIViewController
@property(nonatomic, strong) DayRecord *dayRecord;
@property(nonatomic, strong) LessonRecord *lessonRecord;
@end
