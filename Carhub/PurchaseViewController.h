//
//  PurchaseViewController.h
//  Carhub
//
//  Created by Christopher Clark on 9/15/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface PurchaseViewController : UIViewController
<SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (strong, nonatomic) SKProduct *product;
@property (strong, nonatomic) NSString *productID;
@property (strong, nonatomic) IBOutlet UILabel *productTitle;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;
@property (strong, nonatomic) IBOutlet UIButton *restoreButton;
@property (strong, nonatomic) IBOutlet UITextView *productDescription;
@property (strong, nonatomic) UIImage * purchaseimage;
@property (strong, nonatomic) UIImage * initialimage;
- (IBAction)buyProduct:(id)sender;
- (void)getProductInfo:(UIViewController *)viewController;
@end