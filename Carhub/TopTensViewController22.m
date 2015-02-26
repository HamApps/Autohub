//
//  TopTensViewController22.m
//  Carhub
//
//  Created by Christopher Clark on 10/17/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "TopTensViewController22.h"
#import "NewTopTensViewController.h"
#import "AppDelegate.h"
#import "FavoritesViewController.h"
#import "DetailViewController.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"

@interface TopTensViewController22 ()

@end

@implementation TopTensViewController22
@synthesize zeroToSixtyButton, topSpeedButton, nurburgringButton, mostExpensiveButton, fuelEconomyButton, horsepowerButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"whiteback.jpg"]];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
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
