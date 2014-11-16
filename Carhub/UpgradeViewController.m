//
//  UpgradeViewController.m
//  Carhub
//
//  Created by Christopher Clark on 9/14/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "UpgradeViewController.h"

@interface UpgradeViewController ()

@end

@implementation UpgradeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PurchaseItem:(id)sender {
    _purchaseController = [[PurchasedViewController alloc] initWithNibName:nil bundle:nil];
    _purchaseController.productID = @"com.hamapplications.autohub.autohubpro";
    [[SKPaymentQueue defaultQueue] addTransactionObserver:_purchaseController];
    [self presentViewController:_purchaseController animated:YES completion:NULL];
    [_purchaseController getProductID:self];
}

-(void)Purchased {
    Label.text = @"item has been purchased";
}

@end