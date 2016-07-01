//
//  DetailViewController.m
//  Carhub
//
//  Created by Christopher Clark on 7/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "DetailViewController.h"
#import "BackgroundLayer.h"
#import "CompareViewController.h"
#import "AppDelegate.h"
#import "FavoritesViewController.h"
#import "TopTensViewController.h"
#import "Model.h"
#import "ImageViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "SpecsCell.h"
#import "SWRevealViewController.h"
#import "CircleProgressBar.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Resize.h"
#import "SDImageCache.h"
#import "NewMakesViewController.h"
#import "Currency.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize saveButton, exhaustButton, savedArray, currentCar, SpecsTableView, carNameLabel, toolBarBackground, upperView, currentTime, circleProgressBar, exhaustDuration, avPlayer, exhaustTimer, exhaustTracker, activityIndicator, isPlaying, hasCalled, hiddenImageScroller, hiddenWebView, hiddenEvoxTrimmingView, hiddenImageView, shouldLoadImage, shouldHaveSpecName, firstCar, secondCar, firstImageView, firstImageScroller, secondImageView, secondImageScroller, hiddenWebView2, hiddenImageView2, hiddenImageScroller2, hiddenEvoxTrimmingView2, hasCalled1, hasCalled2, activityIndicator1, activityIndicator2, firstCarNameLabel, secondCarNameLabel, exhaustLabel, favoriteLabel, websiteLabel, compareLabel, compareButton, websiteButton, changeCar1Button, changeCar2Button, exhaustButton1, exhaustButton2, isplaying1, isplaying2, shouldRevertToDetail, specImageDetailCenter, currencySymbol, hpUnit, speedUnit, weightUnit, fuelEconomyUnit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark View/Initial Loading Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
    
    [firstCarNameLabel setAlpha:0.0];
    [secondCarNameLabel setAlpha:0.0];
    [changeCar1Button setAlpha:0.0];
    [exhaustButton1 setAlpha:0.0];
    [exhaustButton2 setAlpha:0.0];
    [changeCar2Button setAlpha:0.0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = [[currentCar.CarMake stringByAppendingString:@" "] stringByAppendingString:currentCar.CarModel];
    carNameLabel.text = currentCar.CarFullName;
    [upperView sendSubviewToBack:toolBarBackground];
    
    shouldHaveSpecName = YES;
    [SpecsTableView reloadData];
    [self setUpStars];
    [self setUpExhaustProgressWheel];
}

- (void)viewWillAppear:(BOOL)animated {
    if(!([currentCar.CarExhaust isEqual:@""]))
        [exhaustButton setBackgroundImage:[UIImage imageNamed:@"arrows.png"] forState:UIControlStateNormal];
    else
        [exhaustButton setBackgroundImage:[UIImage imageNamed:@"mute.png"] forState:UIControlStateNormal];
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewwilldisappear");
    [avPlayer removeObserver:self forKeyPath:@"status"];
    avPlayer = NULL;
    [circleProgressBar setProgress:1 animated:NO];
    exhaustTracker = 0;
    [exhaustTimer invalidate];
    exhaustTimer = nil;
    hasCalled = NO;
}

- (void)setUpStars
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkStar) name:@"ChangeStar" object:nil];
    if([self isSaved:currentCar] == true)
        [saveButton setBackgroundImage:[UIImage imageNamed:@"FavoriteFilled.png"] forState:UIControlStateNormal];
    else
        [saveButton setBackgroundImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
}

- (void)setUpExhaustProgressWheel
{
    circleProgressBar.progressBarWidth = 5;
    circleProgressBar.progressBarTrackColor = [UIColor whiteColor];
    circleProgressBar.progressBarProgressColor = [UIColor blackColor];
    circleProgressBar.startAngle = -90;
    circleProgressBar.alpha = 0;
}

#pragma Image Loading Methods


