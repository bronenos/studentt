//
//  RealmHelper.m
//  StudenTT
//
//  Created by Stan Potemkin on 11/22/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "RealmHelper.h"


static NSString * const kApplicationGroupID	= @"group.me.bronenos.studentt";


@implementation RealmHelper
+ (RLMRealm *)sharedRealm
{
	static NSString *realmPath = nil;
	if (realmPath == nil) {
		NSFileManager *fm = [NSFileManager defaultManager];
		NSURL *containerURL = [fm containerURLForSecurityApplicationGroupIdentifier:kApplicationGroupID];
		realmPath = [[containerURL path] stringByAppendingPathComponent:@"db.realm"];
	}
	
	return [RLMRealm realmWithPath:realmPath];
}


+ (NSUInteger)indexOfObject:(id)object inResults:(RLMResults *)results
{
	for (NSInteger i=0, cnt=results.count; i<cnt; i++) {
		if ([results[i] isEqual:object]) {
			return i;
		}
	}
	
	return NSNotFound;
}


+ (NSArray *)objects:(id)objects sortedBy:(NSString *)key ascending:(BOOL)asc
{
	RLMResults *results = [objects sortedResultsUsingProperty:key ascending:asc];
	
	NSMutableArray *sortedObjects = [NSMutableArray array];
	for (id object in results) {
		[sortedObjects addObject:object];
	}
	
	return sortedObjects;
}
@end
