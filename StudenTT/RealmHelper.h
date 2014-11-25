//
//  RealmHelper.h
//  StudenTT
//
//  Created by Stan Potemkin on 11/22/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLMRealm.h"
#import "RLMResults.h"


@interface RealmHelper : NSObject
+ (RLMRealm *)sharedRealm;
+ (NSUInteger)indexOfObject:(id)object inResults:(RLMResults *)results;
+ (NSArray *)objects:(id)objects sortedBy:(NSString *)key ascending:(BOOL)asc;
@end
