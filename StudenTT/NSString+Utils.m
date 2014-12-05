//
//  NSString+Utils.m
//  StudenTT
//
//  Created by Stan Potemkin on 12/5/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "NSString+Utils.h"
#import "AppHelper.h"


@implementation NSString (Utils)
- (NSString *)loc
{
	NSBundle *langBundle = [NSBundle mainBundle];
	return NSLocalizedStringFromTableInBundle(self, @"Common", langBundle, nil);
}
@end
