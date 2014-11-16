//
//  UpgradeViewController.h
//  Carhub
//
//  Created by Christopher Clark on 9/14/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "PurchasedViewController.h"

@interface UpgradeViewController : UIViewController  {
    IBOutlet UILabel *Label;
}
- (IBAction)PurchaseItem:(id)sender;

@property (strong, nonatomic) PurchasedViewController *purchaseController;
-(void)Purchased;

@end