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

#define DELEGATE ((AppDelegate*)[[UIApplication sharedApplication]delegate])

@interface TopTensViewController ()<GADInterstitialDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial;

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"whiteback.jpg"]];
    
    // Do any additional setup after loading the view.
    
    [super viewDidLoad];
    self.interstitial = [[GADInterstitial alloc] init];
    self.interstitial.adUnitID = @"ca-app-pub-3476863246932104/7317472476";
    self.interstitial.delegate = self;
    [self.interstitial loadRequest:[GADRequest request]];
    
    GADRequest *request = [GADRequest request];
    // Requests test ads on simulators.
    //request.testDevices = @[ GAD_SIMULATOR_ID ];
    request.testDevices = @[ @"00a7c23d2dbe1cd601f20ffb38a73348" ];
    [self.interstitial loadRequest:request];
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:@"showads"] isEqualToString:@"yes"]){
        NSLog(@"Will show ad");
        //[self.interstitial presentFromRootViewController:self];
    }
    if([[defaults objectForKey:@"showads"] isEqualToString:@"no"])
        NSLog(@"Will not show ad");
    NSLog(@"interstitialDidReceiveAd");
}

/// Called when an interstitial ad request failed.
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"interstitialDidFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Called just before presenting an interstitial.
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillPresentScreen");
}

/// Called before the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialWillDismissScreen");
}

/// Called just after dismissing an interstitial and it has animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"interstitialDidDismissScreen");
}

/// Called just before the application will background or terminate because the user clicked on an
/// ad that will launch another application (such as the App Store).
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"interstitialWillLeaveApplication");
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
