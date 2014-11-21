//
//  LessonRecord.h
//  StudenTT
//
//  Created by Stan Potemkin on 11/20/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "RLMObject.h"
#import "SubjectRecord.h"


RLM_ARRAY_TYPE(LessonRecord);


@interface LessonRecord : RLMObject
@property NSDate *startTime;
@property NSDate *endTime;
@property SubjectRecord *subject;
@end
