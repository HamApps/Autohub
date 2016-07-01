//
//  SearchTestViewController.m
//  Carhub
//
//  Created by Christoper Clark on 11/24/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import "SearchTestViewController.h"
#import "AppDelegate.h"
#import "SearchModelController.h"
#import "SWRevealViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface SearchTestViewController ()

@end

@implementation SearchTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
    
    self.barButton.target = self.revealViewController;
    self.barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self makeAppDelModelArray];
    self.currentSpecArray = [[NSMutableArray alloc]init];
    self.priceData = [[NSArray alloc]initWithObjects:@"Any", @"$0-5,000",@"$5,000-10,000",@"$10,000-20,000",@"$20,000-30,000", @"$30,000-40,000", @"$40,000-50,000", @"$50,000-65,000", @"$65,000-80,000", @"$80,000-100,000", @"$100,000-150,000", @"$150,000-200,000", @"$200,000-500,000", @"$500,000+", nil];
    self.engineData = [[NSArray alloc] initWithObjects:@"Any", @"Electric/Hybrid", @"3 Cylinder", @"4 Cylinder", @"5 Cylinder", @"6 Cylinder", @"8 Cylinder", @"10 Cylinder", @"12 Cylinder", @"16 Cylinder", @"Rotary", nil];
    self.transmissionData = [[NSArray alloc] initWithObjects:@"Any", @"Automatic", @"Manual", @"CVT", nil];
    self.driveTypeData = [[NSArray alloc] initWithObjects:@"Any", @"4WD", @"AWD", @"FWD", @"RWD", nil];
    self.horsepowerData = [[NSArray alloc] initWithObjects:@"Any", @"0-99", @"100-200", @"201-300", @"301-400", @"401-500", @"501-600", @"601-700", @"700+", nil];
    self.zeroToSixtyData = [[NSArray alloc] initWithObjects:@"Any", @"2-3.0 secs", @"3.1-4.0 secs", @"4.1-5.0 secs", @"5.1-5.5 secs", @"5.6-6.0 secs", @"6.1-6.5 secs", @"6.6-7.0 secs", @"7.1-8.0 secs", @"8.1-9.0 secs", @"9.1-10.0 secs", @"10.1+ secs", nil];
    self.fuelEconomyData = [[NSArray alloc] initWithObjects:@"Any", @"0-10", @"11-20", @"21-30", @"31-40", @"41-50", @"51+", nil];
    
    //[self setInitialModels];
    
    [self.btnOutlet setTitle:@"Any" forState:UIControlStateNormal];
    [self.btnOutlet2 setTitle:@"Any" forState:UIControlStateNormal];
    [self.btnOutlet3 setTitle:@"Any" forState:UIControlStateNormal];
    [self.btnOutlet4 setTitle:@"Any" forState:UIControlStateNormal];
    [self.btnOutlet5 setTitle:@"Any" forState:UIControlStateNormal];
    [self.btnOutlet6 setTitle:@"Any" forState:UIControlStateNormal];
    [self.btnOutlet7 setTitle:@"Any" forState:UIControlStateNormal];
    [self.btnOutlet8 setTitle:@"Any" forState:UIControlStateNormal];
    [self.btnOutlet9 setTitle:@"Any" forState:UIControlStateNormal];
    
    [self.btnOutlet setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    [self.btnOutlet2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    [self.btnOutlet3 setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    [self.btnOutlet4 setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    [self.btnOutlet5 setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    [self.btnOutlet6 setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    [self.btnOutlet7 setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    [self.btnOutlet8 setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    [self.btnOutlet9 setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    
    [self.scroller setScrollEnabled:YES];
    [self.scroller setContentSize:CGSizeMake(320, 1050)];
    
    self.picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, 320, 160)];
    
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    self.doneButton = [[UIButton alloc]initWithFrame:CGRectMake(250, 0, 70, 50)];
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.doneButton.titleLabel setFont:[UIFont fontWithName:@"MavenProRegular" size:20]];
    [self.doneButton addTarget:self action:@selector(doneBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    self.pickerViewPopup = [[UIView alloc]initWithFrame:CGRectMake(0, 358, 320, 210)];
    
    [self.pickerViewPopup setBackgroundColor:[UIColor colorWithRed:189/255.0 green:189/255.0 blue:195/255.0 alpha:1]];
    self.pickerViewPopup.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blackColor]);
    self.pickerViewPopup.layer.borderWidth = 5;
    [self.view addSubview:self.pickerViewPopup];
    [self.pickerViewPopup addSubview:self.picker];
    [self.pickerViewPopup addSubview:self.doneButton];
    [self.view bringSubviewToFront:self.pickerViewPopup];
    
    [self.pickerViewPopup setHidden:YES];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = (UILabel*)view;
    if (!label)
    {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont fontWithName:@"MavenProRegular" size:22]];
    }
    
    [label setText:[self.currentSpecArray objectAtIndex:row]];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    return label;
}

-(void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.currentSpecArray == self.priceData)
    {
        [self.btnOutlet setTitle:[self.currentSpecArray objectAtIndex:row] forState:UIControlStateNormal];
        if (row == 0)
            self.PricePredicate = [NSPredicate predicateWithFormat:@"CarPrice.length > 0"];
        if (row == 1)
            self.PricePredicate = [NSPredicate predicateWithFormat:@"(CarPriceHigh<=5000 OR CarPriceLow<=5000) AND NOT (CarPrice CONTAINS %@)", @"N/A"];
        if (row == 2)
            self.PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=5000 AND CarPriceHigh<=10000) OR (CarPriceLow>=5000 AND CarPriceLow<=10000))"];
        if (row == 3)
            self.PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=10000 AND CarPriceHigh<=20000) OR (CarPriceLow>=10000 AND CarPriceLow<=20000))"];
        if (row == 4)
            self.PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=20000 AND CarPriceHigh<=30000) OR (CarPriceLow>=20000 AND CarPriceLow<=30000))"];
        if (row == 5)
            self.PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=30000 AND CarPriceHigh<=40000) OR (CarPriceLow>=30000 AND CarPriceLow<=40000))"];
        if (row == 6)
            self.PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=40000 AND CarPriceHigh<=50000) OR (CarPriceLow>=40000 AND CarPriceLow<=50000))"];
        if (row == 7)
            self.PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=50000 AND CarPriceHigh<=65000) OR (CarPriceLow>=50000 AND CarPriceLow<=65000))"];
        if (row == 8)
            self.PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=65000 AND CarPriceHigh<=80000) OR (CarPriceLow>=65000 AND CarPriceLow<=80000))"];
        if (row == 9)
            self.PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=80000 AND CarPriceHigh<=100000) OR (CarPriceLow>=80000 AND CarPriceLow<=100000))"];
        if (row == 10)
            self.PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=100000 AND CarPriceHigh<=150000) OR (CarPriceLow>=100000 AND CarPriceLow<=150000))"];
        if (row == 11)
            self.PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=150000 AND CarPriceHigh<=200000) OR (CarPriceLow>=150000 AND CarPriceLow<=200000))"];
        if (row == 12)
            self.PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=200000 AND CarPriceHigh<=500000) OR (CarPriceLow>=200000 AND CarPriceLow<=500000))"];
        if (row == 13)
            self.PricePredicate = [NSPredicate predicateWithFormat:@"(CarPriceHigh>=500000 OR CarPriceLow>=500000)"];
        
        self.pricePredicateArray = [self.initialModelArray filteredArrayUsingPredicate:self.PricePredicate];
    }
    if (self.currentSpecArray == self.engineData)
    {
        [self.btnOutlet2 setTitle:[self.currentSpecArray objectAtIndex:row] forState:UIControlStateNormal];
        if (row == 0){
            self.EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine.length > 0"];
        }
        if (row == 1){
            self.EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine CONTAINS %@", @"Electric"];
        }
        if (row == 2){
            self.EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine CONTAINS %@", @"l3"];
        }
        if (row == 3){
            self.EnginePredicate = [NSPredicate predicateWithFormat:@"(CarEngine CONTAINS %@) OR (CarEngine CONTAINS %@)", @"Flat-4", @"l4"];
        }
        if (row == 4){
            self.EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine CONTAINS %@", @"l5"];
        }
        if (row == 5){
            self.EnginePredicate = [NSPredicate predicateWithFormat:@"(CarEngine CONTAINS %@) OR (CarEngine CONTAINS %@) OR (CarEngine CONTAINS %@)", @"Flat-6", @"V6", @"l6"];
        }
        if (row == 6){
            self.EnginePredicate = [NSPredicate predicateWithFormat:@"(CarEngine CONTAINS %@) OR (CarEngine CONTAINS %@)", @"V8", @"l8"];
        }
        if (row == 7){
            self.EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine CONTAINS %@", @"V10"];
        }
        if (row == 8){
            self.EnginePredicate = [NSPredicate predicateWithFormat:@"(CarEngine CONTAINS %@) OR (CarEngine CONTAINS %@) OR (CarEngine CONTAINS %@)", @"F12", @"V12", @"W12"];
        }
        if (row == 9){
            self.EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine CONTAINS %@", @"W16"];
        }
        if (row == 10){
            self.EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine CONTAINS %@", @"Rotary"];
        }
        self.enginePredicateArray = [self.initialModelArray filteredArrayUsingPredicate:self.EnginePredicate];
        NSLog(@"enginepredicatearray: %lu", (unsigned long)self.enginePredicateArray.count);
    }
    if (self.currentSpecArray == self.transmissionData)
    {
        [self.btnOutlet3 setTitle:[self.currentSpecArray objectAtIndex:row] forState:UIControlStateNormal];
        if (row == 0){
            self.TransmissionPredicate = [NSPredicate predicateWithFormat:@"CarTransmission.length > 0"];
        }
        if (row == 1){
            self.TransmissionPredicate = [NSPredicate predicateWithFormat:@"CarTransmission CONTAINS %@", @"Automatic"];
        }
        if (row == 2){
            self.TransmissionPredicate = [NSPredicate predicateWithFormat:@"CarTransmission CONTAINS %@", @"Manual"];
        }
        if (row == 3){
            self.TransmissionPredicate = [NSPredicate predicateWithFormat:@"CarTransmission CONTAINS %@", @"CVT"];
        }
        self.transmissionPredicateArray = [self.initialModelArray filteredArrayUsingPredicate:self.TransmissionPredicate];
        NSLog(@"transmissionpredicatearray: %lu", (unsigned long)self.transmissionPredicateArray.count);
    }
    if (self.currentSpecArray == self.driveTypeData)
    {
        [self.btnOutlet4 setTitle:[self.currentSpecArray objectAtIndex:row] forState:UIControlStateNormal];
        if (row == 0){
            self.DriveTypePredicate = [NSPredicate predicateWithFormat:@"CarDriveType.length > 0"];
        }
        if (row == 1){
            self.DriveTypePredicate = [NSPredicate predicateWithFormat:@"CarDriveType CONTAINS %@", @"4WD"];
        }
        if (row == 2){
            self.DriveTypePredicate = [NSPredicate predicateWithFormat:@"CarDriveType CONTAINS %@",@"AWD"];
        }
        if (row == 3){
            self.DriveTypePredicate = [NSPredicate predicateWithFormat:@"CarDriveType CONTAINS %@", @"FWD"];
        }
        if (row == 4){
            self.DriveTypePredicate = [NSPredicate predicateWithFormat:@"CarDriveType CONTAINS %@", @"RWD"];
        }
        self.driveTypePredicateArray = [self.initialModelArray filteredArrayUsingPredicate:self.DriveTypePredicate];
        NSLog(@"drivetypepredicatearray: %lu", (unsigned long)self.driveTypePredicateArray.count);
    }
    if (self.currentSpecArray == self.horsepowerData)
    {
        [self.btnOutlet5 setTitle:[self.currentSpecArray objectAtIndex:row] forState:UIControlStateNormal];
        if (row == 0){
            self.HorsepowerPredicate = [NSPredicate predicateWithFormat:@"CarHorsepower.length > 0"];
        }
        if (row == 1){
            self.HorsepowerPredicate = [NSPredicate predicateWithFormat:@"(CarHorsepowerHigh<=99 OR CarHorsepowerLow<=99) AND NOT (CarHorsepower CONTAINS %@)", @"N/A"];
        }
        if (row == 2){
            self.HorsepowerPredicate = [NSPredicate predicateWithFormat:@"((CarHorsepowerLow>=100 AND CarHorsepowerLow<=200) OR (CarHorsepowerHigh>=100 AND CarHorsepowerHigh<=200))"];
        }
        if (row == 3){
            self.HorsepowerPredicate = [NSPredicate predicateWithFormat:@"((CarHorsepowerLow>=201 AND CarHorsepowerLow<=300) OR (CarHorsepowerHigh>=201 AND CarHorsepowerHigh<=300))"];
        }
        if (row == 4){
            self.HorsepowerPredicate = [NSPredicate predicateWithFormat:@"((CarHorsepowerLow>=301 AND CarHorsepowerLow<=400) OR (CarHorsepowerHigh>=301 AND CarHorsepowerHigh<=400))"];
        }
        if (row == 5){
            self.HorsepowerPredicate = [NSPredicate predicateWithFormat:@"((CarHorsepowerLow>=401 AND CarHorsepowerLow<=500) OR (CarHorsepowerHigh>=401 AND CarHorsepowerHigh<=500))"];
        }
        if (row == 6){
            self.HorsepowerPredicate = [NSPredicate predicateWithFormat:@"((CarHorsepowerLow>=501 AND CarHorsepowerLow<=600) OR (CarHorsepowerHigh>=501 AND CarHorsepowerHigh<=600))"];
        }
        if (row == 7){
            self.HorsepowerPredicate = [NSPredicate predicateWithFormat:@"((CarHorsepowerLow>=601 AND CarHorsepowerLow<=700) OR (CarHorsepowerHigh>=601 AND CarHorsepowerHigh<=700))"];
        }
        if (row == 8){
            self.HorsepowerPredicate = [NSPredicate predicateWithFormat:@"(CarHorsepowerLow>=701 OR CarHorsepowerHigh>=701)"];
        }
        self.horsepowerPredicateArray = [self.initialModelArray filteredArrayUsingPredicate:self.HorsepowerPredicate];
        NSLog(@"horsepowerprediatearray: %lu", (unsigned long)self.horsepowerPredicateArray.count);
    }
    if (self.currentSpecArray == self.zeroToSixtyData)
    {
        [self.btnOutlet6 setTitle:[self.currentSpecArray objectAtIndex:row] forState:UIControlStateNormal];
        if (row == 0){
            self.ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"CarZeroToSixty.length > 0"];
        }
        if (row == 1){
            self.ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"(CarZeroToSixtyLow<=3 Or CarZeroToSixtyHigh<3) AND NOT (CarZeroToSixty CONTAINS %@)", @"N/A"];
        }
        if (row == 2){
            self.ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=3.1 AND CarZeroToSixtyLow<=4) OR (CarZeroToSixtyHigh>=3.1 AND CarZeroToSixtyHigh<=4))"];
        }
        if (row == 3){
            self.ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=4.1 AND CarZeroToSixtyLow<=5) OR (CarZeroToSixtyHigh>=4.1 AND CarZeroToSixtyHigh<=5))"];
        }
        if (row == 4){
            self.ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=5.1 AND CarZeroToSixtyLow<=5.5) OR (CarZeroToSixtyHigh>=5.1 AND CarZeroToSixtyHigh<=5.5))"];
        }
        if (row == 5){
            self.ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=5.6 AND CarZeroToSixtyLow<=6) OR (CarZeroToSixtyHigh>=5.6 AND CarZeroToSixtyHigh<=6))"];
        }
        if (row == 6){
            self.ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=6.1 AND CarZeroToSixtyLow<=6.5) OR (CarZeroToSixtyHigh>=6.1 AND CarZeroToSixtyHigh<=6.5))"];
        }
        if (row == 7){
            self.ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=6.6 AND CarZeroToSixtyLow<=7.0) OR (CarZeroToSixtyHigh>=6.6 AND CarZeroToSixtyHigh<=7.0))"];
        }
        if (row == 8){
            self.ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=7.1 AND CarZeroToSixtyLow<=8.0) OR (CarZeroToSixtyHigh>=7.1 AND CarZeroToSixtyHigh<=8.0))"];
        }
        if (row == 9){
            self.ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=8.1 AND CarZeroToSixtyLow<=9.0) OR (CarZeroToSixtyHigh>=8.1 AND CarZeroToSixtyHigh<=9.0))"];
        }
        if (row == 10){
            self.ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=9.1 AND CarZeroToSixtyLow<=10.0) OR (CarZeroToSixtyHigh>=9.1 AND CarZeroToSixtyHigh<=10.0))"];
        }
        if (row == 11){
            self.ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"(CarZeroToSixtyLow>=10.1 Or CarZeroToSixtyHigh>=10.1)"];
        }
        self.zeroToSixtyPredicateArray = [self.initialModelArray filteredArrayUsingPredicate:self.ZeroToSixtyPredicate];
        NSLog(@"zerotosixtypredicatearray: %lu", (unsigned long)self.zeroToSixtyPredicateArray.count);
    }
    if (self.currentSpecArray == self.fuelEconomyData)
    {
        [self.btnOutlet7 setTitle:[self.currentSpecArray objectAtIndex:row] forState:UIControlStateNormal];
        if (row == 0){
            self.FEPredicate = [NSPredicate predicateWithFormat:@"CarFuelEconomy.length > 0"];
        }
        if (row == 1){
            self.FEPredicate = [NSPredicate predicateWithFormat:@"(CarFuelEconomyLow<=10 Or CarFuelEconomyHigh<=10) AND NOT (CarFuelEconomy CONTAINS %@)", @"N/A"];
        }
        if (row == 2){
            self.FEPredicate = [NSPredicate predicateWithFormat:@"((CarFuelEconomyLow>=11 AND CarFuelEconomyLow<=20) OR (CarFuelEconomyHigh>=11 AND CarFuelEconomyHigh<=20))"];
        }
        if (row == 3){
            self.FEPredicate = [NSPredicate predicateWithFormat:@"((CarFuelEconomyLow>=21 AND CarFuelEconomyLow<=30) OR (CarFuelEconomyHigh>=21 AND CarFuelEconomyHigh<=30))"];
        }
        if (row == 4){
            self.FEPredicate = [NSPredicate predicateWithFormat:@"((CarFuelEconomyLow>=31 AND CarFuelEconomyLow<=40) OR (CarFuelEconomyHigh>=31 AND CarFuelEconomyHigh<=40))"];
        }
        if (row == 5){
            self.FEPredicate = [NSPredicate predicateWithFormat:@"((CarFuelEconomyLow>=41 AND CarFuelEconomyLow<=50) OR (CarFuelEconomyHigh>=41 AND CarFuelEconomyHigh<=50))"];
        }
        if (row == 6){
            self.FEPredicate = [NSPredicate predicateWithFormat:@"(CarFuelEconomyLow>=51 OR CarFuelEconomyHigh>=51)"];
        }
        self.fuelEconomyPredicateArray = [self.initialModelArray filteredArrayUsingPredicate:self.FEPredicate];
        NSLog(@"fueleconomypredicatearray: %lu", (unsigned long)self.fuelEconomyPredicateArray.count);

    }
    if (self.currentSpecArray == self.makeArray)
    {
        [self.btnOutlet8 setTitle:[self.currentSpecArray objectAtIndex:row] forState:UIControlStateNormal];
        self.MakePredicate = [NSPredicate predicateWithFormat:@"CarMake == %@", [self.makeArray objectAtIndex:row]];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[self.makeArray objectAtIndex:row] forKey:@"currentMake"];
        [self setModels];
        [self.btnOutlet9 setTitle:@"Any" forState:UIControlStateNormal];
        self.ModelPredicate = nil;
    }
    if (self.currentSpecArray == self.ModelArray)
    {
        [self.btnOutlet9 setTitle:[self.currentSpecArray objectAtIndex:row] forState:UIControlStateNormal];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (row == 0)
            self.ModelPredicate = [NSPredicate predicateWithFormat:@"CarMake == %@", [defaults objectForKey:@"currentMake"]];
        else
            self.ModelPredicate = [NSPredicate predicateWithFormat:@"CarModel == %@", [self.ModelArray objectAtIndex:row]];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.currentSpecArray.count;
}

