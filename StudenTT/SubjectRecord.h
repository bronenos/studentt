//
//  LessonRecord.h
//  StudenTT
//
//  Created by Stan Potemkin on 11/19/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "RLMObject.h"


@interface SubjectRecord : RLMObject
@property NSString *title;
@property NSString *location;
@property NSString *teacher;
@end
