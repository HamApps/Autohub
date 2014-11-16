//
//  InAppDemoViewController.m
//  Carhub
//
//  Created by Christopher Clark on 9/15/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "InAppDemoViewController.h"

@interface InAppDemoViewController ()

@end

@implementation InAppDemoViewController

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
    
    _purchaseController = [[PurchaseViewController alloc]init];
    
    [[SKPaymentQueue defaultQueue]
     addTransactionObserver:_purchaseController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)purchaseItem:(id)sender {
    
    _purchaseController.productID =
    @"com.hamapplications.Autohubpro";
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:_purchaseController];
    
    [self.navigationController
     pushViewController:_purchaseController animated:YES];
    
    [_purchaseController getProductInfo: self];
}

-(void)enableLevel2
{
    _level2Button.enabled = YES;
}

@end
