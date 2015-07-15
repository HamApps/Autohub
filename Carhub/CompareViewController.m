//
//  CompareViewController.m
//  Carhub
//
//  Created by Christopher Clark on 10/17/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "CompareViewController.h"
#import "AppDelegate.h"
#import "ImageViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "STKAudioPlayer.h"
#import "SWRevealViewController.h"

@interface CompareViewController ()

@end

STKAudioPlayer * audioPlayer1;
STKAudioPlayer * audioPlayer2;

@implementation CompareViewController

@synthesize CarYearsMadeLabel, CarPriceLabel, CarEngineLabel, CarTransmissionLabel, CarDriveTypeLabel, CarHorsepowerLabel, CarZeroToSixtyLabel, CarTopSpeedLabel, CarWeightLabel, CarFuelEconomyLabel, firstCar, secondCar, CarTitleLabel, CarDriveTypeLabel2, CarEngineLabel2, CarFuelEconomyLabel2, CarHorsepowerLabel2, CarPriceLabel2, CarTitleLabel2, CarTopSpeedLabel2, CarTransmissionLabel2, CarWeightLabel2, CarYearsMadeLabel2, CarZeroToSixtyLabel2, isPlaying1, isPlaying2;

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
    
    UIImage* tabBarBackground = [UIImage imageNamed:@"DarkerTabBarColor.png"];
    [toolbar setBackgroundImage:tabBarBackground forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    [toolbar setFrame:CGRectMake(0, 524, 320, 44)];
    
    isPlaying1 = false;
    isPlaying2 = false;
    audioPlayer1 = [[STKAudioPlayer alloc]init];
    audioPlayer2 = [[STKAudioPlayer alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(revertExhaustButton1) name:@"RevertExhaustButton1" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(revertExhaustButton2) name:@"RevertExhaustButton2" object:nil];
    
    [self getCars];
    [self setLabels];
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 910)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [firstimageview setAlpha:1.0];
    [firstimageview sd_setImageWithURL:[NSURL URLWithString:firstCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]];
    
    [secondimageview setAlpha:1.0];
    [secondimageview sd_setImageWithURL:[NSURL URLWithString:secondCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]];

    self.title = @"Model Comparison";
    CarTitleLabel.text = [[firstCar.CarMake stringByAppendingString:@" "] stringByAppendingString:firstCar.CarModel];
    CarTitleLabel2.text = [[secondCar.CarMake stringByAppendingString:@" "] stringByAppendingString:secondCar.CarModel];
}

- (void)viewWillAppear:(BOOL)animated {
    isPlaying1 = false;
    isPlaying2 = false;
    if(!([firstCar.CarExhaust isEqual:@""]))
        [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"ExhaustIconPlay.png"] forState:UIControlStateNormal];
    if(!([secondCar.CarExhaust isEqual:@""]))
        [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"ExhaustIconPlay.png"] forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated {
    [audioPlayer1 stop];
    [audioPlayer2 stop];
}

-(IBAction)Sound1{
    if(!([firstCar.CarExhaust isEqual:@""])){
        if(isPlaying1 == false){
            isPlaying1 = true;
            [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"ExhaustIconPause.png"] forState:UIControlStateNormal];
            [audioPlayer1 resume];
            NSString * soundurl = [@"http://www.pl0x.net/CarSounds/" stringByAppendingString:firstCar.CarExhaust];
            [audioPlayer1 play:soundurl];
        }else{
            isPlaying1 = false;
            [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"ExhaustIconPlay.png"] forState:UIControlStateNormal];
            [audioPlayer1 stop];
        }
    }
}

-(IBAction)Sound2{
    if(!([secondCar.CarExhaust isEqual:@""])){
        if(isPlaying2 == false){
            isPlaying2 = true;
            [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"ExhaustIconPause.png"] forState:UIControlStateNormal];
            [audioPlayer2 resume];
            NSString * soundurl = [@"http://www.pl0x.net/CarSounds/" stringByAppendingString:secondCar.CarExhaust];
            [audioPlayer2 play:soundurl];
        }else{
            isPlaying2 = false;
            [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"ExhaustIconPlay.png"] forState:UIControlStateNormal];
            [audioPlayer2 stop];
        }
    }
}

- (void)revertExhaustButton1
{
    isPlaying1 = false;
    [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"ExhaustIconPlay.png"] forState:UIControlStateNormal];
}

- (void)revertExhaustButton2
{
    isPlaying2 = false;
    [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"ExhaustIconPlay.png"] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark Methods

-(void)getCars
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *firstCarData = [defaults objectForKey:@"firstcar"];
    firstCar = [NSKeyedUnarchiver unarchiveObjectWithData:firstCarData];
    NSData *secondCarData = [defaults objectForKey:@"secondcar"];
    secondCar = [NSKeyedUnarchiver unarchiveObjectWithData:secondCarData];
}

- (void)setLabels
{
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
        //Get the object for the selected row
        [[segue destinationViewController] getfirstModel:firstCar];
    }
    if ([[segue identifier] isEqualToString:@"compareimage2"])
    {
        //Get the object for the selected row
        [[segue destinationViewController] getsecondModel:secondCar];
    }
}

@end