#pragma mark Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(void) tableView:(UITableView *) tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SpecsCell";
    SpecsCell *cell2 = (SpecsCell *)[SpecsTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(shouldRevertToDetail)
    {
        if(!cell2.hasRevertedToDetail)
        {
            [self revertCellToDetail:cell2];
            cell2.hasRevertedToDetail = YES;
        }
    }
    
    if(shouldHaveSpecName == NO)
    {
        if(!cell2.hasConvertedToCompare)
        {
            [self convertCellToCompare:cell2];
            cell2.hasConvertedToCompare = YES;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SpecsCell";
    SpecsCell *cell = (SpecsCell *)[SpecsTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[SpecsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    Model *leftCar = firstCar;
    Model *rightCar;
    
    if(shouldRevertToDetail)
    {
        if(!cell.hasRevertedToDetail)
        {
            [self revertCellToDetail:cell];
            cell.hasRevertedToDetail = YES;
        }
    }
    
    if(shouldHaveSpecName == NO)
    {
        if(!cell.hasConvertedToCompare)
        {
            [self convertCellToCompare:cell];
            cell.hasConvertedToCompare = YES;
        }
        rightCar = secondCar;

    }else{
        rightCar = currentCar;
    }

    if(indexPath.row == 0)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"YearsMade.png"];
        cell.SpecName.text = @"Years Made";
        if(leftCar != NULL)
            cell.CarValue.text = leftCar.CarYearsMade;
        else
            cell.CarValue.text = @"";
        if(rightCar != NULL)
            cell.CarValue2.text = rightCar.CarYearsMade;
        else
            cell.CarValue2.text = @"";

    }
    if(indexPath.row == 1)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"Price.png"];
        cell.SpecName.text = @"Market Price";
        
        if(leftCar != NULL)
        {
            NSNumber *convertedPriceLow = [self determineCarPrice:leftCar.CarPriceLow];
            NSNumber *convertedPriceHigh = [self determineCarPrice:leftCar.CarPriceHigh];
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
            [numberFormatter setMaximumFractionDigits:0];
            
            NSString *priceLowString = [numberFormatter stringFromNumber:convertedPriceLow];
            NSString *priceHighString = [numberFormatter stringFromNumber:convertedPriceHigh];
            NSString *combinedPriceString = [[[currencySymbol stringByAppendingString:priceLowString]stringByAppendingString:@" - " ] stringByAppendingString:priceHighString];
            NSString *singlePriceString = [currencySymbol stringByAppendingString:priceLowString];
            
            if(![convertedPriceLow isEqual:convertedPriceHigh])
                cell.CarValue.text = combinedPriceString;
            else
                cell.CarValue.text = singlePriceString;
        }
        else
            cell.CarValue.text = @"";
        
        if(rightCar != NULL)
        {
            NSNumber *convertedPriceLow = [self determineCarPrice:rightCar.CarPriceLow];
            NSNumber *convertedPriceHigh = [self determineCarPrice:rightCar.CarPriceHigh];
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
            [numberFormatter setMaximumFractionDigits:0];
            
            NSString *priceLowString = [numberFormatter stringFromNumber:convertedPriceLow];
            NSString *priceHighString = [numberFormatter stringFromNumber:convertedPriceHigh];
            NSString *combinedPriceString = [[[currencySymbol stringByAppendingString:priceLowString]stringByAppendingString:@" - " ] stringByAppendingString:priceHighString];
            NSString *singlePriceString = [currencySymbol stringByAppendingString:priceLowString];
            
            if(![convertedPriceLow isEqual:convertedPriceHigh])
                cell.CarValue2.text = combinedPriceString;
            else
                cell.CarValue2.text = singlePriceString;
        }
        else
            cell.CarValue2.text = @"";
    }
    if(indexPath.row == 2)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"Price.png"];
        cell.SpecName.text = @"MSRP";
        
        if(leftCar != NULL)
        {
            NSNumber *convertedMSRP = [self determineCarPrice:leftCar.CarMSRP];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
            [numberFormatter setMaximumFractionDigits:0];
            NSString *msrpString = [numberFormatter stringFromNumber:convertedMSRP];
            NSLog(@"currencySymbol, msrpString: %@, %@", currencySymbol, msrpString);
            msrpString = [currencySymbol stringByAppendingString:msrpString];
            
            cell.CarValue.text = msrpString;
        }
        else
            cell.CarValue.text = @"";
        
        if(rightCar != NULL)
        {
            NSNumber *convertedMSRP = [self determineCarPrice:rightCar.CarMSRP];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
            [numberFormatter setMaximumFractionDigits:0];
            NSString *msrpString = [numberFormatter stringFromNumber:convertedMSRP];
            NSLog(@"currencySymbol, msrpString: %@, %@", currencySymbol, msrpString);
            msrpString = [currencySymbol stringByAppendingString:msrpString];
            
            cell.CarValue2.text = msrpString;
        }
        else
            cell.CarValue2.text = @"";
    }
    if(indexPath.row == 3)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"Engine.png"];
        cell.SpecName.text = @"Engine";
        if(leftCar != NULL)
            cell.CarValue.text = leftCar.CarEngine;
        else
            cell.CarValue.text = @"";
        if(rightCar != NULL)
            cell.CarValue2.text = rightCar.CarEngine;
        else
            cell.CarValue2.text = @"";
    }
    if(indexPath.row == 4)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"Transmission&Settings.png"];
        cell.SpecName.text = @"Transmission";
        if(leftCar != NULL)
            cell.CarValue.text = leftCar.CarTransmission;
        else
            cell.CarValue.text = @"";
        if(rightCar != NULL)
            cell.CarValue2.text = rightCar.CarTransmission;
        else
            cell.CarValue2.text = @"";
    }
    if(indexPath.row == 5)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"DriveType.png"];
        cell.SpecName.text = @"Drive Time";
        if(leftCar != NULL)
            cell.CarValue.text = leftCar.CarDriveType;
        else
            cell.CarValue.text = @"";
        if(rightCar != NULL)
            cell.CarValue2.text = rightCar.CarDriveType;
        else
            cell.CarValue2.text = @"";
    }
    if(indexPath.row == 6)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"Horsepower.png"];
        cell.SpecName.text = @"Horsepower";
        
        if(leftCar != NULL)
        {
            NSNumber *convertedHPLow = [self determineHorsepower:leftCar.CarHorsepowerLow];
            NSNumber *convertedHPHigh = [self determineHorsepower:leftCar.CarHorsepowerHigh];
            
            convertedHPLow = [NSNumber numberWithInt:(int)roundf([convertedHPLow doubleValue])];
            convertedHPHigh = [NSNumber numberWithInt:(int)roundf([convertedHPHigh doubleValue])];
            
            NSString *hpLowString = [convertedHPLow stringValue];
            NSString *hpHighString = [convertedHPHigh stringValue];
            
            NSString *combinedHPString = [[[hpLowString stringByAppendingString:@" - " ] stringByAppendingString:hpHighString] stringByAppendingString:hpUnit];
            NSString *singleHPString = [hpLowString stringByAppendingString:hpUnit];
            
            if(![convertedHPLow isEqual:convertedHPHigh])
                cell.CarValue.text = combinedHPString;
            else
                cell.CarValue.text = singleHPString;

        }
        else
            cell.CarValue.text = @"";
        if(rightCar != NULL)
        {
            NSNumber *convertedHPLow = [self determineHorsepower:rightCar.CarHorsepowerLow];
            NSNumber *convertedHPHigh = [self determineHorsepower:rightCar.CarHorsepowerHigh];
            
            convertedHPLow = [NSNumber numberWithInt:(int)roundf([convertedHPLow doubleValue])];
            convertedHPHigh = [NSNumber numberWithInt:(int)roundf([convertedHPHigh doubleValue])];
            
            NSString *hpLowString = [convertedHPLow stringValue];
            NSString *hpHighString = [convertedHPHigh stringValue];
            
            NSString *combinedHPString = [[[hpLowString stringByAppendingString:@" - " ] stringByAppendingString:hpHighString] stringByAppendingString:hpUnit];
            NSString *singleHPString = [hpLowString stringByAppendingString:hpUnit];
            
            if(![convertedHPLow isEqual:convertedHPHigh])
                cell.CarValue2.text = combinedHPString;
            else
                cell.CarValue2.text = singleHPString;
        }
        else
            cell.CarValue2.text = @"";
    }
    if(indexPath.row == 7)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"0-60.png"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([[defaults objectForKey:@"Top Speed"] isEqualToString:@"MPH"])
            cell.SpecName.text = @"0-60";
        else
            cell.SpecName.text = @"0-100";
        
        if(leftCar != NULL)
            cell.CarValue.text = leftCar.CarZeroToSixty;
        else
            cell.CarValue.text = @"";
        if(rightCar != NULL)
            cell.CarValue2.text = rightCar.CarZeroToSixty;
        else
            cell.CarValue2.text = @"";
    }
    if(indexPath.row == 8)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"TopSpeed.png"];
        cell.SpecName.text = @"Top Speed";
        if(leftCar != NULL)
        {
            NSNumber *convertedSpeed = [self determineSpeed:[NSNumber numberWithDouble:[leftCar.CarTopSpeed doubleValue]]];
            convertedSpeed = [NSNumber numberWithInt:(int)roundf([convertedSpeed doubleValue])];
            NSString *topSpeedString = [convertedSpeed stringValue];
            topSpeedString = [topSpeedString stringByAppendingString:speedUnit];
            cell.CarValue.text = topSpeedString;
        }
        else
            cell.CarValue.text = @"";
        if(rightCar != NULL)
        {
            NSNumber *convertedSpeed = [self determineSpeed:[NSNumber numberWithDouble:[rightCar.CarTopSpeed doubleValue]]];
            convertedSpeed = [NSNumber numberWithInt:(int)roundf([convertedSpeed doubleValue])];
            NSString *topSpeedString = [convertedSpeed stringValue];
            topSpeedString = [topSpeedString stringByAppendingString:speedUnit];
            cell.CarValue2.text = topSpeedString;
        }
        else
            cell.CarValue2.text = @"";
    }
    if(indexPath.row == 9)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"Weight.png"];
        cell.SpecName.text = @"Weight";
        if(leftCar != NULL)
        {
            NSNumber *convertedWeightLow = [self determineWeight:leftCar.CarWeightLow];
            NSNumber *convertedWeightHigh = [self determineWeight:leftCar.CarWeightHigh];
            
            convertedWeightLow = [NSNumber numberWithInt:(int)roundf([convertedWeightLow doubleValue])];
            convertedWeightHigh = [NSNumber numberWithInt:(int)roundf([convertedWeightHigh doubleValue])];
            
            NSString *weightLowString = [convertedWeightLow stringValue];
            NSString *weightHighString = [convertedWeightHigh stringValue];
            
            NSString *combinedWeightString = [[[weightLowString stringByAppendingString:@" - " ] stringByAppendingString:weightHighString] stringByAppendingString:weightUnit];
            NSString *singleWeightString = [weightLowString stringByAppendingString:weightUnit];
            
            if(![convertedWeightLow isEqual:convertedWeightHigh])
                cell.CarValue.text = combinedWeightString;
            else
                cell.CarValue.text = singleWeightString;
        }
        else
            cell.CarValue.text = @"";
        if(rightCar != NULL)
        {
            NSNumber *convertedWeightLow = [self determineWeight:rightCar.CarWeightLow];
            NSNumber *convertedWeightHigh = [self determineWeight:rightCar.CarWeightHigh];
            
            convertedWeightLow = [NSNumber numberWithInt:(int)roundf([convertedWeightLow doubleValue])];
            convertedWeightHigh = [NSNumber numberWithInt:(int)roundf([convertedWeightHigh doubleValue])];
            
            NSString *weightLowString = [convertedWeightLow stringValue];
            NSString *weightHighString = [convertedWeightHigh stringValue];
            
            NSString *combinedWeightString = [[[weightLowString stringByAppendingString:@" - " ] stringByAppendingString:weightHighString] stringByAppendingString:weightUnit];
            NSString *singleWeightString = [weightLowString stringByAppendingString:weightUnit];
            
            if(![convertedWeightLow isEqual:convertedWeightHigh])
                cell.CarValue2.text = combinedWeightString;
            else
                cell.CarValue2.text = singleWeightString;
        }
        else
            cell.CarValue2.text = @"";
    }
    if(indexPath.row == 10)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"FuelEconomy.png"];
        cell.SpecName.text = @"Fuel Economy";
        if(leftCar != NULL)
        {
            NSNumber *convertedFELow = [self determineFuelEconomy:leftCar.CarFuelEconomyLow];
            NSNumber *convertedFEHigh = [self determineFuelEconomy:leftCar.CarFuelEconomyHigh];
            
            NSString *FELowString;
            NSString *FEHighString;
            
            if([fuelEconomyUnit isEqualToString:@" L/100 km"])
            {
                NSLog(@"l/100");
                
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setPositiveFormat:@"0.##"];
                
                FELowString = [numberFormatter stringFromNumber:convertedFELow];
                FEHighString = [numberFormatter stringFromNumber:convertedFEHigh];
            }
            else
            {
                convertedFELow = [NSNumber numberWithInt:(int)roundf([convertedFELow doubleValue])];
                convertedFEHigh = [NSNumber numberWithInt:(int)roundf([convertedFEHigh doubleValue])];
                FELowString = [convertedFELow stringValue];
                FEHighString = [convertedFEHigh stringValue];
            }
            NSString *combinedFEString = [[[FELowString stringByAppendingString:@" - " ] stringByAppendingString:FEHighString] stringByAppendingString:fuelEconomyUnit];
            NSString *singleFEString = [FELowString stringByAppendingString:fuelEconomyUnit];
            
            if(![convertedFELow isEqual:convertedFEHigh])
                cell.CarValue.text = combinedFEString;
            else
                cell.CarValue.text = singleFEString;
        }
        else
            cell.CarValue.text = @"";
        if(rightCar != NULL)
        {
            NSNumber *convertedFELow = [self determineFuelEconomy:rightCar.CarFuelEconomyLow];
            NSNumber *convertedFEHigh = [self determineFuelEconomy:rightCar.CarFuelEconomyHigh];
            
            NSString *FELowString;
            NSString *FEHighString;
            
            if([fuelEconomyUnit isEqualToString:@" L/100 km"])
            {
                NSLog(@"l/100");
                
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setPositiveFormat:@"0.##"];
                
                FELowString = [numberFormatter stringFromNumber:convertedFELow];
                FEHighString = [numberFormatter stringFromNumber:convertedFEHigh];
            }
            else
            {
                convertedFELow = [NSNumber numberWithInt:(int)roundf([convertedFELow doubleValue])];
                convertedFEHigh = [NSNumber numberWithInt:(int)roundf([convertedFEHigh doubleValue])];
                FELowString = [convertedFELow stringValue];
                FEHighString = [convertedFEHigh stringValue];
            }
            NSString *combinedFEString = [[[FELowString stringByAppendingString:@" - " ] stringByAppendingString:FEHighString] stringByAppendingString:fuelEconomyUnit];
            NSString *singleFEString = [FELowString stringByAppendingString:fuelEconomyUnit];
            
            if(![convertedFELow isEqual:convertedFEHigh])
                cell.CarValue2.text = combinedFEString;
            else
                cell.CarValue2.text = singleFEString;
        }
        else
            cell.CarValue2.text = @"";
    }
    return cell;
}