- (void) setInitialModels;
{
    self.ModelArray = [[NSMutableArray alloc]init];
    NSArray * testArray = self.initialModelArray;
    for (int i = 0; i < testArray.count; i++)
    {
        Model *currentModel = [testArray objectAtIndex:i];
        NSString *cModel = currentModel.CarModel;
        [self.ModelArray addObject:cModel];
    }
    NSString * defaultrow = @"Any";
    [self.ModelArray insertObject:defaultrow atIndex:0];

}

- (void) setModels;
{
    self.ModelArray = [[NSMutableArray alloc]init];
    NSArray * testArray = [self.initialModelArray filteredArrayUsingPredicate:self.MakePredicate];
    for (int i = 0; i < testArray.count; i++)
    {
        Model *currentModel = [testArray objectAtIndex:i];
        NSString *cModel = currentModel.CarModel;
        [self.ModelArray addObject:cModel];
    }
    NSString * defaultrow = @"Any";
    [self.ModelArray insertObject:defaultrow atIndex:0];
}

- (IBAction)btnAction:(id)sender
{
    self.currentSpecArray = self.priceData;
    [self.picker reloadAllComponents];
    [self updatePickerLocation:self.btnOutlet];
    [self fadePickerIn];
}

- (IBAction)btnAction2:(id)sender
{
    self.currentSpecArray = self.engineData;
    [self.picker reloadAllComponents];
    [self updatePickerLocation:self.btnOutlet2];
    [self fadePickerIn];
}

