//
//  UIView.m
//  StudenTT
//
//  Created by Stan Potemkin on 11/24/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "UIView.h"


@implementation UIView (IB)
- (CGFloat)borderWidth
{
	return self.layer.borderWidth;
}


- (void)setBorderWidth:(CGFloat)borderWidth
{
	self.layer.borderWidth = borderWidth;
}


- (UIColor *)borderColor
{
	return [UIColor colorWithCGColor:self.layer.borderColor];
}


- (void)setBorderColor:(UIColor *)borderColor
{
	self.layer.borderColor = [borderColor CGColor];
}


- (CGFloat)cornerRadius
{
	return self.layer.cornerRadius;
}


- (void)setCornerRadius:(CGFloat)cornerRadius
{
	self.layer.cornerRadius = cornerRadius;
}
@end
