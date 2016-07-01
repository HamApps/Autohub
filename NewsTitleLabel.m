//
//  NewsTitleLabel.m
//  Carhub
//
//  Created by Christoper Clark on 6/21/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "NewsTitleLabel.h"

@implementation NewsTitleLabel

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {0, 5, 0, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