- (IBAction)btnAction3:(id)sender
{
    self.currentSpecArray = self.transmissionData;
    [self.picker reloadAllComponents];
    [self updatePickerLocation:self.btnOutlet3];
    [self fadePickerIn];
}

- (IBAction)btnAction4:(id)sender
{
    self.currentSpecArray = self.driveTypeData;
    [self.picker reloadAllComponents];
    [self updatePickerLocation:self.btnOutlet4];
    [self fadePickerIn];
}

- (IBAction)btnAction5:(id)sender
{
    self.currentSpecArray = self.horsepowerData;
    [self.picker reloadAllComponents];
    [self updatePickerLocation:self.btnOutlet5];
    [self fadePickerIn];
}

- (IBAction)btnAction6:(id)sender
{
    self.currentSpecArray = self.zeroToSixtyData;
    [self.picker reloadAllComponents];
    [self updatePickerLocation:self.btnOutlet6];
    [self fadePickerIn];
}

- (IBAction)btnAction7:(id)sender
{
    self.currentSpecArray = self.fuelEconomyData;
    [self.picker reloadAllComponents];
    [self updatePickerLocation:self.btnOutlet7];
    [self fadePickerIn];
}

- (IBAction)btnAction8:(id)sender
{
    self.currentSpecArray = self.makeArray;
    [self.picker reloadAllComponents];
    [self updatePickerLocation:self.btnOutlet8];
    [self fadePickerIn];
}

