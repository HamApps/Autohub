//
//  CompareViewController2.m
//  Carhub
//
//  Created by Christopher Clark on 10/17/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "CompareViewController2.h"
#import "AppDelegate.h"
#import <GoogleMobileAds/GADInterstitial.h>
#import "ImageViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface CompareViewController2 ()

@end

@implementation CompareViewController2

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
    [self getCars];
    [self setLabels];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 1050)];
    
    [firstimageview setAlpha:1.0];
    [firstimageview sd_setImageWithURL:[NSURL URLWithString:firstCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]];
    
    [secondimageview setAlpha:1.0];
    [secondimageview sd_setImageWithURL:[NSURL URLWithString:secondCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]];
    
    self.title = @"Model Comparison";
    CarTitleLabel.text = [[firstCar.CarMake stringByAppendingString:@" "] stringByAppendingString:firstCar.CarModel];
    CarTitleLabel2.text = [[secondCar.CarMake stringByAppendingString:@" "] stringByAppendingString:secondCar.CarModel];
    
    // Do any additional setup after loading the view.
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Methods

-(void)getCars
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *firstCarData = [defaults objectForKey:@"firstcar"];
    firstCar = [NSKeyedUnarchiver unarchiveObjectWithData:firstCarData];
    NSLog(@"firstCar %@", firstCar.CarFullName);
    
    NSData *secondCarData = [defaults objectForKey:@"secondcar"];
    secondCar = [NSKeyedUnarchiver unarchiveObjectWithData:secondCarData];
    NSLog(@"secondCar %@", secondCar.CarFullName);
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
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"compareimage1"])
    {
        [[segue destinationViewController] getfirstModel:firstCar];
    }
    if ([[segue identifier] isEqualToString:@"compareimage2"])
    {
        [[segue destinationViewController] getsecondModel:secondCar];
    }
}

@end
