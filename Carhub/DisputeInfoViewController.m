//
//  DisputeInfoViewController.m
//  Carhub
//
//  Created by Christopher Clark on 7/26/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "DisputeInfoViewController.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"

@interface DisputeInfoViewController ()<GADInterstitialDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation DisputeInfoViewController

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
    self.title = @"Info Dispute";
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

- (IBAction)emailButton:(id)sender {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
    [mailController setMailComposeDelegate:self];
    NSString *email = @"hamapplications@gmail.com";
    NSArray *emailArray = [[NSArray alloc]initWithObjects:email, nil];
    NSString *message = [[self myTextView]text];
    [mailController setMessageBody:message isHTML:NO];
    [mailController setToRecipients:emailArray];
    [mailController setSubject:@"SPECS DISPUTE"];
    [self presentViewController:mailController animated:YES completion:nil];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self myTextView]resignFirstResponder];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
