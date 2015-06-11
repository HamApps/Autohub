//
//  MakeViewController.m
//  Carhub
//
//  Created by Christopher Clark on 8/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "AppDelegate.h"
#import "MakeViewController.h"
#import "MakeCell.h"
#import "BackgroundLayer.h"
#import "Make.h"
#import "Model.h"
#import "ModelViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <GoogleMobileAds/GADInterstitial.h>
#import "SDWebImage/UIImageView+WebCache.h"


#define getMakeDataURL @"http://pl0x.net/CarMakesJSON.php"
#define getModelDataURL @"http://pl0x.net/CarHubJSON2.php"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface MakeViewController ()<GADInterstitialDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation MakeViewController
@synthesize makeimageArray, currentMake, modelArray, appdelmodelArray;

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
    //Ad stuff
    self.interstitial = [[GADInterstitial alloc] init];
    self.interstitial.adUnitID = @"ca-app-pub-3476863246932104/7317472476";
    self.interstitial.delegate = self;
    [self.interstitial loadRequest:[GADRequest request]];
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ @"00a7c23d2dbe1cd601f20ffb38a73348" ];
    [self.interstitial loadRequest:request];

    [super viewDidLoad];

    [self makeAppDelModelArray];
    self.title = @"Makes";
    self.view.backgroundColor = [UIColor whiteColor];
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

- (AppDelegate *) appdelegate {
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return makeimageArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MakeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MakeReuseID" forIndexPath:indexPath];
    
    Make * makeObject;
    makeObject = [makeimageArray objectAtIndex:indexPath.item];
    
    cell.layer.borderWidth=0.6f;
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    //Load and fade image
    [cell.MakeImageView sd_setImageWithURL:[NSURL URLWithString:makeObject.MakeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image2.php"]]
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                        [cell.MakeImageView setAlpha:0.0];
                        [UIImageView animateWithDuration:.5 animations:^{
                        [cell.MakeImageView setAlpha:1.0];
                    }];
                }];
    
    cell.MakeNameLabel.text=makeObject.MakeName;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Get the new view controller using [seguedestinationviewcontroller]
    if ([[segue identifier] isEqualToString:@"pushModelView"])
    {
        NSIndexPath * indexPath = [self.collectionView indexPathForCell:sender];
        Make * makeobject = [makeimageArray objectAtIndex:indexPath.row];
        [[segue destinationViewController] getMake:makeobject];
    }
}

- (void) makeAppDelModelArray;
{
    appdelmodelArray = [[NSMutableArray alloc]init];
    makeimageArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelmodelArray addObjectsFromArray:appdel.modelArray];
    
    makeimageArray = [[NSMutableArray alloc]init];
    [makeimageArray addObjectsFromArray:appdel.makeimageArray2];
}

@end
