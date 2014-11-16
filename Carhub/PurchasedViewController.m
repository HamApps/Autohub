//
//  PurchasedViewController.m
//  Carhub
//
//  Created by Christopher Clark on 9/14/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "PurchasedViewController.h"
#import "UpgradeViewController.h"

@interface PurchasedViewController ()

@property (strong, nonatomic) UpgradeViewController *homeViewController;

@end

@implementation PurchasedViewController

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
    // Do any additional setup after loading the view from its nib.
    _buyButton.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)GoBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)BuyProduct:(id)sender {
    SKPayment *payment = [SKPayment paymentWithProduct:_product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction)Restore:(id)sender {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    [self UnlockPurchase];
}

-(void)getProductID:(UpgradeViewController *)UpgradeViewController {
    _homeViewController = UpgradeViewController;
    if ([SKPaymentQueue canMakePayments]) {
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:self.productID]];
        request.delegate = self;
        [request start];
    } else
        _productDescription.text = @"Please enable in app purchase in your settings";
}

#pragma mark _
#pragma mark SKProductsRequestDelegate

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *products = response.products;
    if (products.count != 0) {
        _product = products[0];
        _buyButton.enabled = YES;
        _productTitle.text = _product.localizedTitle;
        _productDescription.text = _product.localizedDescription;
    } else {
        _productTitle.text = @"Product Not Found";
    }
    products = response.invalidProductIdentifiers;
    for (SKProduct *product in products) {
        NSLog(@"Product not Found: %@", product);
    }
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:[self UnlockPurchase];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:NSLog(@"Transaction Failed");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            default:
                break;
                
        }
    }
}

-(void)UnlockPurchase {
    _buyButton.enabled = NO;
    [_buyButton setTitle:@"Purchased" forState:UIControlStateDisabled];
    [_homeViewController Purchased];
}

@end