//
//  PurchasedViewController.h
//  Carhub
//
//  Created by Christopher Clark on 9/14/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface PurchasedViewController : UIViewController <SKPaymentTransactionObserver,SKProductsRequestDelegate> {
}
@property (strong, nonatomic) SKProduct *product;
@property (strong, nonatomic) NSString *productID;

@property (strong, nonatomic) IBOutlet UILabel *productTitle;
@property (strong, nonatomic) IBOutlet UITextView *productDescription;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;

- (IBAction)GoBack:(id)sender;
- (IBAction)BuyProduct:(id)sender;
- (IBAction)Restore:(id)sender;

-(void)getProductID:(UIViewController *)UpgradeViewController;

@end