-(NSNumber *)determineFuelEconomy:(NSNumber *)mpgValue
{
    NSNumber *convertedFuelEconomy = mpgValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![[defaults objectForKey:@"Fuel Economy"] isEqualToString:@"MPG US"])
    {
        if([[defaults objectForKey:@"Fuel Economy"] isEqualToString:@"MPG UK"])
        {
            convertedFuelEconomy = [NSNumber numberWithDouble:([convertedFuelEconomy doubleValue]*1.20095)];
            fuelEconomyUnit = @" MPG UK";
        }
        if([[defaults objectForKey:@"Fuel Economy"] isEqualToString:@"L/100 km"])
        {
            convertedFuelEconomy = [NSNumber numberWithDouble:(235.22/[convertedFuelEconomy doubleValue])];
            fuelEconomyUnit = @" L/100 km";
        }
    }
    else
        fuelEconomyUnit = @" MPG US";
    
    return convertedFuelEconomy;
}

-(NSNumber *)determineWeight:(NSNumber *)lbsValue
{
    NSNumber *convertedWeight = lbsValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![[defaults objectForKey:@"Weight"] isEqualToString:@"lbs"])
    {
        convertedWeight = [NSNumber numberWithDouble:([convertedWeight doubleValue]*0.453592)];
        weightUnit = @" kg";
    }
    else
        weightUnit = @" lbs";
    
    return convertedWeight;
}

