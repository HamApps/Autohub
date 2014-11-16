//
//  InAppDemoViewController.h
//  Carhub
//
//  Created by Christopher Clark on 9/15/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "PurchaseViewController.h"

@interface InAppDemoViewController : UIViewController
- (IBAction)purchaseItem:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *level2Button;
@property (strong, nonatomic) PurchaseViewController *purchaseController;
-(void)enableLevel2;
@end
