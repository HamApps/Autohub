//
//  NavigationViewController.h
//  Carhub
//
//  Created by Christopher Clark on 6/16/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface NavigationViewController : UITableViewController<UIGestureRecognizerDelegate, SWRevealViewControllerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (assign) BOOL shouldSelectHome;

@end
