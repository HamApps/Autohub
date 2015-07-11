//
//  SearchViewController.m
//  Carhub
//
//  Created by Christopher Clark on 8/22/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "SearchViewController.h"
#import "Model.h"
#import "SearchModelController.h"
#import "Make.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize PriceData, Pricepicker, enginePicker, EngineData, EngineDisData, HorsepowerData, horsepowerPicker, DriveTypeData, driveTypePicker, ZeroToSixtyData, zeroToSixtyPicker, TransmissionData, transmissionPicker, specsArray, carArray, ModelArray, DriveTypeArray1, PriceArray1, EngineArray1, EngineDisArray1, HorsepowerArray1, ZerotoSixtyArray1, TransmissionArray1, ZeroToSixtyPredicate, PricePredicate, EnginePredicate, HorsepowerPredicate, TransmissionPredicate, DriveTypePredicate, finalArray, makejsonArray, AlphabeticalArray, makeimageArray, MakePicker, ModelPicker, MakePredicate, cModel, testArray, ModelPredicate, finalModelArray, appdelmodeljsonArray, FEPredicate, FuelEconomyArray1, FuelEconomyData, FuelEconomyPicker;

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
    
    self.barButton.target = self.revealViewController;
    self.barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self makeAppDelModelArray];
    
    //Set Scroller for View
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 1615)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"Find Cars";
    
    // Do any additional setup after loading the view.
    
    //Contents of price picker
    NSArray * pricearray = [[NSArray alloc] initWithObjects:@"Any", @"$0-5,000",@"$5,000-10,000",@"$10,000-20,000",@"$20,000-30,000", @"$30,000-40,000", @"$40,000-50,000", @"$50,000-65,000", @"$65,000-80,000", @"$80,000-100,000", @"$100,000-150,000", @"$150,000-200,000", @"$200,000-500,000", @"$500,000+",  nil];
    self.PriceData = pricearray;
    
    //Contents of engine picker
    NSArray * enginearray = [[NSArray alloc] initWithObjects:@"Any", @"Electric/Hybrid", @"3 Cylinder", @"4 Cylinder", @"5 Cylinder", @"6 Cylinder", @"8 Cylinder", @"10 Cylinder", @"12 Cylinder", @"16 Cylinder", @"Rotary", nil];
    self.EngineData = enginearray;
    
    //Contents of engine displacement picker
    NSArray * enginedisarray = [[NSArray alloc] initWithObjects:@"Any", @"0-1.0L", @"1.1-2.0L", @"2.1-3.0L", @"3.1-4.5L", @"4.6- 6.0", @"6.1-8.0L", @"8.1L+", nil];
    self.EngineDisData = enginedisarray;
    
    //Contents of Transmission picker
    NSArray * transmissionarray = [[NSArray alloc] initWithObjects:@"Any", @"Automatic", @"Manual", @"CVT", nil];
    self.TransmissionData = transmissionarray;
    
    //Contents of Drive Type picker
    NSArray * drivetypearray = [[NSArray alloc] initWithObjects:@"Any", @"4WD", @"AWD", @"FWD", @"RWD", nil];
    self.DriveTypeData = drivetypearray;
    
    //Contents of Horsepower picker
    NSArray * horsepowerarray = [[NSArray alloc] initWithObjects:@"Any", @"0-99", @"100-200", @"201-300", @"301-400", @"401-500", @"501-600", @"601-700", @"700+", nil];
    self.HorsepowerData = horsepowerarray;
    
    //Contents of 0-60 picker
    NSArray * zerotosixtyarray = [[NSArray alloc] initWithObjects:@"Any", @"2-3.0 secs", @"3.1-4.0 secs", @"4.1-5.0 secs", @"5.1-5.5 secs", @"5.6-6.0 secs", @"6.1-6.5 secs", @"6.6-7.0 secs", @"7.1-8.0 secs", @"8.1-9.0 secs", @"9.1-10.0 secs", @"10.1+ secs", nil];
    self.ZeroToSixtyData = zerotosixtyarray;
    
    //Contents of FE picker
    NSArray * fueleconomyarray = [[NSArray alloc] initWithObjects:@"Any", @"0-10", @"11-20", @"21-30", @"31-40", @"41-50", @"51+", nil];
    self.FuelEconomyData = fueleconomyarray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if([pickerView isEqual:Pricepicker])
        return [PriceData count];
    if([pickerView isEqual:enginePicker])
        return [EngineData count];
    if([pickerView isEqual:transmissionPicker])
        return [TransmissionData count];
    if([pickerView isEqual:driveTypePicker])
        return [DriveTypeData count];
    if([pickerView isEqual:horsepowerPicker])
        return [HorsepowerData count];
    if([pickerView isEqual:zeroToSixtyPicker])
        return [ZeroToSixtyData count];
    if([pickerView isEqual:FuelEconomyPicker])
        return [FuelEconomyData count];
    if([pickerView isEqual:MakePicker])
        return [makeimageArray count];
    if([pickerView isEqual:ModelPicker])
        return [ModelArray count];
    else
        return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view{
    if([pickerView isEqual:Pricepicker])
    {
        UILabel *label = (id)view;
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(1.0f, 1.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.text = [PriceData objectAtIndex:row];
        return label;
    }
    
    else if([pickerView isEqual:enginePicker])
    {
        UILabel *label = (id)view;
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(1.0f, 1.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.text = [EngineData objectAtIndex:row];
        return label;
    }
    
    else if([pickerView isEqual:transmissionPicker])
    {
        UILabel *label = (id)view;
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(1.0f, 1.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.text = [TransmissionData objectAtIndex:row];
        return label;
    }
    
    else if([pickerView isEqual:driveTypePicker])
    {
        UILabel *label = (id)view;
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(1.0f, 1.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.text = [DriveTypeData objectAtIndex:row];
        return label;
    }
    
    else if([pickerView isEqual:horsepowerPicker])
    {
        UILabel *label = (id)view;
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(1.0f, 1.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.text = [HorsepowerData objectAtIndex:row];
        return label;
    }
    
    else if([pickerView isEqual:zeroToSixtyPicker])
    {
        UILabel *label = (id)view;
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(1.0f, 1.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.text = [ZeroToSixtyData objectAtIndex:row];
        return label;
    }
    
    else if([pickerView isEqual:FuelEconomyPicker])
    {
        UILabel *label = (id)view;
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(1.0f, 1.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.text = [FuelEconomyData objectAtIndex:row];
        return label;
    }

    else if([pickerView isEqual:MakePicker])
    {
        UILabel *label = (id)view;
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(1.0f, 1.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.text = [makeimageArray objectAtIndex:row];
        return label;
    }
    
    else if([pickerView isEqual:ModelPicker])
    {
        UILabel *label = (id)view;
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(1.0f, 1.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.text = [ModelArray objectAtIndex:row];
        return label;
    }
    else
        return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if([pickerView isEqual:Pricepicker])
        return [PriceData objectAtIndex:row];
    else if([pickerView isEqual:enginePicker])
        return [EngineData objectAtIndex:row];
    else if([pickerView isEqual:transmissionPicker])
        return [TransmissionData objectAtIndex:row];
    else if([pickerView isEqual:driveTypePicker])
        return [DriveTypeData objectAtIndex:row];
    else if([pickerView isEqual:horsepowerPicker])
        return [HorsepowerData objectAtIndex:row];
    else if([pickerView isEqual:zeroToSixtyPicker])
        return [ZeroToSixtyData objectAtIndex:row];
    else if([pickerView isEqual:FuelEconomyPicker])
        return [FuelEconomyData objectAtIndex:row];
    else if([pickerView isEqual:MakePicker])
        return [makeimageArray objectAtIndex:row];
    else if([pickerView isEqual:ModelPicker])
        return [ModelArray objectAtIndex:row];
    else
        return 0;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if([pickerView isEqual:Pricepicker]){
        if (row == 0){
            PricePredicate = [NSPredicate predicateWithFormat:@"CarPrice.length > 0"];
            PriceArray1 = specsArray;
        }
        if (row == 1){
            PricePredicate = [NSPredicate predicateWithFormat:@"(CarPriceHigh<=5000 OR CarPriceLow<=5000) AND NOT (CarPrice CONTAINS %@)", @"N/A"];
            PriceArray1 = [specsArray filteredArrayUsingPredicate:PricePredicate];
        }
        if (row == 2){
            PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=5000 AND CarPriceHigh<=10000) OR (CarPriceLow>=5000 AND CarPriceLow<=10000))"];
            PriceArray1 = [specsArray filteredArrayUsingPredicate:PricePredicate];
        }
        if (row == 3){
            PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=10000 AND CarPriceHigh<=20000) OR (CarPriceLow>=10000 AND CarPriceLow<=20000))"];
            PriceArray1 = [specsArray filteredArrayUsingPredicate: PricePredicate];
        }
        if (row == 4){
            PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=20000 AND CarPriceHigh<=30000) OR (CarPriceLow>=20000 AND CarPriceLow<=30000))"];
            PriceArray1 = [specsArray filteredArrayUsingPredicate:PricePredicate];
        }
        if (row == 5){
            PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=30000 AND CarPriceHigh<=40000) OR (CarPriceLow>=30000 AND CarPriceLow<=40000))"];
            PriceArray1 = [specsArray filteredArrayUsingPredicate:PricePredicate];
        }
        if (row == 6){
            PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=40000 AND CarPriceHigh<=50000) OR (CarPriceLow>=40000 AND CarPriceLow<=50000))"];
            PriceArray1 = [specsArray filteredArrayUsingPredicate:PricePredicate];
        }
        if (row == 7){
            PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=50000 AND CarPriceHigh<=65000) OR (CarPriceLow>=50000 AND CarPriceLow<=65000))"];
            PriceArray1 = [specsArray filteredArrayUsingPredicate:PricePredicate];
        }
        if (row == 8){
            PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=65000 AND CarPriceHigh<=80000) OR (CarPriceLow>=65000 AND CarPriceLow<=80000))"];
            PriceArray1 = [specsArray filteredArrayUsingPredicate:PricePredicate];
        }
        if (row == 9){
            PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=80000 AND CarPriceHigh<=100000) OR (CarPriceLow>=80000 AND CarPriceLow<=100000))"];
            PriceArray1 = [specsArray filteredArrayUsingPredicate:PricePredicate];
        }
        if (row == 10){
            PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=100000 AND CarPriceHigh<=150000) OR (CarPriceLow>=100000 AND CarPriceLow<=150000))"];
            PriceArray1 = [specsArray filteredArrayUsingPredicate:PricePredicate];
        }
        if (row == 11){
            PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=150000 AND CarPriceHigh<=200000) OR (CarPriceLow>=150000 AND CarPriceLow<=200000))"];
            PriceArray1 = [specsArray filteredArrayUsingPredicate:PricePredicate];
        }
        if (row == 12){
            PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=200000 AND CarPriceHigh<=500000) OR (CarPriceLow>=200000 AND CarPriceLow<=500000))"];
            PriceArray1 = [specsArray filteredArrayUsingPredicate:PricePredicate];
        }
        if (row == 13){
            PricePredicate = [NSPredicate predicateWithFormat:@"(CarPriceHigh>=500000 OR CarPriceLow>=500000)"];
            PriceArray1 = [specsArray filteredArrayUsingPredicate:PricePredicate];
        }
    }
    
    if([pickerView isEqual:enginePicker]){
        if (row == 0){
            EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine.length > 0"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
        }
        if (row == 1){
            EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine CONTAINS %@", @"Electric"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
        }
        if (row == 2){
            EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine CONTAINS %@", @"l3"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
        }
        if (row == 3){
            EnginePredicate = [NSPredicate predicateWithFormat:@"(CarEngine CONTAINS %@) OR (CarEngine CONTAINS %@)", @"Flat-4", @"l4"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
        }
        if (row == 4){
            EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine CONTAINS %@", @"l5"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
        }
        if (row == 5){
            EnginePredicate = [NSPredicate predicateWithFormat:@"(CarEngine CONTAINS %@) OR (CarEngine CONTAINS %@) OR (CarEngine CONTAINS %@)", @"Flat-6", @"V6", @"l6"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
        }
        if (row == 6){
            EnginePredicate = [NSPredicate predicateWithFormat:@"(CarEngine CONTAINS %@) OR (CarEngine CONTAINS %@)", @"V8", @"l8"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
        }
        if (row == 7){
            EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine CONTAINS %@", @"V10"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
        }
        if (row == 8){
            EnginePredicate = [NSPredicate predicateWithFormat:@"(CarEngine CONTAINS %@) OR (CarEngine CONTAINS %@) OR (CarEngine CONTAINS %@)", @"F12", @"V12", @"W12"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
        }
        if (row == 9){
            EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine CONTAINS %@", @"W16"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
        }
        if (row == 10){
            EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine CONTAINS %@", @"Rotary"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
        }
    }

    if([pickerView isEqual:transmissionPicker]){
        if (row == 0){
            TransmissionPredicate = [NSPredicate predicateWithFormat:@"CarTransmission.length > 0"];
            TransmissionArray1 = [EngineArray1 filteredArrayUsingPredicate:TransmissionPredicate];
        }
        if (row == 1){
            TransmissionPredicate = [NSPredicate predicateWithFormat:@"CarTransmission CONTAINS %@", @"Automatic"];
            TransmissionArray1 = [EngineArray1 filteredArrayUsingPredicate:TransmissionPredicate];
        }
        if (row == 2){
            TransmissionPredicate = [NSPredicate predicateWithFormat:@"CarTransmission CONTAINS %@", @"Manual"];
            TransmissionArray1 = [EngineArray1 filteredArrayUsingPredicate:TransmissionPredicate];
        }
        if (row == 3){
            TransmissionPredicate = [NSPredicate predicateWithFormat:@"CarTransmission CONTAINS %@", @"CVT"];
            TransmissionArray1 = [EngineArray1 filteredArrayUsingPredicate:TransmissionPredicate];
        }
    }
    
    if([pickerView isEqual:driveTypePicker]){
        if (row == 0){
            DriveTypePredicate = [NSPredicate predicateWithFormat:@"CarDriveType.length > 0"];
            DriveTypeArray1 = [TransmissionArray1 filteredArrayUsingPredicate:DriveTypePredicate];
        }
        if (row == 1){
            DriveTypePredicate = [NSPredicate predicateWithFormat:@"CarDriveType CONTAINS %@", @"4WD"];
            DriveTypeArray1 = [TransmissionArray1 filteredArrayUsingPredicate:DriveTypePredicate];
        }
        if (row == 2){
            DriveTypePredicate = [NSPredicate predicateWithFormat:@"CarDriveType CONTAINS %@",@"AWD"];
            DriveTypeArray1 = [TransmissionArray1 filteredArrayUsingPredicate:DriveTypePredicate];
        }
        if (row == 3){
            DriveTypePredicate = [NSPredicate predicateWithFormat:@"CarDriveType CONTAINS %@", @"FWD"];
            DriveTypeArray1 = [TransmissionArray1 filteredArrayUsingPredicate:DriveTypePredicate];
        }
        if (row == 4){
            DriveTypePredicate = [NSPredicate predicateWithFormat:@"CarDriveType CONTAINS %@", @"RWD"];
            DriveTypeArray1 = [TransmissionArray1 filteredArrayUsingPredicate:DriveTypePredicate];
        }
    }
    
    if([pickerView isEqual:horsepowerPicker]){
        if (row == 0){
            HorsepowerPredicate = [NSPredicate predicateWithFormat:@"CarHorsepower.length > 0"];
            HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
        }
        if (row == 1){
            HorsepowerPredicate = [NSPredicate predicateWithFormat:@"(CarHorsepowerHigh<=99 OR CarHorsepowerLow<=99) AND NOT (CarHorsepower CONTAINS %@)", @"N/A"];
            HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
        }
        if (row == 2){
            HorsepowerPredicate = [NSPredicate predicateWithFormat:@"((CarHorsepowerLow>=100 AND CarHorsepowerLow<=200) OR (CarHorsepowerHigh>=100 AND CarHorsepowerHigh<=200))"];
            HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
        }
        if (row == 3){
            HorsepowerPredicate = [NSPredicate predicateWithFormat:@"((CarHorsepowerLow>=201 AND CarHorsepowerLow<=300) OR (CarHorsepowerHigh>=201 AND CarHorsepowerHigh<=300))"];
            HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
        }
        if (row == 4){
            HorsepowerPredicate = [NSPredicate predicateWithFormat:@"((CarHorsepowerLow>=301 AND CarHorsepowerLow<=400) OR (CarHorsepowerHigh>=301 AND CarHorsepowerHigh<=400))"];
            HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
        }
        if (row == 5){
            HorsepowerPredicate = [NSPredicate predicateWithFormat:@"((CarHorsepowerLow>=401 AND CarHorsepowerLow<=500) OR (CarHorsepowerHigh>=401 AND CarHorsepowerHigh<=500))"];
            HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
        }
        if (row == 6){
            HorsepowerPredicate = [NSPredicate predicateWithFormat:@"((CarHorsepowerLow>=501 AND CarHorsepowerLow<=600) OR (CarHorsepowerHigh>=501 AND CarHorsepowerHigh<=600))"];
            HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
        }
        if (row == 7){
            HorsepowerPredicate = [NSPredicate predicateWithFormat:@"((CarHorsepowerLow>=601 AND CarHorsepowerLow<=700) OR (CarHorsepowerHigh>=601 AND CarHorsepowerHigh<=700))"];
            HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
        }
        if (row == 8){
            HorsepowerPredicate = [NSPredicate predicateWithFormat:@"(CarHorsepowerLow>=701 OR CarHorsepowerHigh>=701)"];
            HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
        }
    }

    if([pickerView isEqual:zeroToSixtyPicker]){
        if (row == 0){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"CarZeroToSixty.length > 0"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
        }
        if (row == 1){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"(CarZeroToSixtyLow<=3 Or CarZeroToSixtyHigh<3) AND NOT (CarZeroToSixty CONTAINS %@)", @"N/A"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
        }
        if (row == 2){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=3.1 AND CarZeroToSixtyLow<=4) OR (CarZeroToSixtyHigh>=3.1 AND CarZeroToSixtyHigh<=4))"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
        }
        if (row == 3){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=4.1 AND CarZeroToSixtyLow<=5) OR (CarZeroToSixtyHigh>=4.1 AND CarZeroToSixtyHigh<=5))"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
        }
        if (row == 4){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=5.1 AND CarZeroToSixtyLow<=5.5) OR (CarZeroToSixtyHigh>=5.1 AND CarZeroToSixtyHigh<=5.5))"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
        }
        if (row == 5){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=5.6 AND CarZeroToSixtyLow<=6) OR (CarZeroToSixtyHigh>=5.6 AND CarZeroToSixtyHigh<=6))"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
        }
        if (row == 6){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=6.1 AND CarZeroToSixtyLow<=6.5) OR (CarZeroToSixtyHigh>=6.1 AND CarZeroToSixtyHigh<=6.5))"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
        }
        if (row == 7){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=6.6 AND CarZeroToSixtyLow<=7.0) OR (CarZeroToSixtyHigh>=6.6 AND CarZeroToSixtyHigh<=7.0))"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
        }
        if (row == 8){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=7.1 AND CarZeroToSixtyLow<=8.0) OR (CarZeroToSixtyHigh>=7.1 AND CarZeroToSixtyHigh<=8.0))"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
        }
        if (row == 9){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=8.1 AND CarZeroToSixtyLow<=9.0) OR (CarZeroToSixtyHigh>=8.1 AND CarZeroToSixtyHigh<=9.0))"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
        }
        if (row == 10){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=9.1 AND CarZeroToSixtyLow<=10.0) OR (CarZeroToSixtyHigh>=9.1 AND CarZeroToSixtyHigh<=10.0))"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
        }
        if (row == 11){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"(CarZeroToSixtyLow>=10.1 Or CarZeroToSixtyHigh>=10.1)"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
        }
    }
    
    if([pickerView isEqual:FuelEconomyPicker]){
        if (row == 0){
            FEPredicate = [NSPredicate predicateWithFormat:@"CarFuelEconomy.length > 0"];
            FuelEconomyArray1 = [ZerotoSixtyArray1 filteredArrayUsingPredicate:FEPredicate];
        }
        if (row == 1){
            FEPredicate = [NSPredicate predicateWithFormat:@"(CarFuelEconomyLow<=10 Or CarFuelEconomyHigh<=10) AND NOT (CarFuelEconomy CONTAINS %@)", @"N/A"];
            FuelEconomyArray1 = [ZerotoSixtyArray1 filteredArrayUsingPredicate:FEPredicate];
        }
        if (row == 2){
            FEPredicate = [NSPredicate predicateWithFormat:@"((CarFuelEconomyLow>=11 AND CarFuelEconomyLow<=20) OR (CarFuelEconomyHigh>=11 AND CarFuelEconomyHigh<=20))"];
            FuelEconomyArray1 = [ZerotoSixtyArray1 filteredArrayUsingPredicate:FEPredicate];
        }
        if (row == 3){
            FEPredicate = [NSPredicate predicateWithFormat:@"((CarFuelEconomyLow>=21 AND CarFuelEconomyLow<=30) OR (CarFuelEconomyHigh>=21 AND CarFuelEconomyHigh<=30))"];
            FuelEconomyArray1 = [ZerotoSixtyArray1 filteredArrayUsingPredicate:FEPredicate];
        }
        if (row == 4){
            FEPredicate = [NSPredicate predicateWithFormat:@"((CarFuelEconomyLow>=31 AND CarFuelEconomyLow<=40) OR (CarFuelEconomyHigh>=31 AND CarFuelEconomyHigh<=40))"];
            FuelEconomyArray1 = [ZerotoSixtyArray1 filteredArrayUsingPredicate:FEPredicate];
        }
        if (row == 5){
            FEPredicate = [NSPredicate predicateWithFormat:@"((CarFuelEconomyLow>=41 AND CarFuelEconomyLow<=50) OR (CarFuelEconomyHigh>=41 AND CarFuelEconomyHigh<=50))"];
            FuelEconomyArray1 = [ZerotoSixtyArray1 filteredArrayUsingPredicate:FEPredicate];
        }
        if (row == 6){
            FEPredicate = [NSPredicate predicateWithFormat:@"(CarFuelEconomyLow>=51 OR CarFuelEconomyHigh>=51)"];
            FuelEconomyArray1 = [ZerotoSixtyArray1 filteredArrayUsingPredicate:FEPredicate];
        }
    }
    
    if([pickerView isEqual:MakePicker]){
        MakePredicate = [NSPredicate predicateWithFormat:@"CarMake == %@", [makeimageArray objectAtIndex:row]];
        [self setModels];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[makeimageArray objectAtIndex:row] forKey:@"currentMake"];
        self.ModelPredicate = nil;
        [self.ModelPicker reloadAllComponents];
        [self.ModelPicker selectRow:0 inComponent:0 animated:YES];
        ModelPredicate = [NSPredicate predicateWithFormat:@"CarMake == %@", [makeimageArray objectAtIndex:row]];
    }
    
    if([pickerView isEqual:ModelPicker]){
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if (row == 0)
            ModelPredicate = [NSPredicate predicateWithFormat:@"CarMake == %@", [defaults objectForKey:@"currentMake"]];
        else
            ModelPredicate = [NSPredicate predicateWithFormat:@"CarModel == %@", [ModelArray objectAtIndex:row]];
    }
}

