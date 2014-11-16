//
//  CompareViewController.m
//  Carhub
//
//  Created by Christopher Clark on 7/22/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "CompareViewController.h"
#import "AppDelegate.h"
#import "FavoritesClass.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface CompareViewController ()<GADInterstitialDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation CompareViewController

- (AppDelegate *) appdelegate {
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

@synthesize CarMakeLabel, CarModelLabel, CarYearsMadeLabel, CarPriceLabel, CarEngineLabel, CarTransmissionLabel, CarDriveTypeLabel, CarHorsepowerLabel, CarZeroToSixtyLabel, CarTopSpeedLabel, CarWeightLabel, CarFuelEconomyLabel, firstCar, secondCar, CarTitleLabel, CarDriveTypeLabel2, CarEngineLabel2, CarFuelEconomyLabel2, CarHorsepowerLabel2, CarMakeLabel2, CarModelLabel2, CarPriceLabel2, CarTitleLabel2, CarTopSpeedLabel2, CarTransmissionLabel2, CarWeightLabel2, CarYearsMadeLabel2, CarZeroToSixtyLabel2;

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
    
    [self setLabels];
    
    //firstimageview.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:firstCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]]];
    //secondimageview.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:secondCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]]];
    
    if (firstimageview.image ==nil) {
        
        dispatch_async(kBgQueue, ^{
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:firstCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]];
            if (imgData) {
                UIImage *image = [UIImage imageWithData:imgData];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        firstimageview.image = image;
                        [UIImageView beginAnimations:nil context:NULL];
                        [UIImageView setAnimationDuration:.75];
                        [firstimageview setAlpha:1.0];
                        [UIImageView commitAnimations];
                    });
                }
            }
        });
    }
    
    if (secondimageview.image ==nil) {
        
        dispatch_async(kBgQueue, ^{
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:secondCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]];
            if (imgData) {
                UIImage *image = [UIImage imageWithData:imgData];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        secondimageview.image = image;
                        [UIImageView beginAnimations:nil context:NULL];
                        [UIImageView setAnimationDuration:.75];
                        [secondimageview setAlpha:1.0];
                        [UIImageView commitAnimations];
                    });
                }
            }
        });
    }


    
    
    NSString * makewithspace = [firstCar.CarMake stringByAppendingString:@" "];
    NSString * detailtitle = [makewithspace stringByAppendingString:firstCar.CarModel];
    NSString * makewithspace2 = [secondCar.CarMake stringByAppendingString:@" "];
    NSString * detailtitle2 = [makewithspace2 stringByAppendingString:secondCar.CarModel];
    
    FavoritesClass *favoriteclass = [[FavoritesClass alloc]init];
    
    NSLog(@"FavoriteClassCar%@",favoriteclass.favoritearray);
    
    self.title = @"Model Comparison";
    CarTitleLabel.text = detailtitle;
    CarTitleLabel2.text = detailtitle2;
    

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


#pragma mark -
#pragma mark Methods

- (void)getfirstModel:(id)firstcarObject;
{
    firstCar = firstcarObject;
}
- (void)getsecondModel:(id)secondcarObject;
{
    secondCar = secondcarObject;
}

- (void)setLabels
{
    CarMakeLabel.text = firstCar.CarMake;
    CarModelLabel.text = firstCar.CarModel;
    CarYearsMadeLabel.text = firstCar.CarYearsMade;
    CarPriceLabel.text = firstCar.CarPrice;
    CarEngineLabel.text = firstCar.CarEngine;
    CarTransmissionLabel.text= firstCar.CarTransmission;
    CarDriveTypeLabel.text = firstCar.CarDriveType;
    CarHorsepowerLabel.text = firstCar.CarHorsepower;
    CarZeroToSixtyLabel.text = firstCar.CarZeroToSixty;
    CarTopSpeedLabel.text = firstCar.CarTopSpeed;
    CarWeightLabel.text = firstCar.CarWeight;
    CarFuelEconomyLabel.text = firstCar.CarFuelEconomy;
    
    CarMakeLabel2.text = secondCar.CarMake;
    CarModelLabel2.text = secondCar.CarModel;
    CarYearsMadeLabel2.text = secondCar.CarYearsMade;
    CarPriceLabel2.text = secondCar.CarPrice;
    CarEngineLabel2.text = secondCar.CarEngine;
    CarTransmissionLabel2.text= secondCar.CarTransmission;
    CarDriveTypeLabel2.text = secondCar.CarDriveType;
    CarHorsepowerLabel2.text = secondCar.CarHorsepower;
    CarZeroToSixtyLabel2.text = secondCar.CarZeroToSixty;
    CarTopSpeedLabel2.text = secondCar.CarTopSpeed;
    CarWeightLabel2.text = secondCar.CarWeight;
    CarFuelEconomyLabel2.text = secondCar.CarFuelEconomy;
    
    NSLog(@"%@", firstCar);
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([[segue identifier] isEqualToString:@"pushMakesView"])
     {
         //Get the object for the selected row
         Model * firstcarobject1 = firstCar;
         [[segue destinationViewController] getfirstModel:firstcarobject1];
 }
     if ([[segue identifier] isEqualToString:@"pushMakesView2"])
     {
         Model * secondcarobject1 = secondCar;
         [[segue destinationViewController] getsecondModel:secondcarobject1];
     }
     if ([[segue identifier] isEqualToString:@"compareimage1"])
     {
         //Get the object for the selected row
         Model * firstcarobject1 = firstCar;
         [[segue destinationViewController] getfirstModel:firstcarobject1];
     }
     if ([[segue identifier] isEqualToString:@"compareimage2"])
     {
         //Get the object for the selected row
         Model * secondcarobject1 = secondCar;
         [[segue destinationViewController] getsecondModel:secondcarobject1];
     }

 }


@end
