//
//  TopTensViewController.m
//  Carhub
//
//  Created by Ethan Esval on 7/23/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <GoogleMobileAds/GADInterstitial.h>
#import "TopTensViewController.h"
#import "NewTopTensViewController.h"
#import "AppDelegate.h"
#import "FavoritesViewController.h"
#import "DetailViewController.h"

@interface TopTensViewController ()

@end

@implementation TopTensViewController
@synthesize zeroToSixtyButton, topSpeedButton, nurburgringButton, mostExpensiveButton, fuelEconomyButton, horsepowerButton;

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
    
    self.view.backgroundColor = [UIColor whiteColor];

    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"push0-60"])
    {
        NSString * toptenid = zeroToSixtyButton.titleLabel.text;
        [[segue destinationViewController] getTopTenID:toptenid];
    }
    if ([[segue identifier] isEqualToString:@"pushtopspeed"])
    {
        NSString * toptenid = topSpeedButton.titleLabel.text;
        [[segue destinationViewController] getTopTenID:toptenid];
    }
    if ([[segue identifier] isEqualToString:@"pushNurb"])
    {
        NSString * toptenid = nurburgringButton.titleLabel.text;
        [[segue destinationViewController] getTopTenID:toptenid];
    }

    if ([[segue identifier] isEqualToString:@"pushexpensive"])
    {
        NSString * toptenid = mostExpensiveButton.titleLabel.text;
        [[segue destinationViewController] getTopTenID:toptenid];
    }

    if ([[segue identifier] isEqualToString:@"pushfuel"])
    {
        NSString * toptenid = fuelEconomyButton.titleLabel.text;
        [[segue destinationViewController] getTopTenID:toptenid];
    }

    if ([[segue identifier] isEqualToString:@"pushhorsepower"])
    {
        NSString * toptenid = horsepowerButton.titleLabel.text;
        [[segue destinationViewController] getTopTenID:toptenid];
    }
}

@end
