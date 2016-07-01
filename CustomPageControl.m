//
//  CustomPageControl.m
//  Carhub
//
//  Created by Christoper Clark on 1/5/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "CustomPageControl.h"

@implementation CustomPageControl

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    activeImage = [UIImage imageNamed:@"RedBlackScrollDot.png"];
    inactiveImage = [UIImage imageNamed:@"GreyDots.png"];
    self.hasLoaded = NO;
    
    return self;
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIImageView * dot = [self imageViewForSubview:  [self.subviews objectAtIndex: i]];
        if (i == self.currentPage)
        {
            dot.frame = CGRectMake(dot.frame.origin.x, dot.frame.origin.y, 10, 10);
            dot.image = activeImage;
            [dot setCenter: CGPointMake(0, 2)];
        }
        else
        {
            dot.frame = CGRectMake(dot.frame.origin.x, dot.frame.origin.y, 5, 5);
            dot.image = inactiveImage;
            [dot setCenter: CGPointMake(0, 2)];
        }
    }
}
- (UIImageView *) imageViewForSubview: (UIView *) view
{
    UIImageView * dot = nil;
    if ([view isKindOfClass: [UIView class]])
    {
        for (UIView* subview in view.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView *)subview;
                break;
            }
        }
        if (dot == nil)
        {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            [view addSubview:dot];
        }
    }
    else
    {
        dot = (UIImageView *) view;
    }
    
    return dot;
}
-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

@end