-(NSNumber *)determineSpeed:(NSNumber *)mphValue
{
    NSNumber *convertedSpeed = mphValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![[defaults objectForKey:@"Top Speed"] isEqualToString:@"MPH"])
    {
        convertedSpeed = [NSNumber numberWithDouble:([convertedSpeed doubleValue]*1.60934)];
        speedUnit = @" km/h";
    }
    else
        speedUnit = @" MPH";
    
    return convertedSpeed;
}

-(NSNumber *)determineCarPrice:(NSNumber *)usdPrice
{
    NSNumber *convertedPrice = usdPrice;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *exchangeName;
    Currency *savedCurrency;
    
    if(![[defaults objectForKey:@"Currency"] isEqualToString:@"($) US Dollar"])
    {
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"($) Argentinian Peso"])
        {
            exchangeName = @"USD/ARS";
            currencySymbol = @"($)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"($) Australian Dollar"])
        {
            exchangeName = @"USD/AUD";
            currencySymbol = @"($)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(R$) Brazilian Real"])
        {
            exchangeName = @"USD/BRL";
            currencySymbol = @"(R$)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(£) British Pound"])
        {
            exchangeName = @"USD/GBP";
            currencySymbol = @"(£)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"($) Canadian Dollar"])
        {
            exchangeName = @"USD/CAD";
            currencySymbol = @"($)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"($) Chilean Peso"])
        {
            exchangeName = @"USD/CLP";
            currencySymbol = @"($)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(¥) Chinese Yuan"])
        {
            exchangeName = @"USD/CNY";
            currencySymbol = @"(¥)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(Kč) Czech Koruna"])
        {
            exchangeName = @"USD/CZK";
            currencySymbol = @"(Kč)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(Kč) Danish Kroner"])
        {
            exchangeName = @"USD/DKK";
            currencySymbol = @"(Kč)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(RD$) Dominican Peso"])
        {
            exchangeName = @"USD/DOP";
            currencySymbol = @"(RD$)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(£) Egyptian Pound"])
        {
            exchangeName = @"USD/EGP";
            currencySymbol = @"(£)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(€) European Euro"])
        {
            exchangeName = @"USD/EUR";
            currencySymbol = @"(€)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"($) Hong Kong Dollar"])
        {
            exchangeName = @"USD/HKD";
            currencySymbol = @"($)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(Ft) Hungarian Forint"])
        {
            exchangeName = @"USD/HUF";
            currencySymbol = @"(Ft)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(INR) Indian Rupee"])
        {
            exchangeName = @"USD/INR";
            currencySymbol = @"(INR)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(Rp) Indonesian Rupiah"])
        {
            exchangeName = @"USD/IDR";
            currencySymbol = @"(Rp)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(₪) Israeli New Shekel"])
        {
            exchangeName = @"USD/ILS";
            currencySymbol = @"(₪)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(¥) Japanese Yen"])
        {
            exchangeName = @"USD/JPY";
            currencySymbol = @"(¥)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(RM) Malaysian Ringgit"])
        {
            exchangeName = @"USD/MYR";
            currencySymbol = @"(RM)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"($) Mexican Peso"])
        {
            exchangeName = @"USD/MXN";
            currencySymbol = @"($)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"($) New Zealand Dollar"])
        {
            exchangeName = @"USD/NZD";
            currencySymbol = @"($)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(kr) Norwegian Krone"])
        {
            exchangeName = @"USD/NOK";
            currencySymbol = @"(kr)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(Rs) Pakistani Rupee"])
        {
            exchangeName = @"USD/PKR";
            currencySymbol = @"(Rs)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(zł) Polish Zloty"])
        {
            exchangeName = @"USD/PLN";
            currencySymbol = @"(zł)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(руб) Russian Ruble"])
        {
            exchangeName = @"USD/RUB";
            currencySymbol = @"(руб)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"($) Singapore Dollar"])
        {
            exchangeName = @"USD/SGD";
            currencySymbol = @"($)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(R) South African Rand"])
        {
            exchangeName = @"USD/ZAR";
            currencySymbol = @"(R)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(₩) South Korean Won"])
        {
            exchangeName = @"USD/KRW";
            currencySymbol = @"(₩)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(kr) Swedish Kronor"])
        {
            exchangeName = @"USD/SEK";
            currencySymbol = @"(kr)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(CHF) Swiss Franc"])
        {
            exchangeName = @"USD/CHF";
            currencySymbol = @"(CHF)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(NT$) Taiwanese New Dollar"])
        {
            exchangeName = @"USD/TWD";
            currencySymbol = @"(NT$)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(฿) Thai Baht"])
        {
            exchangeName = @"USD/THB";
            currencySymbol = @"(฿)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(TRY) Turkish New Lira"])
        {
            exchangeName = @"USD/TRY";
            currencySymbol = @"(TRY)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(AED) UAE Dirham"])
        {
            exchangeName = @"USD/AED";
            currencySymbol = @"(AED)";
        }
        
        for(int i=0; i<appdel.currencyArray.count; i++)
        {
            Currency *currentCurrency = [appdel.currencyArray objectAtIndex:i];
            if([currentCurrency.CurrencyName isEqualToString:exchangeName])
            {
                savedCurrency = currentCurrency;
            }
        }
        NSLog(@"savedcurrency: %@", savedCurrency.CurrencyName);
        double exchangeRate = [savedCurrency.CurrencyRate doubleValue];
        convertedPrice = [NSNumber numberWithDouble: exchangeRate * [usdPrice doubleValue]];
    }
    else
        currencySymbol = @"($)";
    return convertedPrice;
}

