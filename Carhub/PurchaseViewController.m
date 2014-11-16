//
//  PurchaseViewController.m
//  Carhub
//
//  Created by Christopher Clark on 9/15/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "PurchaseViewController.h"
#import "InAppDemoViewController.h"
#import "AppDelegate.h"

@interface PurchaseViewController ()
@property (strong, nonatomic) InAppDemoViewController *homeViewController;
@end

@implementation PurchaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    _buyButton.enabled = NO;
    [self getProductInfo: _homeViewController];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getProductInfo: (InAppDemoViewController *) viewController
{
    _homeViewController = viewController;
    
    if ([SKPaymentQueue canMakePayments])
    {
        self.productID = @"com.hamapplications.Autohubpro";
        SKProductsRequest *request = [[SKProductsRequest alloc]
                                      initWithProductIdentifiers:
                                      [NSSet setWithObject:self.productID]];
        request.delegate = self;
        
        [request start];
    }
    else
        _productDescription.text =
        @"Please enable In App Purchase in Settings";
}

#pragma mark -
#pragma mark SKProductsRequestDelegate

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    NSArray *products = response.products;
    
    if (products.count != 0)
    {
        _product = products[0];
        _buyButton.enabled = YES;
        _productTitle.text = _product.localizedTitle;
        _productDescription.text = _product.localizedDescription;
    } else if (products.count == 0)
    {
        NSLog(@"product not found");
    }else{
        _productTitle.text = @"Product not found";
    }
    
    products = response.invalidProductIdentifiers;
    
    for (SKProduct *product in products)
    {
        NSLog(@"Product not found: %@", product);
    }
}

- (IBAction)buyProduct:(id)sender {
    SKPayment *payment = [SKPayment paymentWithProduct:_product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self unlockFeature];
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction Failed");
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}

- (IBAction)Restore:(id)sender {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    [self unlockFeature];
}

-(void)unlockFeature
{
    _buyButton.enabled = NO;
    [_buyButton setTitle:@"Purchased"
                forState:UIControlStateDisabled];
    [_homeViewController enableLevel2];
    
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdel enablepurchase];
}

@end
