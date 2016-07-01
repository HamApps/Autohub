//
//  TopTensViewController.m
//  Carhub
//
//  Created by Ethan Esval on 7/23/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "TopTensViewController.h"
#import "NewTopTensViewController.h"
#import "AppDelegate.h"
#import "FavoritesViewController.h"
#import "DetailViewController.h"
#import "SWRevealViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface TopTensViewController ()

@end

@implementation TopTensViewController
@synthesize zeroToSixtyButton, topSpeedButton, nurburgringButton, nExpensiveButton, auctionExpensiveButton, fuelEconomyButton, horsepowerButton;

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
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.barButton.target = self.revealViewController;
    self.barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"push0-60"])
    {
        NSString * toptenid = @"0-60 Times";
        [[segue destinationViewController] getTopTenID:toptenid];
    }
    if ([[segue identifier] isEqualToString:@"pushtopspeed"])
    {
        NSString * toptenid = @"Top Speeds";
        [[segue destinationViewController] getTopTenID:toptenid];
    }
    if ([[segue identifier] isEqualToString:@"pushNurb"])
    {
        NSString * toptenid = @"Nürburgring Lap Times";
        [[segue destinationViewController] getTopTenID:toptenid];
    }
    if ([[segue identifier] isEqualToString:@"pushnewexpensive"])
    {
        NSString * toptenid = @"Most Expensive (New Cars)";
        [[segue destinationViewController] getTopTenID:toptenid];
    }
    if ([[segue identifier] isEqualToString:@"pushauctionexpensive"])
    {
        NSString * toptenid = @"Most Expensive (Auction)";
        [[segue destinationViewController] getTopTenID:toptenid];
    }
    if ([[segue identifier] isEqualToString:@"pushfuel"])
    {
        NSString * toptenid = @"Best Fuel Economy";
        [[segue destinationViewController] getTopTenID:toptenid];
    }
    if ([[segue identifier] isEqualToString:@"pushhorsepower"])
    {
        NSString * toptenid = @"Highest Horsepower";
        [[segue destinationViewController] getTopTenID:toptenid];
    }
}

@end