-(NSNumber *)determineHorsepower:(NSNumber *)hpValue
{
    NSNumber *convertedHP = hpValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![[defaults objectForKey:@"Horsepower"] isEqualToString:@"hp"])
    {
        if([[defaults objectForKey:@"Horsepower"] isEqualToString:@"bhp"])
        {
            convertedHP = [NSNumber numberWithDouble:([convertedHP doubleValue]/1.01387)];
            hpUnit = @" bhp";
        }
        if([[defaults objectForKey:@"Horsepower"] isEqualToString:@"PS"])
        {
            convertedHP = [NSNumber numberWithDouble:([convertedHP doubleValue]*1)];
            hpUnit = @" PS";
        }
        if([[defaults objectForKey:@"Horsepower"] isEqualToString:@"kW"])
        {
            convertedHP = [NSNumber numberWithDouble:([convertedHP doubleValue]*0.7457)];
            hpUnit = @" kW";
        }
    }
    else
        hpUnit = @" hp";
    
    return convertedHP;
}

-(void)convertCellToCompare:(SpecsCell *)cell
{
    [cell.CarValue2 setAlpha:0.0];
    
    [SpecsCell animateWithDuration:.5 animations:^{
        [cell.SpecName setAlpha:0.0];
        specImageDetailCenter = cell.SpecImage.center;
        [cell.SpecImage setCenter:CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2)];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [cell.CarValue2 setTextAlignment:NSTextAlignmentRight];
        [SpecsCell animateWithDuration:.5 animations:^{
            [cell.CarValue setAlpha:1.0];
            [cell.CarValue2 setAlpha:1.0];
        }];
    });
    cell.hasRevertedToDetail = NO;
}

-(void)revertCellToDetail:(SpecsCell *)cell
{
    [cell.CarValue setAlpha:0.0];
    [cell.CarValue2 setAlpha:0.0];
    
    [SpecsCell animateWithDuration:.5 animations:^{
        [cell.SpecImage setCenter:specImageDetailCenter];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [cell.CarValue2 setTextAlignment:NSTextAlignmentLeft];
        [SpecsCell animateWithDuration:.5 animations:^{
            [cell.CarValue2 setAlpha:1.0];
            [cell.SpecName setAlpha:1.0];
        }];
    });
    cell.hasConvertedToCompare = NO;
}

#pragma mark Exhaust Methods

-(IBAction)Sound
{
    if(!([currentCar.CarExhaust isEqual:@""]))
    {
        if (!((avPlayer.rate != 0) && (avPlayer.error == nil)))
        {
            isPlaying = YES;
            if(avPlayer == NULL)
            {
                //[exhaustButton setBackgroundImage:[UIImage imageNamed:@"mute.png"] forState:UIControlStateNormal];
                [self startLoadingWheelWithCenter:exhaustButton.center];
                [self playExhaust];
            }
            else
            {
                [exhaustButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
                [self playAt:currentTime];
            }
        }else{
            //isPlaying = NO;
            [exhaustButton setBackgroundImage:[UIImage imageNamed:@"arrows.png"] forState:UIControlStateNormal];
            currentTime = avPlayer.currentTime;
            [avPlayer pause];
            [exhaustTimer invalidate];
            exhaustTimer = nil;
        }
    }
}

-(void)Sound1
{
    if(isplaying2 == YES)
    {
        [avPlayer removeObserver:self forKeyPath:@"status"];
        avPlayer = NULL;
        exhaustTracker = 0;
        [exhaustTimer invalidate];
        exhaustTimer = nil;
        isplaying2 = NO;
        [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"arrows.png"] forState:UIControlStateNormal];
    }
    
    if(!([firstCar.CarExhaust isEqual:@""]))
    {
        if (!((avPlayer.rate != 0) && (avPlayer.error == nil)))
        {
            isplaying1 = YES;
            [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
            
            if(avPlayer == NULL)
            {
                [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"mute.png"] forState:UIControlStateNormal];
                [self startLoadingWheelWithCenter:exhaustButton.center];
                [self playExhaust1];
            }
            else
            {
                [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
                [self playAt:currentTime];
            }
        }else{
            [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"arrows.png"] forState:UIControlStateNormal];
            currentTime = avPlayer.currentTime;
            [avPlayer pause];
            [exhaustTimer invalidate];
            exhaustTimer = nil;
        }
    }
}

-(void)Sound2
{
    if(isplaying1 == YES)
    {
        [avPlayer removeObserver:self forKeyPath:@"status"];
        avPlayer = NULL;
        exhaustTracker = 0;
        [exhaustTimer invalidate];
        exhaustTimer = nil;
        isplaying1 = NO;
        [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"arrows.png"] forState:UIControlStateNormal];
    }
    
    if(!([secondCar.CarExhaust isEqual:@""]))
    {
        if (!((avPlayer.rate != 0) && (avPlayer.error == nil)))
        {
            isplaying2 = YES;
            
            if(avPlayer == NULL)
            {
                [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"mute.png"] forState:UIControlStateNormal];
                [self startLoadingWheelWithCenter:exhaustButton2.center];
                [self playExhaust2];
            }
            else
            {
                [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
                [self playAt:currentTime];
            }
        }else{
            [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"arrows.png"] forState:UIControlStateNormal];
            currentTime = avPlayer.currentTime;
            [avPlayer pause];
            [exhaustTimer invalidate];
            exhaustTimer = nil;
        }
    }
}

-(void)startLoadingWheelWithCenter:(CGPoint)center
{
    activityIndicator = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = center;
    if(isPlaying || isplaying1 || isplaying2)
        activityIndicator.transform = CGAffineTransformMakeScale(0.5, 0.5);
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.color = [UIColor blackColor];
    [self.upperView addSubview:activityIndicator];
    [activityIndicator startAnimating];
}

-(void)playExhaust
{
    NSString * soundurl = [@"http://www.pl0x.net/CarSounds/" stringByAppendingString:currentCar.CarExhaust];
    avPlayer = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:soundurl]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[avPlayer currentItem]];
    [avPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
}

-(void)playExhaust1
{
    NSString * soundurl = [@"http://www.pl0x.net/CarSounds/" stringByAppendingString:firstCar.CarExhaust];
    avPlayer = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:soundurl]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[avPlayer currentItem]];
    [avPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
}

-(void)playExhaust2
{
    NSString * soundurl = [@"http://www.pl0x.net/CarSounds/" stringByAppendingString:secondCar.CarExhaust];
    avPlayer = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:soundurl]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[avPlayer currentItem]];
    [avPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
}

