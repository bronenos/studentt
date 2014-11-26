//
//  RealmViewController.h
//  StudenTT
//
//  Created by Stan Potemkin on 11/26/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealmHelper.h"


@interface RealmViewController : UIViewController
- (void)onRealmDidUpdate:(NSString *)note;
@end
