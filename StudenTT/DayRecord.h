//
//  DayRecord.h
//  StudenTT
//
//  Created by Stan Potemkin on 11/19/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "RLMObject.h"
#import "RLMArray.h"
#import "LessonRecord.h"


@interface DayRecord : RLMObject
@property BOOL oddWeek;
@property NSInteger weekday;
@property RLMArray<LessonRecord> *lessons;
@end