- (void)updateProgress
{
    exhaustTracker += .05;
    [circleProgressBar setProgress:exhaustTracker/exhaustDuration animated:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == avPlayer && [keyPath isEqualToString:@"status"]) {
        if (avPlayer.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
            
        } else if (avPlayer.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            [avPlayer play];
            
            exhaustTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:exhaustTimer forMode:NSRunLoopCommonModes];
            exhaustDuration = CMTimeGetSeconds(avPlayer.currentItem.asset.duration);
            [circleProgressBar setProgress:1 animated:YES duration:exhaustDuration];
            circleProgressBar.alpha = 1;
            [activityIndicator stopAnimating];
            if(isplaying1)
                [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
            else if(isplaying2)
                [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
            else if (isPlaying)
                [exhaustButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
            
        } else if (avPlayer.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
        }
    }
}

-(void)playAt: (CMTime)time {
    if(avPlayer.status == AVPlayerStatusReadyToPlay && avPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        [avPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            [avPlayer play];
            exhaustTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        }];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self playAt:time];
        });
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    circleProgressBar.alpha = 0;
    [avPlayer removeObserver:self forKeyPath:@"status"];
    [circleProgressBar setProgress:0 animated:NO];
    [exhaustButton setBackgroundImage:[UIImage imageNamed:@"arrows.png"] forState:UIControlStateNormal];
    if(shouldHaveSpecName == NO)
    {
        [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"arrows.png"] forState:UIControlStateNormal];
        [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"arrows.png"] forState:UIControlStateNormal];
    }
    avPlayer = NULL;
    [exhaustTimer invalidate];
    exhaustTimer = nil;
    
    NSLog(@"exhaustTracker: %f", exhaustTracker);
    exhaustTracker = 0.0;
}

#pragma mark Save Favorite Car Methods

-(IBAction)Save{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    savedArray = [[NSMutableArray alloc]init];
    NSData *retrievedData = [defaults objectForKey:@"savedArray"];
    NSArray *testArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
    if(testArray.count!=0)
        savedArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
    
    if([self isSaved:currentCar] == false){
        [saveButton setBackgroundImage:[UIImage imageNamed:@"FavoriteFilled.png"] forState:UIControlStateNormal];
        [savedArray addObject:currentCar];
    }else{
        [saveButton setBackgroundImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
        int index = -1;
        for(int i=0; i<savedArray.count; i++){
            Model * savedObject = [savedArray objectAtIndex:i];
            if([savedObject.CarFullName isEqualToString:currentCar.CarFullName])
                index = i;
        }
        if(index != -1)
            [savedArray removeObjectAtIndex:index];
    }
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
        if([savedObject.CarFullName isEqualToString:currentCar.CarFullName])
            isThere = true;
    }
    return isThere;
}

- (void)checkStar
{
    if([self isSaved:currentCar] == false)
        [saveButton setBackgroundImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
    else
        [saveButton setBackgroundImage:[UIImage imageNamed:@"FavoriteFilled.png"] forState:UIControlStateNormal];
}

#pragma mark External Methods

- (void)getModel:(id)modelObject;
{
    currentCar = modelObject;
}

-(void)getCarOfTheDay:(id)modelObject
{
    currentCar = modelObject;
    shouldLoadImage = YES;
    //[self setCarImage];
}

#pragma mark - Navigation

-(IBAction)Compare
{
    NSLog(@"units: %@, %@, %@, %@, %@", hpUnit, speedUnit, weightUnit, fuelEconomyUnit, currencySymbol);
    [self viewWillDisappear:NO];
    [self setUpExhaustProgressWheel];
    shouldHaveSpecName = NO;
    shouldRevertToDetail = NO;
    [self saveAndGetCars];
    [self.SpecsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [self.SpecsTableView layoutIfNeeded];
    
    [UILabel animateWithDuration:.5 animations:^{
        NewMakesViewController *newMakes = (NewMakesViewController *)self.parentViewController;
        [newMakes.detailImageView setAlpha:0.0];
        
        [compareLabel setAlpha:0.0];
        [exhaustLabel setAlpha:0.0];
        [websiteLabel setAlpha:0.0];
        [favoriteLabel setAlpha:0.0];
        
        [compareButton setAlpha:0.0];
        [exhaustButton setAlpha:0.0];
        
        [websiteButton setAlpha:0.0];
        [saveButton setAlpha:0.0];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [exhaustButton1 addTarget:self action:@selector(Sound1) forControlEvents:UIControlEventTouchUpInside];
        [exhaustButton2 addTarget:self action:@selector(Sound2) forControlEvents:UIControlEventTouchUpInside];
        [self setCompareImages];
        [self setCompareLabels];
    });
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:@selector(revertToDetailView)];
    backButton.tintColor = [UIColor blackColor];
    [self.parentViewController.navigationItem setLeftBarButtonItem: backButton];
}

-(void)revertToDetailView
{
    [self viewWillDisappear:NO];
    shouldHaveSpecName = YES;
    shouldRevertToDetail = YES;
    firstCar = NULL;
    [self.SpecsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [self.SpecsTableView layoutIfNeeded];
    
    [UIImageView animateWithDuration:.5 animations:^{
        [firstImageView setAlpha:0.0];
        [secondImageView setAlpha:0.0];
        [firstCarNameLabel setAlpha:0.0];
        [secondCarNameLabel setAlpha:0.0];
        [changeCar1Button setAlpha:0.0];
        [changeCar2Button setAlpha:0.0];
        [exhaustButton1 setAlpha:0.0];
        [exhaustButton2 setAlpha:0.0];
        
        [compareLabel setAlpha:0.0];
        [exhaustLabel setAlpha:0.0];
        [websiteLabel setAlpha:0.0];
        [favoriteLabel setAlpha:0.0];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        firstImageScroller.minimumZoomScale = 1.0;
        firstImageScroller.maximumZoomScale = 1.0;
        firstImageScroller.zoomScale = 1.0;
        secondImageScroller.minimumZoomScale = 1.0;
        secondImageScroller.maximumZoomScale = 1.0;
        secondImageScroller.zoomScale = 1.0;
        firstImageView.image = nil;
        secondImageView.image = nil;
        
        [compareLabel setText:@"Compare"];
        [exhaustLabel setText:@"Exhaust"];
        [websiteLabel setText:@"Website"];
        [favoriteLabel setText:@"Favorite"];
        
        NewMakesViewController *newMakes = (NewMakesViewController *)self.parentViewController;
        [self viewWillAppear:NO];
        [UIImageView animateWithDuration:.5 animations:^{
            [newMakes.detailImageView setAlpha:1.0];
            [compareButton setAlpha:1.0];
            [exhaustButton setAlpha:1.0];
            [websiteButton setAlpha:1.0];
            [saveButton setAlpha:1.0];
            [compareLabel setAlpha:1.0];
            [exhaustLabel setAlpha:1.0];
            [websiteLabel setAlpha:1.0];
            [favoriteLabel setAlpha:1.0];
        }];
    });
    [self.parentViewController.navigationItem.leftBarButtonItem setTarget:self.parentViewController];
    [self.parentViewController.navigationItem.leftBarButtonItem setAction:@selector(revertToMakesPage)];
}

-(void)saveAndGetCars
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *savedFirstCarData = [defaults objectForKey:@"firstcar"];
    NSData *savedSecondCarData = [defaults objectForKey:@"secondcar"];
    
    NSData *currentCarData = [NSKeyedArchiver archivedDataWithRootObject:currentCar];

    if(savedFirstCarData == NULL)
    {
        firstCar = currentCar;
        [defaults setObject:currentCarData forKey:@"firstcar"];
        
        NSData *secondCarData = [defaults objectForKey:@"secondcar"];
        secondCar = [NSKeyedUnarchiver unarchiveObjectWithData:secondCarData];
    }
    else
    if(savedSecondCarData == NULL)
    {
        secondCar = currentCar;
        [defaults setObject:currentCarData forKey:@"secondcar"];
        
        NSData *firstCarData = [defaults objectForKey:@"firstcar"];
        firstCar = [NSKeyedUnarchiver unarchiveObjectWithData:firstCarData];
    }
    else
    {
        firstCar = currentCar;
        [defaults setObject:currentCarData forKey:@"firstcar"];
        
        NSData *secondCarData = [defaults objectForKey:@"secondcar"];
        secondCar = [NSKeyedUnarchiver unarchiveObjectWithData:secondCarData];
    }
    
    NSLog(@"firstCar: %@ secondCar: %@", firstCar.CarFullName, secondCar.CarFullName);
}

-(void)setCompareImages
{
    if(![firstCar.CarHTML isEqualToString:@""])
        [self setFirstCarEvoxImage];
    else
        [self setFirstCarNormalImage];
    
    if(![secondCar.CarHTML isEqualToString:@""])
        [self setSecondCarEvoxImage];
    else
        [self setSecondCarNormalImage];
}

-(void)setCompareLabels
{
    [firstCarNameLabel setText:firstCar.CarFullName];
    [secondCarNameLabel setText:secondCar.CarFullName];
    [compareLabel setText:@"Change Car 1"];
    [exhaustLabel setText:@"Exhaust 1"];
    [websiteLabel setText:@"Exhaust 2"];
    [favoriteLabel setText:@"Change Car 2"];
    
    [self setCompareExhuastImages];
    
    [UILabel animateWithDuration:.5 animations:^{
        [firstCarNameLabel setAlpha:1.0];
        [secondCarNameLabel setAlpha:1.0];
        [compareLabel setAlpha:1.0];
        [exhaustLabel setAlpha:1.0];
        [websiteLabel setAlpha:1.0];
        [favoriteLabel setAlpha:1.0];
        
        [changeCar1Button setAlpha:1.0];
        [exhaustButton1 setAlpha:1.0];
        [exhaustButton2 setAlpha:1.0];
        [changeCar2Button setAlpha:1.0];
    }];
}

-(void)setCompareExhuastImages
{
    if(firstCar != NULL && !([firstCar.CarExhaust isEqual:@""]))
        [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"arrows.png"] forState:UIControlStateNormal];
    else if(firstCar != NULL)
        [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"mute.png"] forState:UIControlStateNormal];
    if(secondCar != NULL && !([secondCar.CarExhaust isEqual:@""]))
        [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"arrows.png"] forState:UIControlStateNormal];
    else if(secondCar != NULL)
        [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"mute.png"] forState:UIControlStateNormal];
}

