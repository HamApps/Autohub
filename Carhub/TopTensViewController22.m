//
//  TopTensViewController22.m
//  Carhub
//
//  Created by Christopher Clark on 10/17/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "TopTensViewController22.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"

@interface TopTensViewController22 ()<GADInterstitialDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation TopTensViewController22

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"whiteback.jpg"]];
    // Do any additional setup after loading the view.
    
    self.interstitial = [[GADInterstitial alloc] init];
    self.interstitial.delegate = self;
    self.interstitial.adUnitID = @"ca-app-pub-3476863246932104/7317472476";
    
    GADRequest *request = [GADRequest request];
    // Requests test ads on simulators.
    //request.testDevices = @[ GAD_SIMULATOR_ID ];
    //request.testDevices = @[ @"00a7c23d2dbe1cd601f20ffb38a73348" ];
    [self.interstitial loadRequest:request];
}

/// Called when an interstitial ad request succeeded.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