- (IBAction)btnAction9:(id)sender
{
    self.currentSpecArray = self.ModelArray;
    [self.picker reloadAllComponents];
    [self updatePickerLocation:self.btnOutlet9];
    [self fadePickerIn];
}

- (void)updatePickerLocation:(UIButton *)btn
{
    int rowToSelect = 0;
    for (int i=0; i<self.currentSpecArray.count; i++)
    {
        if([[self.currentSpecArray objectAtIndex:i] isEqualToString:btn.titleLabel.text])
            rowToSelect = i;
    }
    
    [self.picker selectRow:rowToSelect inComponent:0 animated:NO];
}

- (void)doneBtnSelected:(id)sender
{
    [self fadePickerOut];
}

- (void)fadePickerOut
{
    [UIView animateWithDuration:.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         self.pickerViewPopup.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.pickerViewPopup.alpha=1;
                         [self.pickerViewPopup setHidden:YES];
                     }];
}

- (void)fadePickerIn
{
    [self.pickerViewPopup setHidden:NO];
    self.pickerViewPopup.alpha=0;
    [UIView animateWithDuration:.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^ {
                         self.pickerViewPopup.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                     }];
}


- (void) makeAppDelModelArray;
{
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    self.initialModelArray = [[NSMutableArray alloc]init];
    [self.initialModelArray addObjectsFromArray:appdel.modelArray];
    
    self.makeArray = [[NSMutableArray alloc]init];
    [self.makeArray addObjectsFromArray:appdel.makeimageArray];
    NSLog(@"makearray.count: %lu", (unsigned long)self.makeArray.count);
}