-(void)setFirstCarEvoxImage
{
    if([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:firstCar.CarFullName] != NULL)
    {
        [firstImageView setAlpha:1.0];
        [firstImageView setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:firstCar.CarFullName]];
        firstImageView.layer.borderWidth = 2.0;
        firstImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        return;
    }
    
    [self startLoadingWheel1WithCenter:firstImageView.center];
    
    //Create Evox Trimmers outside of screen's view
    hiddenImageScroller = [[UIScrollView alloc]initWithFrame:(CGRectMake(-500, 61, 320, 145))];
    hiddenWebView = [[UIWebView alloc]initWithFrame:(CGRectMake(0, 0, 320, 193))];
    hiddenImageScroller.delegate = self;
    hiddenWebView.delegate = self;
    [hiddenImageScroller addSubview:hiddenWebView];
    
    hiddenEvoxTrimmingView = [[UIView alloc]initWithFrame:(CGRectMake(-500, 0, 288, 145))];
    hiddenImageView = [[UIImageView alloc]initWithFrame:(CGRectMake(-41, -25, 370, 195))];
    [hiddenEvoxTrimmingView addSubview:hiddenImageView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [hiddenWebView loadHTMLString:firstCar.CarHTML baseURL:nil];
    });
}

-(void)setFirstCarNormalImage
{
    __weak UIImageView *weakFirstImageView = firstImageView;
    
    NSURL *imageURL;
    if([firstCar.CarImageURL containsString:@"carno"])
        imageURL = [NSURL URLWithString:firstCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
    else
        imageURL = [NSURL URLWithString:firstCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];
    
    double zoomScale = [firstCar.ZoomScale doubleValue];
    double offSetX = [firstCar.OffsetX doubleValue];
    double offSetY = [firstCar.OffsetY doubleValue];
    
    firstImageScroller.delegate = self;
    
    firstImageView.contentMode = UIViewContentModeScaleAspectFit;
    if(zoomScale != 0)
    {
        firstImageScroller.maximumZoomScale = zoomScale;
        firstImageScroller.minimumZoomScale = zoomScale;
        firstImageScroller.zoomScale = zoomScale;
    }
    [firstImageScroller setContentOffset:CGPointMake(offSetX/2, offSetY/2)];
    [firstImageScroller setScrollEnabled:NO];
    
    [weakFirstImageView setImageWithURL:imageURL
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                  [weakFirstImageView setAlpha:0.0];
                                  [UIImageView animateWithDuration:.5 animations:^{
                                      [weakFirstImageView setAlpha:1.0];
                                  }];
                              }
            usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

-(void)setSecondCarEvoxImage
{
    if([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:secondCar.CarFullName] != NULL)
    {
        [secondImageView setAlpha:1.0];
        [secondImageView setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:secondCar.CarFullName]];
        secondImageView.layer.borderWidth = 2.0;
        secondImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        return;
    }
    
    [self startLoadingWheel2WithCenter:secondImageView.center];
    
    //Create Evox Trimmers outside of screen's view
    hiddenImageScroller2 = [[UIScrollView alloc]initWithFrame:(CGRectMake(-500, 61, 320, 145))];
    hiddenWebView2 = [[UIWebView alloc]initWithFrame:(CGRectMake(0, 0, 320, 193))];
    hiddenImageScroller2.delegate = self;
    hiddenWebView2.delegate = self;
    [hiddenImageScroller2 addSubview:hiddenWebView2];
    
    hiddenEvoxTrimmingView2 = [[UIView alloc]initWithFrame:(CGRectMake(-500, 0, 288, 145))];
    hiddenImageView2 = [[UIImageView alloc]initWithFrame:(CGRectMake(-41, -25, 370, 195))];
    [hiddenEvoxTrimmingView2 addSubview:hiddenImageView2];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [hiddenWebView2 loadHTMLString:secondCar.CarHTML baseURL:nil];
    });
}

