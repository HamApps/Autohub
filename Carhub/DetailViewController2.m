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
#import "STKAudioPlayer.h"
#import "FavoritesViewController.h"
#import "ImageViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface DetailViewController2 ()

@end
STKAudioPlayer * audioPlayer;

@implementation DetailViewController2

@synthesize CarMakeLabel, CarModelLabel, CarYearsMadeLabel, CarPriceLabel, CarEngineLabel, CarTransmissionLabel, CarDriveTypeLabel, CarHorsepowerLabel, CarZeroToSixtyLabel, CarTopSpeedLabel, CarWeightLabel, CarFuelEconomyLabel, savedArray;

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
    audioPlayer = [[STKAudioPlayer alloc]init];
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 1061)];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"whiteback.jpg"]];
    
    NSString * makewithspace = [_currentCar.CarMake stringByAppendingString:@" "];
    NSString * detailtitle = [makewithspace stringByAppendingString:_currentCar.CarModel];
    self.title = detailtitle;

    NSString *identifier = [[[NSString stringWithFormat:@"%@", _currentCar.CarMake]stringByAppendingString:@" "]stringByAppendingString:_currentCar.CarModel];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imagedata = [defaults objectForKey:identifier];
    imageview.image = [UIImage imageWithData:imagedata];
    [UIImageView beginAnimations:nil context:NULL];
    [UIImageView setAnimationDuration:.01];
    [imageview setAlpha:1.0];
    [UIImageView commitAnimations];

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
    //Load up the UI
    [self setLabels];
}

- (void)viewWillDisappear:(BOOL)animated {
    [audioPlayer stop];
}

-(IBAction)Sound{
    [audioPlayer resume];
    NSString * soundurl = [[[@"http://www.pl0x.net/CarSounds/" stringByAppendingString:_currentCar.CarMake] stringByAppendingString:_currentCar.CarModel]stringByAppendingString:@".mp3"];
    
    [audioPlayer play:soundurl];
    
    NSLog(@"button was pressed");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)Save{
    UIAlertView *savedAlert = [[UIAlertView alloc]initWithTitle:@"Car Saved" message:@"Your car was successfully saved." delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    UIAlertView *notsavedAlert = [[UIAlertView alloc]initWithTitle:@"Car Not Saved" message:@"You have already saved this car." delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    savedArray = [[NSMutableArray alloc]init];
    NSData *retrievedData = [defaults objectForKey:@"savedArray"];
    NSArray *testArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
    if(testArray.count!=0){
        savedArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
        NSLog(@"not nil");
    }else{NSLog(@"nil");}
    bool isThere = false;
    for(int i=0; i<savedArray.count; i++){
        Model * savedObject = [savedArray objectAtIndex:i];
        if([savedObject.CarFullName isEqualToString:_currentCar.CarFullName]){
            isThere = true;
            [notsavedAlert show];
        }
    }
    if(isThere == false){
        [savedArray addObject:_currentCar];
        [savedAlert show];
    }
    NSLog(@"afteraddingobject %@",savedArray);
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:savedArray];
    [defaults setObject:arrayData forKey:@"savedArray"];
    [defaults synchronize];
    
    //Get from defaults
    NSArray *retrievedArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
    [defaults synchronize];
    NSLog(@"retrievedArray: %@", retrievedArray);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadRootViewControllerTable" object:nil];
}


#pragma mark -
#pragma mark Methods

- (void)getModel:(id)modelObject;
{
    _currentCar = modelObject;
}

- (void)setLabels
{
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
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"pushCompareView"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *firstCarData = [NSKeyedArchiver archivedDataWithRootObject:_currentCar];
        [defaults setObject:firstCarData forKey:@"firstcar"];
    }
    if ([[segue identifier] isEqualToString:@"pushCompareView2"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *secondCarData = [NSKeyedArchiver archivedDataWithRootObject:_currentCar];
        [defaults setObject:secondCarData forKey:@"secondcar"];
    }
    if ([[segue identifier] isEqualToString:@"pushimageview"])
    {
        //Get the object
        [[segue destinationViewController] getfirstModel:_currentCar];
    }
}

-(IBAction)Website
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:_currentCar.CarWebsite]];
    NSLog(@"website: %@", _currentCar.CarWebsite);
}

@end