- (void) makeAppDelModelArray;
{
    specsArray = [[NSMutableArray alloc]init];
    appdelmodeljsonArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [specsArray addObjectsFromArray:appdel.modelArray];
    makeimageArray = [[NSMutableArray alloc]init];
    [makeimageArray addObjectsFromArray:appdel.makeimageArray];
}

- (void) setModels;
{
    ModelArray = [[NSMutableArray alloc]init];
    testArray = [specsArray filteredArrayUsingPredicate:MakePredicate];
    for (int i = 0; i < testArray.count; i++)
    {
        Model *currentModel = [testArray objectAtIndex:i];
        cModel = currentModel.CarModel;
        [ModelArray addObject:cModel];
    }
    NSString * defaultrow = @"Select a Model";
    [ModelArray insertObject:defaultrow atIndex:0];
}

- (IBAction)UsePredicates {
    if (PricePredicate == nil)
        PricePredicate = [NSPredicate predicateWithFormat:@"CarPrice.length > 0"];
    if (EnginePredicate == nil)
        EnginePredicate = [NSPredicate predicateWithFormat:@"CarPrice.length > 0"];
    if (TransmissionPredicate == nil)
        TransmissionPredicate = [NSPredicate predicateWithFormat:@"CarPrice.length > 0"];
    if (DriveTypePredicate == nil)
        DriveTypePredicate = [NSPredicate predicateWithFormat:@"CarPrice.length > 0"];
    if (HorsepowerPredicate == nil)
        HorsepowerPredicate = [NSPredicate predicateWithFormat:@"CarPrice.length > 0"];
    if (ZeroToSixtyPredicate == nil)
        ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"CarPrice.length > 0"];
    if (FEPredicate == nil)
        FEPredicate = [NSPredicate predicateWithFormat:@"CarPrice.length > 0"];
    
    PriceArray1 = [specsArray filteredArrayUsingPredicate:PricePredicate];
    EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
    TransmissionArray1 = [EngineArray1 filteredArrayUsingPredicate:TransmissionPredicate];
    DriveTypeArray1 = [TransmissionArray1 filteredArrayUsingPredicate:DriveTypePredicate];
    HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
    ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
    FuelEconomyArray1 = [ZerotoSixtyArray1 filteredArrayUsingPredicate:FEPredicate];

    NSSortDescriptor * alphasort = [NSSortDescriptor sortDescriptorWithKey:@"CarModel" ascending:YES];
    FuelEconomyArray1 = [FuelEconomyArray1 sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphasort]];
}

- (IBAction)UseModelPredicates {
    if (ModelPredicate == nil)
    {
     ModelPredicate = [NSPredicate predicateWithFormat:@"CarPrice.length > 10000000000"];
    }
    finalModelArray = [specsArray filteredArrayUsingPredicate:ModelPredicate];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushModelView"])
    {
        NSArray * searcharray = FuelEconomyArray1;
        [[segue destinationViewController] getsearcharray:searcharray];
    }
    if ([[segue identifier] isEqualToString:@"pushCarView"])
    {
        NSArray * searcharray = finalModelArray;
        [[segue destinationViewController] getsearcharray:searcharray];
    }
}

@end