-(void)setSecondCarNormalImage
{
    __weak UIImageView *weakSecondImageView = secondImageView;
    
    NSURL *imageURL;
    if([secondCar.CarImageURL containsString:@"carno"])
        imageURL = [NSURL URLWithString:secondCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
    else
        imageURL = [NSURL URLWithString:secondCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];
    
    double zoomScale = [secondCar.ZoomScale doubleValue];
    double offSetX = [secondCar.OffsetX doubleValue];
    double offSetY = [secondCar.OffsetY doubleValue];
    
    secondImageScroller.delegate = self;
    
    secondImageView.contentMode = UIViewContentModeScaleAspectFit;
    if(zoomScale != 0)
    {
        secondImageScroller.maximumZoomScale = zoomScale;
        secondImageScroller.minimumZoomScale = zoomScale;
        secondImageScroller.zoomScale = zoomScale;
    }
    [secondImageScroller setContentOffset:CGPointMake(offSetX/2, offSetY/2)];
    [secondImageScroller setScrollEnabled:NO];
    
    [weakSecondImageView setImageWithURL:imageURL
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                   [weakSecondImageView setAlpha:0.0];
                                   [UIImageView animateWithDuration:.5 animations:^{
                                       [weakSecondImageView setAlpha:1.0];
                                   }];
                               }
             usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if(scrollView == hiddenImageScroller)
        return hiddenWebView;
    else if (scrollView == hiddenImageScroller2)
        return hiddenWebView2;
    else if (scrollView == firstImageScroller)
        return firstImageView;
    else if (scrollView == secondImageScroller)
        return secondImageView;
    else
        return hiddenWebView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIScrollView *webViewScroller;
    
    if(webView == hiddenWebView)
    {
        if(hasCalled1 == YES)
            return;
        hasCalled1 = YES;
        webViewScroller = hiddenImageScroller;
    }
    
    if(webView == hiddenWebView2)
    {
        if(hasCalled2 == YES)
            return;
        hasCalled2 = YES;
        webViewScroller = hiddenImageScroller2;
    }
    
    webViewScroller.maximumZoomScale = 1.1;
    webViewScroller.minimumZoomScale = 1.1;
    webViewScroller.zoomScale = 1.1;
    [webViewScroller setContentOffset:CGPointMake(60, 20)];
    
    [webView setAlpha:1.0];
    //allow time for webview to load and then trim and convert the html file to the imageview
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self imageFromWebView:webView];
    });
    
}

- (UIImage *) imageFromWebView:(UIWebView *)webView
{
    // do image magic
    
    UIImageView *imageView;
    UIImageView *finalImageView;
    UIActivityIndicatorView *loadingWheel;
    
    if(webView == hiddenWebView)
    {
        imageView = hiddenImageView;
        finalImageView = firstImageView;
        loadingWheel = activityIndicator1;
    }
    else if(webView == hiddenWebView2)
    {
        imageView = hiddenImageView2;
        finalImageView = secondImageView;
        loadingWheel = activityIndicator2;
    }
    
    UIGraphicsBeginImageContextWithOptions(webView.bounds.size, NO, 0.0);
    [webView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageView setImage:image];
    [imageView setAlpha:1.0];
    [webView setAlpha:0.0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        //First Evox Cut
        CGSize size = imageView.bounds.size;
        CGRect rect = CGRectMake(size.width / 9, size.height / 1.2 ,
                                 (size.width / .5), (size.height / .6));
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
        UIImage *img = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        [imageView setFrame:CGRectMake(0, 0, 288, 145)];
        [imageView setImage:img];
        
        //Second Evox Cut
        size = imageView.bounds.size;
        rect = CGRectMake(size.width / 9, size.height / 1.2 ,
                          (size.width / .5), (size.height / .6));
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
        img = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        NSLog(@"img: %@", img);
        
        [imageView setFrame:CGRectMake(0, 0, 288, 145)];
        [imageView setImage:img];
        
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        //Create Final Evox ImageView
        CGSize newSize = finalImageView.bounds.size;
        UIGraphicsBeginImageContextWithOptions(newSize, YES, [UIScreen mainScreen].scale);
        [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [finalImageView setAlpha:0];
        [finalImageView setImage:newImage];
        [loadingWheel stopAnimating];
        [UIImageView animateWithDuration:.5 animations:^{
            [finalImageView setAlpha:1.0];
        }];
        finalImageView.layer.borderWidth = 1.0;
        finalImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    });
    return image;
}

-(void)startLoadingWheel1WithCenter:(CGPoint)center
{
    activityIndicator1 = [[UIActivityIndicatorView alloc]
                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator1.center = center;
    activityIndicator1.hidesWhenStopped = YES;
    activityIndicator1.color = [UIColor blackColor];
    [self.upperView addSubview:activityIndicator1];
    [activityIndicator1 startAnimating];
}

-(void)startLoadingWheel2WithCenter:(CGPoint)center
{
    activityIndicator2 = [[UIActivityIndicatorView alloc]
                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator2.center = center;
    activityIndicator2.hidesWhenStopped = YES;
    activityIndicator2.color = [UIColor blackColor];
    [self.upperView addSubview:activityIndicator2];
    [activityIndicator2 startAnimating];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"changeCar1"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"firstcar"];
    }
    if ([[segue identifier] isEqualToString:@"changeCar2"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"secondcar"];
    }
    if ([[segue identifier] isEqualToString:@"pushimageview"])
    {
        [[segue destinationViewController] getfirstModel:currentCar];
    }
}

-(IBAction)Website
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:currentCar.CarWebsite]];
}

@end