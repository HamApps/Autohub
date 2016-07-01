//
//  BottomToTopSegue.m
//  Carhub
//
//  Created by Christoper Clark on 6/6/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "BottomToTopSegue.h"

@implementation BottomToTopSegue

-(void)perform
{    
    __block UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    __block UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    CATransition* transition = [CATransition animation];
    transition.duration = .75;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [sourceViewController.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [sourceViewController.navigationController pushViewController:destinationController animated:NO];
}

@end
