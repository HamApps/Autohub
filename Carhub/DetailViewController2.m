//
//  DetailViewController2.m
//  Carhub
//
//  Created by Christopher Clark on 7/26/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "DetailViewController2.h"
#import "BackgroundLayer.h"
#import "CompareViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface DetailViewController2 ()

@end

@implementation DetailViewController2

- (AppDelegate *) appdelegate {
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

@synthesize CarMakeLabel, CarModelLabel, CarYearsMadeLabel, CarPriceLabel, CarEngineLabel, CarTransmissionLabel, CarDriveTypeLabel, CarHorsepowerLabel, CarZeroToSixtyLabel, CarTopSpeedLabel, CarWeightLabel, CarFuelEconomyLabel, YearsMade, allLabels;

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
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 800)];
    

    
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"Metal Background.jpg"]];
    
    
    NSString * makewithspace = [_currentCar.CarMake stringByAppendingString:@" "];
    NSString * detailtitle = [makewithspace stringByAppendingString:_currentCar.CarModel];
    self.title = detailtitle;
    

   
    
    if (imageview.image ==nil) {
        
        dispatch_async(kBgQueue, ^{
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_currentCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]];
            if (imgData) {
                UIImage *image = [UIImage imageWithData:imgData];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageview.image = image;
                        [UIImageView beginAnimations:nil context:NULL];
                        [UIImageView setAnimationDuration:.75];
                        [imageview setAlpha:1.0];
                        [UIImageView commitAnimations];
                    });
                }
            }
        });
    }
    
    // Do any additional setup after loading the view.
    
    //Load up the UI
    [self setLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Methods

- (void)getModel:(id)modelObject;
{
    _currentCar = modelObject;
}

- (void)getfirstModel:(id)firstcarObject3;
{
    _firstCar3 = firstcarObject3;
}

- (void)getsecondModel:(id)secondcarObject3;
{
    _secondCar3 = secondcarObject3;
}

- (void)setLabels
{
    /*allLabels.layer.borderWidth=1.0f;
    allLabels.layer.borderColor=[UIColor blackColor].CGColor;
    allLabels.layer.cornerRadius = 7;
    _priceLabels.layer.borderWidth=1.0f;
    _priceLabels.layer.borderColor=[UIColor blackColor].CGColor;
    _priceLabels.layer.cornerRadius = 7;
    _engineLabels.layer.borderWidth=1.0f;
    _engineLabels.layer.borderColor=[UIColor blackColor].CGColor;
    _engineLabels.layer.cornerRadius = 7;
    _transmissionLabels.layer.borderWidth=1.0f;
    _transmissionLabels.layer.borderColor=[UIColor blackColor].CGColor;
    _transmissionLabels.layer.cornerRadius = 7;
    _drivetypeLabels.layer.borderWidth=1.0f;
    _drivetypeLabels.layer.borderColor=[UIColor blackColor].CGColor;
    _drivetypeLabels.layer.cornerRadius = 7;
    _horsepowerLabels.layer.borderWidth=1.0f;
    _horsepowerLabels.layer.borderColor=[UIColor blackColor].CGColor;
    _horsepowerLabels.layer.cornerRadius = 7;
    _zerotosixtyLabels.layer.borderWidth=1.0f;
    _zerotosixtyLabels.layer.borderColor=[UIColor blackColor].CGColor;
    _zerotosixtyLabels.layer.cornerRadius = 7;
    _topspeedLabels.layer.borderWidth=1.0f;
    _topspeedLabels.layer.borderColor=[UIColor blackColor].CGColor;
    _topspeedLabels.layer.cornerRadius = 7;
    _weightLabels.layer.borderWidth=1.0f;
    _weightLabels.layer.borderColor=[UIColor blackColor].CGColor;
    _weightLabels.layer.cornerRadius = 7;
    _fueleconomyLabels.layer.borderWidth=1.0f;
    _fueleconomyLabels.layer.borderColor=[UIColor blackColor].CGColor;
    _fueleconomyLabels.layer.cornerRadius = 7;*/
    
    
    CarMakeLabel.text = _currentCar.CarMake;
    CarModelLabel.text = _currentCar.CarModel;
    
    CarYearsMadeLabel.text = _currentCar.CarYearsMade;
    
    CarPriceLabel.text = _currentCar.CarPrice;
    
    CarEngineLabel.text = _currentCar.CarEngine;
    
    CarTransmissionLabel.text= _currentCar.CarTransmission;
    
    CarDriveTypeLabel.text = _currentCar.CarDriveType;
    
    CarHorsepowerLabel.text = _currentCar.CarHorsepower;
    
    CarZeroToSixtyLabel.text = _currentCar.CarZeroToSixty;
    CarTopSpeedLabel.text = _currentCar.CarTopSpeed;
    CarWeightLabel.text = _currentCar.CarWeight;
    CarFuelEconomyLabel.text = _currentCar.CarFuelEconomy;
    
    YearsMade.text = _currentCar.CarYearsMade;
    
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"pushCompareView"])
    {
        //Get the object for the selected row
        Model * firstcarobject = _currentCar;
        [[segue destinationViewController] getfirstModel:firstcarobject];
        Model * secondcarobject = _secondCar3;
        [[segue destinationViewController] getsecondModel:secondcarobject];

    }
    if ([[segue identifier] isEqualToString:@"pushCompareView2"])
    {
        //Get the object
        Model * secondcarobject = _currentCar;
        [[segue destinationViewController] getsecondModel:secondcarobject];
        Model * firstcarobject = _firstCar3;
        [[segue destinationViewController] getfirstModel:firstcarobject];
    }
    if ([[segue identifier] isEqualToString:@"pushimageview"])
    {
        //Get the object
        Model * firstcarobject = _currentCar;
        [[segue destinationViewController] getfirstModel:firstcarobject];
    }
}

-(IBAction)Website
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:_currentCar.CarWebsite]];
    NSLog(@"website: %@", _currentCar.CarWebsite);
}


#pragma mark iAd Delegate Methods


@end