- (IBAction)UsePredicates
{
    if (self.PricePredicate == nil)
        self.PricePredicate = [NSPredicate predicateWithFormat:@"CarModel.length > 0"];
    if (self.EnginePredicate == nil)
        self.EnginePredicate = [NSPredicate predicateWithFormat:@"CarModel.length > 0"];
    if (self.TransmissionPredicate == nil)
        self.TransmissionPredicate = [NSPredicate predicateWithFormat:@"CarModel.length > 0"];
    if (self.DriveTypePredicate == nil)
        self.DriveTypePredicate = [NSPredicate predicateWithFormat:@"CarModel.length > 0"];
    if (self.HorsepowerPredicate == nil)
        self.HorsepowerPredicate = [NSPredicate predicateWithFormat:@"CarModel.length > 0"];
    if (self.ZeroToSixtyPredicate == nil)
        self.ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"CarModel.length > 0"];
    if (self.FEPredicate == nil)
        self.FEPredicate = [NSPredicate predicateWithFormat:@"CarModel.length > 0"];
    
    self.pricePredicateArray = [self.initialModelArray filteredArrayUsingPredicate:self.PricePredicate];
    self.enginePredicateArray = [self.pricePredicateArray filteredArrayUsingPredicate:self.EnginePredicate];
    self.transmissionPredicateArray = [self.enginePredicateArray filteredArrayUsingPredicate:self.TransmissionPredicate];
    self.driveTypePredicateArray = [self.transmissionPredicateArray filteredArrayUsingPredicate:self.DriveTypePredicate];
    self.horsepowerPredicateArray = [self.driveTypePredicateArray filteredArrayUsingPredicate:self.HorsepowerPredicate];
    self.zeroToSixtyPredicateArray = [self.horsepowerPredicateArray filteredArrayUsingPredicate:self.ZeroToSixtyPredicate];
    self.fuelEconomyPredicateArray = [self.zeroToSixtyPredicateArray filteredArrayUsingPredicate:self.FEPredicate];
    
    NSSortDescriptor * alphasort = [NSSortDescriptor sortDescriptorWithKey:@"CarModel" ascending:YES];
    self.fuelEconomyPredicateArray = [self.fuelEconomyPredicateArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphasort]];
    NSLog(@"finalarray: %lu", (unsigned long)self.fuelEconomyPredicateArray.count);
}

- (IBAction)UseModelPredicates
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (self.MakePredicate == nil)
    {
        self.ModelPredicate = [NSPredicate predicateWithFormat:@"CarPrice.length > 0"];
    }
    else if (self.ModelPredicate == nil)
    {
        self.ModelPredicate = [NSPredicate predicateWithFormat:@"CarMake == %@", [defaults objectForKey:@"currentMake"]];
    }
    self.finalModelArray = [self.initialModelArray filteredArrayUsingPredicate:self.ModelPredicate];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushModelView"])
    {
        NSArray * searcharray = self.fuelEconomyPredicateArray;
        [[segue destinationViewController] getsearcharray:searcharray];
    }
    if ([[segue identifier] isEqualToString:@"pushCarView"])
    {
        NSArray * searcharray = self.finalModelArray;
        [[segue destinationViewController] getsearcharray:searcharray];
    }
}

@end
