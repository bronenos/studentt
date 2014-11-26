//
//  RealmViewController.m
//  StudenTT
//
//  Created by Stan Potemkin on 11/26/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "RealmViewController.h"


@interface RealmViewController()
@property(nonatomic, strong) RLMNotificationToken *realmToken;

- (void)registerRealm;
- (void)unregisterRealm;
@end


@implementation RealmViewController
#pragma mark - Memory
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		[self registerRealm];
	}
	
	return self;
}


- (void)dealloc
{
	[self unregisterRealm];
}


#pragma mark - Internal
- (void)registerRealm
{
	__weak __typeof(self) weakSelf = self;
	self.realmToken = [[RealmHelper sharedRealm] addNotificationBlock:^(NSString *notification, RLMRealm *realm) {
		[weakSelf onRealmDidUpdate:notification];
	}];
}


- (void)unregisterRealm
{
	[[RealmHelper sharedRealm] removeNotification:self.realmToken];
}


#pragma mark - Events
- (void)onRealmDidUpdate:(NSString *)note
{
	// override
}
@end
