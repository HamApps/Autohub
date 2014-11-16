//
//  TopTensViewController.m
//  Carhub
//
//  Created by Ethan Esval on 7/23/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "TopTensViewController.h"
#import "AppDelegate.h"
#import "FavoritesViewController.h"
#import "DetailViewController.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"

#define DELEGATE ((AppDelegate*)[[UIApplication sharedApplication]delegate])

@interface TopTensViewController ()<GADInterstitialDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation TopTensViewController
@synthesize toptensarray;

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"Metal Background.jpg"]];
    
    DetailViewController * detailview = [[DetailViewController alloc]init];
    detailview.currentCararray = [[NSMutableArray alloc]init];
    //detailview.currentCararray = [NSMutableArray arrayWithObject:detailview.currentCararray];
    AppDelegate *appdel = DELEGATE;
    appdel.favoritesarray = [[NSMutableArray alloc]init];
    toptensarray = [[NSMutableArray alloc]init];
    
    NSLog(@"currentCararray%@", toptensarray);
    
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
    [self.interstitial presentFromRootViewController:self];
}

/// Called when an interstitial ad request succeeded.
//- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
//NSLog(@"interstitialDidReceiveAd");
//}

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

- (AppDelegate *) appdelegate {
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

-(void)disableAds
{
    // Turn the ads off.
    self.interstitial.delegate = nil;
}

@end
