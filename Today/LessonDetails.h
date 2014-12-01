//
//  LessonDetails.h
//  StudenTT
//
//  Created by Stan Potemkin on 12/2/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LessonRecord;


@interface LessonDetails : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *startTime;
@property(nonatomic, copy) NSString *endTime;
@property(nonatomic, copy) NSString *location;
@property(nonatomic, copy) NSString *teacher;

+ (instancetype)lessonDetailsWithRecord:(LessonRecord *)lessonRecord;

- (NSString *)subjectTimeString;
- (NSString *)locationTeacherString;
- (NSString *)subjectLocationString;
@end
