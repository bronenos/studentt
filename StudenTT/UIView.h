//
//  UIView.h
//  StudenTT
//
//  Created by Stan Potemkin on 11/24/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;


IB_DESIGNABLE @interface UIView (IB)
@property(nonatomic) IBInspectable CGFloat borderWidth;
@property(nonatomic) IBInspectable UIColor *borderColor;
@property(nonatomic) IBInspectable CGFloat cornerRadius;
@end
