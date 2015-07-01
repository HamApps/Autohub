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
#import "SDWebImage/UIImageView+WebCache.h"
#import "SWRevealViewController.h"

@interface DetailViewController2 ()

@end
STKAudioPlayer * audioPlayer;

@implementation DetailViewController2

@synthesize CarYearsMadeLabel, CarPriceLabel, CarEngineLabel, CarTransmissionLabel, CarDriveTypeLabel, CarHorsepowerLabel, CarZeroToSixtyLabel, CarTopSpeedLabel, CarWeightLabel, isPlaying, CarFuelEconomyLabel, savedArray;

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

    isPlaying = false;
    audioPlayer = [[STKAudioPlayer alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkStar) name:@"ChangeStar" object:nil];
    
    if([self isSaved:_currentCar] == true)
        [saveButton setBackgroundImage:[UIImage imageNamed:@"Solid Star@2x.png"] forState:UIControlStateNormal];
    else
        [saveButton setBackgroundImage:[UIImage imageNamed:@"Star Outline@2x.png"] forState:UIControlStateNormal];
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 845)];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = [[_currentCar.CarMake stringByAppendingString:@" "] stringByAppendingString:_currentCar.CarModel];
    
    [imageview setAlpha:1.0];
    [imageview sd_setImageWithURL:[NSURL URLWithString:_currentCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]];
    
    [self setLabels];
}

- (void)viewWillAppear:(BOOL)animated {
    isPlaying = false;
    if(!([_currentCar.CarExhaust isEqual:@""]))
        [exhaustButton setBackgroundImage:[UIImage imageNamed:@"PlayButton@2x.png"] forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated {
    [audioPlayer stop];
}

-(IBAction)Sound{
    if(isPlaying == false){
        isPlaying = true;
        [exhaustButton setBackgroundImage:[UIImage imageNamed:@"PauseButton@2x.png"] forState:UIControlStateNormal];
        [audioPlayer resume];
        NSString * soundurl = [[[@"http://www.pl0x.net/CarSounds/" stringByAppendingString:_currentCar.CarMake] stringByAppendingString:_currentCar.CarModel]stringByAppendingString:@".mp3"];
        [audioPlayer play:soundurl];
    }else{
        isPlaying = false;
        [exhaustButton setBackgroundImage:[UIImage imageNamed:@"PlayButton@2x.png"] forState:UIControlStateNormal];
        [audioPlayer stop];
    }
    
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
    if(testArray.count!=0)
        savedArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
    
    if([self isSaved:_currentCar] == false){
        [saveButton setBackgroundImage:[UIImage imageNamed:@"Solid Star@2x.png"] forState:UIControlStateNormal];
        [savedArray addObject:_currentCar];
        [savedAlert show];
    }else{
        [notsavedAlert show];
    }
    NSLog(@"afteraddingobject %@",savedArray);
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:savedArray];
    [defaults setObject:arrayData forKey:@"savedArray"];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadRootViewControllerTable" object:nil];
}

- (bool)isSaved:(Model *)currentModel
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    savedArray = [[NSMutableArray alloc]init];
    NSData *retrievedData = [defaults objectForKey:@"savedArray"];
    NSArray *testArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
    if(testArray.count!=0)
        savedArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
    
    bool isThere = false;
    for(int i=0; i<savedArray.count; i++){
        Model * savedObject = [savedArray objectAtIndex:i];
        if([savedObject.CarFullName isEqualToString:_currentCar.CarFullName])
            isThere = true;
    }
    return isThere;
}

- (void)checkStar
{
    if([self isSaved:_currentCar] == false)
        [saveButton setBackgroundImage:[UIImage imageNamed:@"Star OutLine@2x.png"] forState:UIControlStateNormal];
    else
        [saveButton setBackgroundImage:[UIImage imageNamed:@"Solid Star@2x.png"] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark Methods

- (void)getModel:(id)modelObject;
{
    _currentCar = modelObject;
}

- (void)setLabels
{
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
}

@end