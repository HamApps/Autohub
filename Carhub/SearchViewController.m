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

#define getDataURL @"http://pl0x.net/CarHubJSON2.php"
#define getMakeDataURL @"http://pl0x.net/CarMakesJSON.php"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize PriceData, Pricepicker, OutputLabel, enginePicker, EngineData, EngineDisData, enginedisPicker, HorsepowerData, horsepowerPicker, DriveTypeData, driveTypePicker, ZeroToSixtyData, zeroToSixtyPicker, TransmissionData, transmissionPicker, jsonArray, carArray, ModelArray, DriveTypeArray1, PriceArray1, EngineArray1, EngineDisArray1, HorsepowerArray1, ZerotoSixtyArray1, TransmissionArray1, ZeroToSixtyPredicate, PricePredicate, EnginePredicate, HorsepowerPredicate, TransmissionPredicate, DriveTypePredicate, finalArray, makejsonArray, AlphabeticalArray, makeimageArray, MakePicker, ModelPicker, MakePredicate, cModel, testArray, ModelPredicate, finalModelArray, appdelmodeljsonArray;

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
    
    //[self retrieveData];
    [self makeAppDelModelArray];
    //[self retrieveMakeImageData];
    
    //Set Scroller for View
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 1450)];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"Metal Background.jpg"]];
    
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

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if([pickerView isEqual:Pricepicker])
    {
        return [PriceData count];
    }
    else if([pickerView isEqual:enginePicker])
    {
        return [EngineData count];
    }
    else if([pickerView isEqual:enginedisPicker])
    {
        return [EngineDisData count];
    }
    if([pickerView isEqual:transmissionPicker])
    {
        return [TransmissionData count];
    }

    if([pickerView isEqual:driveTypePicker])
    {
        return [DriveTypeData count];
    }

    if([pickerView isEqual:horsepowerPicker])
    {
        return [HorsepowerData count];
    }

    if([pickerView isEqual:zeroToSixtyPicker])
    {
        return [ZeroToSixtyData count];
    }
    
    if([pickerView isEqual:MakePicker])
    {
        return [makeimageArray count];
    }

    if([pickerView isEqual:ModelPicker])
    {
        return [ModelArray count];
    }
    
    else{
        return 0;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view{
    if([pickerView isEqual:Pricepicker])
    {
        UILabel *label = (id)view;
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(1.0f, 1.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        }
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
        label.font = [UIFont systemFontOfSize:16];
        
        label.text = [ZeroToSixtyData objectAtIndex:row];
        
        return label;
    }
    
    else if([pickerView isEqual:MakePicker])
    {
        UILabel *label = (id)view;
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(1.0f, 1.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        }
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
        label.font = [UIFont systemFontOfSize:16];
        
        label.text = [ModelArray objectAtIndex:row];
        
        return label;
    }

        
    else{
        return 0;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if([pickerView isEqual:Pricepicker])
    {
        return [PriceData objectAtIndex:row];
    }
    else if([pickerView isEqual:enginePicker])
    {
        return [EngineData objectAtIndex:row];
    }
    else if([pickerView isEqual:enginedisPicker])
    {
        return [EngineDisData objectAtIndex:row];
    }
    else if([pickerView isEqual:transmissionPicker])
    {
        return [TransmissionData objectAtIndex:row];
    }

    else if([pickerView isEqual:driveTypePicker])
    {
        return [DriveTypeData objectAtIndex:row];
    }

    else if([pickerView isEqual:horsepowerPicker])
    {
        return [HorsepowerData objectAtIndex:row];
    }

    else if([pickerView isEqual:zeroToSixtyPicker])
    {
        return [ZeroToSixtyData objectAtIndex:row];
    }
    
    else if([pickerView isEqual:MakePicker])
    {
        return [makeimageArray objectAtIndex:row];
    }
    
    else if([pickerView isEqual:ModelPicker])
    {
        return [ModelArray objectAtIndex:row];
    }


    else{
        return 0;
    }
//return [PriceData objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //Price Pickerview Actions Start
    if([pickerView isEqual:Pricepicker]){
        if (component == 0)
            if (row == 0){
                PricePredicate = [NSPredicate predicateWithFormat:@"Price.length > 0"];
                PriceArray1 = [jsonArray filteredArrayUsingPredicate:PricePredicate];
                NSLog(@"pricedata%@", PricePredicate);
                NSLog(@"pricedata%lu", (unsigned long)PriceArray1.count);
            }
            if (row == 1){
                PricePredicate = [NSPredicate predicateWithFormat:@"(Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@)", @" 2,000", @" 3,000", @" 4,000", @" 5,000"];
                PriceArray1 = [jsonArray filteredArrayUsingPredicate:PricePredicate];
                NSLog(@"pricedata%@", PricePredicate);
                NSLog(@"pricedata%lu", (unsigned long)PriceArray1.count);
                //[self UsePredicates];
            }
            if (row == 2){
                PricePredicate = [NSPredicate predicateWithFormat:@"(Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@)", @" 5,000", @" 6,000", @" 7,000", @" 9,000", @" 10,000"];
                PriceArray1 = [jsonArray filteredArrayUsingPredicate:PricePredicate];
                NSLog(@"pricedata%@", PriceArray1);
                NSLog(@"pricedata%lu", (unsigned long)PriceArray1.count);
            }
            if (row == 3){
                PricePredicate = [NSPredicate predicateWithFormat:@"(Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@)", @" 10,000", @" 11,000", @" 12,000", @" 13,000", @" 14,000", @"16,000", @" 17,000", @" 18,000", @"19,000", @" 20,000"];
                PriceArray1 = [jsonArray filteredArrayUsingPredicate: PricePredicate];
                NSLog(@"pricedata%@", PriceArray1);
                NSLog(@"pricedata%lu", (unsigned long)PriceArray1.count);
            }
        if (row == 4){
            PricePredicate = [NSPredicate predicateWithFormat:@"(Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@)", @" 20,000", @"21,000", @"22,000", @"23,000", @" 24,000", @" 25,000", @"26,000", @"27,000", @" 28,000", @" 29,000", @" 30,000"];
            PriceArray1 = [jsonArray filteredArrayUsingPredicate:PricePredicate];
            NSLog(@"pricedata%@", PricePredicate);
            NSLog(@"pricedata%lu", (unsigned long)PriceArray1.count);
        }
        if (row == 5){
            PricePredicate = [NSPredicate predicateWithFormat:@"(Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@)", @" 30,000", @"31,000", @"32,000", @" 33,000", @"34,000", @" 35,000", @" 36,000", @"37,000", @" 38,000", @" 39,000", @" 40,000"];
            PriceArray1 = [jsonArray filteredArrayUsingPredicate:PricePredicate];
            NSLog(@"pricedata%@", PriceArray1);
            NSLog(@"pricedata%lu", (unsigned long)PriceArray1.count);
        }
        if (row == 6){
            PricePredicate = [NSPredicate predicateWithFormat:@"(Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@)", @" 40,000", @"41,000", @"42,000", @"43,000", @"44,000", @" 45,000", @"46,000", @"47,000", @"48,000", @"49,000", @" 50,000"];
            PriceArray1 = [jsonArray filteredArrayUsingPredicate:PricePredicate];
            NSLog(@"pricedata%@", PriceArray1);
            NSLog(@"pricedata%lu", (unsigned long)PriceArray1.count);
        }
        if (row == 7){
            PricePredicate = [NSPredicate predicateWithFormat:@"(Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@)", @" 50,000", @" 51,000", @"52,000", @"53,000", @" 54,000", @" 55,000", @"56,000", @"57,000", @"58,000", @"59,000", @" 60,000", @" 61,000", @" 62,000", @" 63,000", @"64,000", @" 65,000"];
            PriceArray1 = [jsonArray filteredArrayUsingPredicate:PricePredicate];
            NSLog(@"pricedata%@", PriceArray1);
            NSLog(@"pricedata%lu", (unsigned long)PriceArray1.count);
        }
        if (row == 8){
            PricePredicate = [NSPredicate predicateWithFormat:@"(Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@)", @" 65,000", @" 67,000", @"68,000", @"69,000", @"70,000", @"71,000", @"72,000", @"73,000", @"74,000", @" 75,000", @"77,000", @" 78,000", @"79,000", @" 80,000"];
            PriceArray1 = [jsonArray filteredArrayUsingPredicate:PricePredicate];
            NSLog(@"pricedata%@", PriceArray1);
            NSLog(@"pricedata%lu", (unsigned long)PriceArray1.count);
        }
        if (row == 9){
            PricePredicate = [NSPredicate predicateWithFormat:@"(Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@)", @" 80,000", @" 83,000", @" 84,000", @" 85,000", @" 86,000", @"87,000", @"90,000", @"92,000", @"93,000", @"94,000", @"96,000", @"97,000", @" 98,000", @"99,000", @"100,000"];
            PriceArray1 = [jsonArray filteredArrayUsingPredicate:PricePredicate];
            NSLog(@"pricedata%@", PriceArray1);
            NSLog(@"pricedata%lu", (unsigned long)PriceArray1.count);
        }
        if (row == 10){
            PricePredicate = [NSPredicate predicateWithFormat:@"(Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@)", @"100,000", @"101,000", @"102,000", @"103,000", @"104,000", @"105,000", @"106,000", @"107,000", @"108,000", @"109,000", @"110,000", @"111,000", @"112,000", @"113,000", @"114,000", @"115,000", @"116,000", @"117,000", @"118,000", @"119,000", @"120,000", @"121,000", @"122,000", @"123,000", @"124,000", @"125,000", @"126,000", @"127,000", @"128,000", @"129,000", @"130,000", @"131,000", @"132,000", @"133,000", @"134,000", @"135,000", @"136,000", @"137,000", @"138,000", @"139,000", @"140,000", @"141,000", @"142,000", @"143,000", @"144,000", @"145,000", @"146,000", @"147,000", @"148,000", @"149,000", @"150,000"];
            PriceArray1 = [jsonArray filteredArrayUsingPredicate:PricePredicate];
            NSLog(@"pricedata%@", PriceArray1);
            NSLog(@"pricedata%lu", (unsigned long)PriceArray1.count);
        }
        if (row == 11){
            PricePredicate = [NSPredicate predicateWithFormat:@"(Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@)", @"150,000", @"151,000", @"152,000", @"153,000", @"154,000", @"155,000", @"156,000", @"157,000", @"158,000", @"159,000", @"160,000", @"161,000", @"162,000", @"163,000", @"164,000", @"165,000", @"166,000", @"167,000", @"168,000", @"169,000", @"170,000", @"171,000", @"172,000", @"173,000", @"174,000", @"175,000", @"176,000", @"177,000", @"178,000", @"179,000", @"180,000", @"181,000", @"182,000", @"183,000", @"184,000", @"185,000", @"186,000", @"187,000", @"188,000", @"189,000", @"190,000", @"191,000", @"192,000", @"193,000", @"194,000", @"195,000", @"196,000", @"197,000", @"198,000", @"199,000", @"200,000"];
            PriceArray1 = [jsonArray filteredArrayUsingPredicate:PricePredicate];
            NSLog(@"pricedata%@", PriceArray1);
            NSLog(@"pricedata%lu", (unsigned long)PriceArray1.count);        }
        if (row == 12){
            PricePredicate = [NSPredicate predicateWithFormat:@"(Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR(Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR(Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR(Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR(Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@)", @"200,000", @"201,000", @"202,000", @"203,000", @"204,000", @"205,000", @"206,000", @"207,000", @"208,000", @"209,000", @"210,000", @"211,000", @"212,000", @"213,000", @"214,000", @"215,000", @"216,000", @"217,000", @"218,000", @"219,000", @"220,000", @"221,000", @"222,000", @"223,000", @"224,000", @"225,000", @"226,000", @"227,000", @"228,000", @"229,000", @"230,000", @"231,000", @"232,000", @"233,000", @"234,000", @"235,000", @"236,000", @"237,000", @"238,000", @"239,000", @"240,000", @"241,000", @"242,000", @"243,000", @"244,000", @"245,000", @"246,000", @"247,000", @"248,000", @"249,000", @"250,000", @"251,000", @"252,000", @"253,000", @"254,000", @"255,000", @"256,000", @"257,000", @"258,000", @"259,000", @"260,000", @"261,000", @"262,000", @"263,000", @"264,000", @"265,000", @"266,000", @"267,000", @"268,000", @"269,000", @"270,000", @"271,000", @"272,000", @"273,000", @"274,000", @"275,000", @"276,000", @"277,000", @"278,000", @"279,000", @"280,000", @"281,000", @"282,000", @"283,000", @"284,000", @"285,000", @"286,000", @"287,000", @"288,000", @"289,000", @"290,000", @"291,000", @"292,000", @"293,000", @"294,000", @"295,000", @"296,000", @"297,000", @"298,000", @"299,000", @"300,000", @"301,000", @"302,000", @"303,000", @"304,000", @"305,000", @"306,000", @"307,000", @"308,000", @"309,000", @"310,000", @"311,000", @"312,000", @"313,000", @"314,000", @"315,000", @"316,000", @"317,000", @"318,000", @"319,000", @"320,000", @"321,000", @"322,000", @"323,000", @"324,000", @"325,000", @"326,000", @"327,000", @"328,000", @"329,000", @"330,000", @"331,000", @"332,000", @"333,000", @"334,000", @"335,000", @"336,000", @"337,000", @"338,000", @"339,000", @"340,000", @"341,000", @"342,000", @"343,000", @"344,000", @"345,000", @"346,000", @"347,000", @"348,000", @"349,000", @"350,000", @"351,000", @"352,000", @"353,000", @"354,000", @"355,000", @"356,000", @"357,000", @"358,000", @"359,000", @"360,000", @"361,000", @"362,000", @"363,000", @"364,000", @"365,000", @"366,000", @"367,000", @"368,000", @"369,000", @"370,000", @"371,000", @"372,000", @"373,000", @"374,000", @"375,000", @"376,000", @"377,000", @"378,000", @"379,000", @"380,000", @"381,000", @"382,000", @"383,000", @"384,000", @"385,000", @"386,000", @"387,000", @"388,000", @"389,000", @"390,000", @"391,000", @"392,000", @"393,000", @"394,000", @"395,000", @"396,000", @"397,000", @"398,000", @"399,000", @"400,000", @"401,000", @"402,000", @"403,000", @"404,000", @"405,000", @"406,000", @"407,000", @"408,000", @"409,000", @"410,000", @"411,000", @"412,000", @"413,000", @"414,000", @"415,000", @"416,000", @"417,000", @"418,000", @"419,000", @"420,000", @"421,000", @"422,000", @"423,000", @"424,000", @"425,000", @"426,000", @"427,000", @"428,000", @"429,000", @"430,000", @"431,000", @"432,000", @"433,000", @"434,000", @"435,000", @"436,000", @"437,000", @"438,000", @"439,000", @"440,000", @"441,000", @"442,000", @"443,000", @"444,000", @"445,000", @"446,000", @"447,000", @"448,000", @"449,000", @"450,000", @"451,000", @"452,000", @"453,000", @"454,000", @"455,000", @"456,000", @"457,000", @"458,000", @"459,000", @"460,000", @"461,000", @"462,000", @"463,000", @"464,000", @"465,000", @"466,000", @"467,000", @"468,000", @"469,000", @"470,000", @"471,000", @"472,000", @"473,000", @"474,000", @"475,000", @"476,000", @"477,000", @"478,000", @"479,000", @"480,000", @"481,000", @"482,000", @"483,000", @"484,000", @"485,000", @"486,000", @"487,000", @"488,000", @"489,000", @"490,000", @"491,000", @"492,000", @"493,000", @"494,000", @"495,000", @"496,000", @"497,000", @"498,000", @"499,000", @"500,000"];
            PriceArray1 = [jsonArray filteredArrayUsingPredicate:PricePredicate];
            NSLog(@"pricedata%@", PriceArray1);
            NSLog(@"pricedata%lu", (unsigned long)PriceArray1.count);
        }
        if (row == 13){
            PricePredicate = [NSPredicate predicateWithFormat:@"(Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@) OR (Price CONTAINS %@)", @"840,000", @"650,000", @"580,000", @"929,000", @"845,000", @"500,000", @"700,000", @"m"];
            PriceArray1 = [jsonArray filteredArrayUsingPredicate:PricePredicate];
            NSLog(@"pricedata%@", PriceArray1);
            NSLog(@"pricedata%lu", (unsigned long)PriceArray1.count);
        }
    } //End Price Pickerview Actions
    
    
    //Engine Pickerview Actions Start
    if([pickerView isEqual:enginePicker]){
        if (component == 0)
        if (row == 0){
            EnginePredicate = [NSPredicate predicateWithFormat:@"Engine.length > 0"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
            NSLog(@"pricedata%lu", (unsigned long)EngineArray1.count);
        }
        if (row == 1){
            EnginePredicate = [NSPredicate predicateWithFormat:@"Engine CONTAINS %@", @"Electric"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
            NSLog(@"pricedata%@", EngineArray1);
            NSLog(@"transmissionarray%lu", (unsigned long)EngineArray1.count);
        }
        if (row == 2){
            EnginePredicate = [NSPredicate predicateWithFormat:@"Engine CONTAINS %@", @"l3"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
            NSLog(@"pricedata%@", EngineArray1);
            NSLog(@"transmissionarray%lu", (unsigned long)EngineArray1.count);
        }
        if (row == 3){
            EnginePredicate = [NSPredicate predicateWithFormat:@"(Engine CONTAINS %@) OR (Engine CONTAINS %@)", @"Flat-4", @"l4"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
            NSLog(@"pricedata%@", EngineArray1);
            NSLog(@"transmissionarray%lu", (unsigned long)EngineArray1.count);
        }
        if (row == 4){
            EnginePredicate = [NSPredicate predicateWithFormat:@"Engine CONTAINS %@", @"l5"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
            NSLog(@"pricedata%@", EngineArray1);
        }
        if (row == 5){
            EnginePredicate = [NSPredicate predicateWithFormat:@"(Engine CONTAINS %@) OR (Engine CONTAINS %@) OR (Engine CONTAINS %@)", @"Flat-6", @"V6", @"l6"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
            NSLog(@"pricedata%@", EngineArray1);
        }
        if (row == 6){
            EnginePredicate = [NSPredicate predicateWithFormat:@"(Engine CONTAINS %@) OR (Engine CONTAINS %@)", @"V8", @"l8"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
            NSLog(@"pricedata%@", EngineArray1);
        }
        if (row == 7){
            EnginePredicate = [NSPredicate predicateWithFormat:@"Engine CONTAINS %@", @"V10"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
            NSLog(@"pricedata%@", EngineArray1);
        }
        if (row == 8){
            EnginePredicate = [NSPredicate predicateWithFormat:@"(Engine CONTAINS %@) OR (Engine CONTAINS %@) OR (Engine CONTAINS %@)", @"F12", @"V12", @"W12"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
            NSLog(@"pricedata%@", EngineArray1);
        }
        if (row == 9){
            EnginePredicate = [NSPredicate predicateWithFormat:@"Engine CONTAINS %@", @"W16"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
            NSLog(@"pricedata%@", EngineArray1);
        }
        if (row == 10){
            EnginePredicate = [NSPredicate predicateWithFormat:@"Engine CONTAINS %@", @"Rotary"];
            EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
            NSLog(@"pricedata%@", EngineArray1);
        }
    } //End Engine Pickerview Actions


    //Transmission Pickerview Actions Start
    if([pickerView isEqual:transmissionPicker]){
        if (component == 0)
            if (row == 0){
                TransmissionPredicate = [NSPredicate predicateWithFormat:@"Transmission.length > 0"];
                TransmissionArray1 = [EngineArray1 filteredArrayUsingPredicate:TransmissionPredicate];
                NSLog(@"pricedata%lu", (unsigned long)TransmissionArray1.count);
            }
            if (row == 1){
                TransmissionPredicate = [NSPredicate predicateWithFormat:@"Transmission CONTAINS %@", @"Automatic"];
                TransmissionArray1 = [EngineArray1 filteredArrayUsingPredicate:TransmissionPredicate];
                NSLog(@"transmissionarray%lu", (unsigned long)TransmissionArray1.count);
            }
            if (row == 2){
                TransmissionPredicate = [NSPredicate predicateWithFormat:@"Transmission CONTAINS %@", @"Manual"];
                TransmissionArray1 = [EngineArray1 filteredArrayUsingPredicate:TransmissionPredicate];
                NSLog(@"transmissionarray%lu", (unsigned long)TransmissionArray1.count);
            }
            if (row == 3){
                TransmissionPredicate = [NSPredicate predicateWithFormat:@"Transmission CONTAINS %@", @"CVT"];
                TransmissionArray1 = [EngineArray1 filteredArrayUsingPredicate:TransmissionPredicate];
                NSLog(@"transmissionarray%@", TransmissionArray1);
            }
    } //End Transmission Pickerview Actions
    
    
    //Drive Type PickerView Actions Start
    if([pickerView isEqual:driveTypePicker]){
        if (component == 0)
            if (row == 0){
                DriveTypePredicate = [NSPredicate predicateWithFormat:@"Transmission.length > 0"];
                DriveTypeArray1 = [TransmissionArray1 filteredArrayUsingPredicate:DriveTypePredicate];
                NSLog(@"pricedata%lu", (unsigned long)DriveTypeArray1.count);

            }
            if (row == 1){
                DriveTypePredicate = [NSPredicate predicateWithFormat:@"%K CONTAINS %@", @"Drive Type", @"4WD"];
                DriveTypeArray1 = [TransmissionArray1 filteredArrayUsingPredicate:DriveTypePredicate];
                NSLog(@"drivetypearray%@", DriveTypeArray1);
            }
            if (row == 2){
                DriveTypePredicate = [NSPredicate predicateWithFormat:@"%K CONTAINS %@", @"Drive Type", @"AWD"];
                DriveTypeArray1 = [TransmissionArray1 filteredArrayUsingPredicate:DriveTypePredicate];
                NSLog(@"drivetypearray%@", DriveTypeArray1);
            }
            if (row == 3){
                DriveTypePredicate = [NSPredicate predicateWithFormat:@"%K CONTAINS %@", @"Drive Type", @"FWD"];
                DriveTypeArray1 = [TransmissionArray1 filteredArrayUsingPredicate:DriveTypePredicate];
                NSLog(@"drivetypearray%@", DriveTypeArray1);
            }
            if (row == 4){
                DriveTypePredicate = [NSPredicate predicateWithFormat:@"%K CONTAINS %@", @"Drive Type", @"RWD"];
                DriveTypeArray1 = [TransmissionArray1 filteredArrayUsingPredicate:DriveTypePredicate];
                NSLog(@"drivetypearray%@", DriveTypeArray1);
        }
    }//Drive Type PickerView Actions End
    
    //Horsepower Pickerview Actions Start
    if([pickerView isEqual:horsepowerPicker]){
        if (component == 0)
        if (row == 0){
            HorsepowerPredicate = [NSPredicate predicateWithFormat:@"Transmission.length > 0"];
            HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
            NSLog(@"pricedata%lu", (unsigned long)HorsepowerArray1.count);
        }
        if (row == 1){
            HorsepowerPredicate = [NSPredicate predicateWithFormat:@"(Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@)", @" 50", @" 51", @" 52", @" 53", @" 54", @" 55", @" 56", @" 57", @" 58", @" 59", @" 60", @" 61", @" 62", @" 63", @" 64", @" 65", @" 66", @" 67", @" 68", @" 69", @" 70", @" 71", @" 72", @" 73", @" 74", @" 75", @" 76", @" 77", @" 78", @" 79", @" 80", @" 81", @" 82", @" 83", @" 84", @" 85", @" 86", @" 87", @" 88", @" 89", @" 90", @" 91", @" 92", @" 93", @" 94", @" 95", @" 96", @" 97", @" 98", @" 99"];
            HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
            NSLog(@"transmissionarray%@", HorsepowerArray1);
            NSLog(@"horsepowerarraycount%lu", (unsigned long)HorsepowerArray1.count);
        }
        if (row == 2){
            HorsepowerPredicate = [NSPredicate predicateWithFormat:@"(Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@)", @"101", @"102", @"103", @"105", @"106", @"107", @"108", @"109", @"110", @"111", @"112", @"113", @"114", @"115", @"116", @"117", @"118", @"119", @"120", @"121", @"122", @"123", @"124", @"125", @"126", @"127", @"128", @"129", @"130", @"131", @"132", @"133", @"134", @"135", @"136", @"137", @"138", @"139", @" 140", @"141", @"142", @"143", @"144", @"145", @"146", @"147", @"148", @"149", @"150", @"151", @"152", @"153", @"154", @"155", @"156", @"157", @"158", @"159", @"160", @"161", @"162", @"163", @"164", @"165", @"166", @"167", @"168", @"169", @"170", @"171", @"172", @"173", @"174", @"175", @"176", @"177", @"178", @"179", @"180", @"181", @"182", @"183", @"184", @"185", @"186", @"187", @"188", @"189", @"190", @"191", @"192", @"193", @"194", @"195", @"196", @"197", @"198", @"199", @" 200"];
            HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
            NSLog(@"transmissionarray%@", HorsepowerArray1);
            NSLog(@"transmissionarray%lu", (unsigned long)HorsepowerArray1.count);
        }
        if (row == 3){
            HorsepowerPredicate = [NSPredicate predicateWithFormat:@"(Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@)", @"201", @"202", @"203", @"204", @"205", @"206", @"207", @"208", @"209", @"210", @"211", @"212", @"213", @"214", @"215", @"216", @"217", @"218", @"219", @"220", @"221", @"222", @"223", @"224", @"225", @"226", @"227", @"228", @"229", @"230", @"231", @"232", @"233", @"234", @"235", @"236", @"237", @"238", @"239", @"240", @"241", @"242", @"243", @"245", @"246", @"247", @"248", @"249", @"250", @"251", @"252", @"253", @"254", @"255", @"256", @"257", @"258", @"259", @"260", @"261", @"262", @"263", @"264", @"265", @"266", @"267", @"268", @"269", @"270", @"271", @"272", @"273", @"274", @"275", @"276", @"277", @"278", @"279", @"280", @"281", @"282", @"283", @"284", @"285", @"286", @" 287", @"288", @"289", @"290", @"291", @"292", @"293", @"294", @"295", @"296", @"297", @"298", @"299", @"300"];
            HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
            NSLog(@"transmissionarray%@", HorsepowerArray1);
            NSLog(@"transmissionarray%lu", (unsigned long)HorsepowerArray1.count);
        }
        if (row == 4){
            HorsepowerPredicate = [NSPredicate predicateWithFormat:@"(Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@)", @"301", @"302", @"303", @"304", @"305", @"306", @"307", @"308", @"309", @"310", @"311", @"312", @"313", @"314", @"315", @"316", @"317", @"318", @"319", @"320", @"321", @"322", @"323", @"324", @"325", @"326", @"327", @"328", @"329", @"330", @"331", @"332", @"333", @"334", @"335", @"336", @"337", @"338", @"339", @"340", @"341", @"342", @"343", @"344", @"345", @"346", @"347", @"348", @"349", @" 350", @"351", @"352", @"353", @"354", @"355", @"356", @"357", @"358", @"359", @"360", @"361", @"362", @"363", @"364", @"365", @"366", @"367", @"368", @"369", @"370", @"371", @"372", @"373", @"374", @"375", @"376", @"377", @"378", @"379", @"380", @"381", @"382", @"383", @"384", @"385", @"386", @"387", @"388", @"389", @"390", @"391", @"392", @"393", @"394", @"395", @"396", @"397", @"398", @"399", @"400"];
            HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
            NSLog(@"transmissionarray%@", HorsepowerArray1);
            NSLog(@"horsepowerarraycount%lu", (unsigned long)HorsepowerArray1.count);
        }
        if (row == 5){
            HorsepowerPredicate = [NSPredicate predicateWithFormat:@"(Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@)", @"401", @"402", @"403", @"404", @"405", @"406", @"407", @"408", @"409", @"410", @"411", @"412", @"413", @"414", @"415", @"416", @"417", @"418", @"419", @"420", @"421", @"422", @"423", @"424", @"425", @"426", @"427", @"428", @"429", @"430", @"431", @"432", @"433", @"434", @"435", @"436", @"437", @"438", @"439", @"440", @"441", @"442", @"443", @"444", @"445", @"446", @"447", @"448", @"449", @"450", @"451", @"452", @"453", @"454", @"455", @"456", @"457", @"458", @"459", @"460", @"461", @"462", @"463", @"464", @"465", @"466", @"467", @"468", @"469", @"470", @"471", @"472", @"473", @"474", @"475", @"476", @"477", @"478", @"479", @"480", @"481", @"482", @"483", @"484", @"485", @"486", @"487", @"488", @"489", @"490", @"491", @"492", @"493", @"494", @"495", @"496", @"497", @"498", @"499", @"500"];
            HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
            NSLog(@"transmissionarray%@", HorsepowerArray1);
            NSLog(@"horsepowerarraycount%lu", (unsigned long)HorsepowerArray1.count);
        }
        if (row == 6){
            HorsepowerPredicate = [NSPredicate predicateWithFormat:@"(Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@)", @"501", @"502", @"503", @"504", @"505", @"506", @"507", @"508", @"509", @"510", @"511", @"512", @"513", @"514", @"515", @"516", @"517", @"518", @"519", @"520", @"521", @"522", @"523", @"524", @"525", @"526", @"527", @"528", @"529", @"530", @"531", @"532", @"533", @"534", @"535", @"536", @"537", @"538", @"539", @"540", @"541", @"542", @"543", @"544", @"545", @"546", @"547", @"548", @"549", @"550", @"551", @"552", @"553", @"554", @"555", @"556", @"557", @"558", @"559", @"560", @"561", @"562", @"563", @"564", @"565", @"566", @"567", @"568", @"569", @"570", @"571", @"572", @"573", @"574", @"575", @"576", @"577", @"578", @"579", @"580", @"581", @"582", @"583", @"584", @"585", @"586", @"587", @"588", @"589", @"590", @"591", @"592", @"593", @"594", @"595", @"596", @"597", @"598", @"599", @"600"];
            HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
            NSLog(@"transmissionarray%@", HorsepowerArray1);
            NSLog(@"horsepowerarraycount%lu", (unsigned long)HorsepowerArray1.count);
        }
        if (row == 7){
            HorsepowerPredicate = [NSPredicate predicateWithFormat:@"(Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@)", @"601", @"602", @"603", @"604", @"605", @"606", @"607", @"608", @"609", @"610", @"611", @"612", @"613", @"614", @"615", @"616", @"617", @"618", @"619", @"620", @"621", @"622", @"623", @"624", @"625", @"626", @"627", @"628", @"629", @"630", @"631", @"632", @"633", @"634", @"635", @"636", @"637", @"638", @"639", @"640", @"641", @"642", @"643", @"644", @"645", @"646", @"647", @"648", @"649", @"650", @"651", @"652", @"653", @"654", @"655", @"656", @"657", @"658", @"659", @"660", @"661", @"662", @"663", @"664", @"665", @"666", @"667", @"668", @"669", @"670", @"671", @"672", @"673", @"674", @"675", @"676", @"677", @"678", @"679", @"680", @"681", @"682", @"683", @"684", @"685", @"686", @"687", @"688", @"689", @"690", @"691", @"692", @"693", @"694", @"695", @"696", @"697", @"698", @"699", @"700"];                    HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
            NSLog(@"transmissionarray%@", HorsepowerArray1);
            NSLog(@"horsepowerarraycount%lu", (unsigned long)HorsepowerArray1.count);
        }
        if (row == 8){
            HorsepowerPredicate = [NSPredicate predicateWithFormat:@"(Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@) OR (Horsepower CONTAINS %@)", @"1,104", @"1,350", @"1,287", @"1,244", @"1,018", @"1,030", @"1,140", @"1,001", @"1,200", @"960", @"806", @"888", @"727", @"730", @"740", @"800", @"887"];
            HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
            NSLog(@"transmissionarray%@", HorsepowerArray1);
            NSLog(@"horsepowerarraycount%lu", (unsigned long)HorsepowerArray1.count);
        }
    } //End Horsepower Pickerview Actions

    //0-60 Pickerview Actions Start
    if([pickerView isEqual:zeroToSixtyPicker]){
        if (component == 0)
        if (row == 0){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"Price.length > 0"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
            NSLog(@"pricedata%lu", (unsigned long)ZerotoSixtyArray1.count);
        }
        if (row == 1){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"(%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@)", @"0-60", @" 2.0", @"0-60", @" 2.1", @"0-60", @" 2.2", @"0-60", @" 2.3", @"0-60", @" 2.4", @"0-60", @" 2.5", @"0-60", @" 2.6", @"0-60", @"2.7", @"0-60", @" 2.8", @"0-60", @"2.9", @"0-60", @" 3.0"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
            NSLog(@"transmissionarray%@", ZerotoSixtyArray1);
            NSLog(@"horsepowerarraycount%lu", (unsigned long)ZerotoSixtyArray1.count);
        }
        if (row == 2){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"(%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@)", @"0-60", @"3.1", @"0-60", @"3.2", @"0-60", @"3.3", @"0-60", @" 3.4", @"0-60", @" 3.5", @"0-60", @"3.6", @"0-60", @" 3.7", @"0-60", @"3.8", @"0-60", @" 3.9", @"0-60", @" 4.0"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
            NSLog(@"transmissionarray%@", ZerotoSixtyArray1);
            NSLog(@"horsepowerarraycount%lu", (unsigned long)ZerotoSixtyArray1.count);
        }
        if (row == 3){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"(%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@)", @"0-60", @"4.1", @"0-60", @"4.2", @"0-60", @"4.3", @"0-60", @"4.4", @"0-60", @" 4.5", @"0-60", @" 4.6", @"0-60", @" 4.7", @"0-60", @"4.8", @"0-60", @"4.9", @"0-60", @" 5.0"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
            NSLog(@"transmissionarray%@", ZerotoSixtyArray1);
            NSLog(@"horsepowerarraycount%lu", (unsigned long)ZerotoSixtyArray1.count);
        }
        if (row == 4){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"(%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@)", @"0-60", @"5.1", @"0-60", @" 5.2", @"0-60", @"5.3", @"0-60", @"5.4", @"0-60", @"5.5"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
            NSLog(@"transmissionarray%@", ZerotoSixtyArray1);
            NSLog(@"horsepowerarraycount%lu", (unsigned long)ZerotoSixtyArray1.count);
        }
        if (row == 5){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"(%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@)", @"0-60", @"5.6", @"0-60", @"5.7", @"0-60", @"5.8", @"0-60", @" 5.9", @"0-60", @"6.0"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
            NSLog(@"transmissionarray%@", ZerotoSixtyArray1);
            NSLog(@"horsepowerarraycount%lu", (unsigned long)ZerotoSixtyArray1.count);
        }
        if (row == 6){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"(%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@)", @"0-60", @"6.1", @"0-60", @"6.2", @"0-60", @"6.3", @"0-60", @"6.4", @"0-60", @" 6.5"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
            NSLog(@"transmissionarray%@", ZerotoSixtyArray1);
            NSLog(@"horsepowerarraycount%lu", (unsigned long)ZerotoSixtyArray1.count);
        }
        if (row == 7){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"(%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@)", @"0-60", @" 6.6", @"0-60", @"6.7", @"0-60", @"6.8", @"0-60", @"6.9", @"0-60", @"7.0"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
            NSLog(@"transmissionarray%@", ZerotoSixtyArray1);
            NSLog(@"horsepowerarraycount%lu", (unsigned long)ZerotoSixtyArray1.count);
        }
        if (row == 8){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"(%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@)", @"0-60", @"7.1", @"0-60", @"7.2", @"0-60", @"7.3", @"0-60", @"7.4", @"0-60", @"7.5", @"0-60", @"7.6", @"0-60", @"7.7", @"0-60", @"7.8", @"0-60", @"7.9", @"0-60", @"8.0"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
            NSLog(@"transmissionarray%@", ZerotoSixtyArray1);
            NSLog(@"horsepowerarraycount%lu", (unsigned long)ZerotoSixtyArray1.count);
        }
        if (row == 9){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"(%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@)", @"0-60", @"8.1", @"0-60", @"8.2", @"0-60", @"8.3", @"0-60", @"8.4", @"0-60", @"8.5", @"0-60", @"8.6", @"0-60", @"8.7", @"0-60", @"8.8", @"0-60", @"8.9", @"0-60", @"9.0"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
            NSLog(@"transmissionarray%@", ZerotoSixtyArray1);
            NSLog(@"horsepowerarraycount%lu", (unsigned long)ZerotoSixtyArray1.count);
        }
        if (row == 10){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"(%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@)", @"0-60", @"9.1", @"0-60", @"9.2", @"0-60", @"9.3", @"0-60", @"9.4", @"0-60", @"9.5", @"0-60", @"9.6", @"0-60", @"9.7", @"0-60", @"9.8", @"0-60", @"9.9", @"0-60", @"10.0"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
            NSLog(@"transmissionarray%@", ZerotoSixtyArray1);
            NSLog(@"horsepowerarraycount%lu", (unsigned long)ZerotoSixtyArray1.count);
        }
        if (row == 11){
            ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"(%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@) OR (%K CONTAINS %@)", @"0-60", @"10", @"0-60", @"11", @"0-60", @"12", @"0-60", @"13", @"0-60", @"14", @"0-60", @"15", @"0-60", @"15", @"0-60", @"16", @"0-60", @"17", @"0-60", @"18"];
            ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
            NSLog(@"transmissionarray%@", ZerotoSixtyArray1);
            NSLog(@"horsepowerarraycount%lu", (unsigned long)ZerotoSixtyArray1.count);
        }
    }//End 0-60 Pickerview Actions
    
    //Make PickerView Actions Start
    if([pickerView isEqual:MakePicker]){
        if (component == 0)
            if (row == 0||row == 1||row == 2||row == 3||row == 4||row == 5||row == 6||row == 7||row == 8||row == 9||row == 10||row == 11||row == 12||row == 13||row == 14||row == 15||row == 16||row == 17||row == 18||row == 19||row == 20||row == 21||row == 22||row == 23||row == 24||row == 25||row == 26||row == 27||row == 28||row == 29||row == 30||row == 31||row == 32||row == 33||row == 34||row == 35||row == 36||row == 37||row == 38||row == 39||row == 40||row == 41||row == 42||row == 43||row == 44||row == 45||row == 46||row == 47||row == 48||row == 49||row == 50||row == 51||row == 52||row == 53||row == 54||row == 55||row == 56||row == 57||row == 58||row == 59||row == 60||row == 61||row == 62||row == 63||row == 64||row == 65||row == 66||row == 67||row == 68||row == 69||row == 70||row == 71||row == 72||row == 73||row == 74||row == 75||row == 76||row == 77||row == 78||row == 79){
                MakePredicate = [NSPredicate predicateWithFormat:@"Make == %@", [makeimageArray objectAtIndex:row]];
                [self setModels];
            }
        self.ModelPredicate = nil;
        [self.ModelPicker reloadAllComponents];
        [self.ModelPicker selectRow:0 inComponent:0 animated:YES];
            }//Make PickerView Actions End
    
    //Model PickerView Actions Start
    if([pickerView isEqual:ModelPicker]){
        if (component == 0)
            if (row == 0||row == 1||row == 2||row == 3||row == 4||row == 5||row == 6||row == 7||row == 8||row == 9||row == 10||row == 11||row == 12||row == 13||row == 14||row == 15||row == 16||row == 17||row == 18||row == 19||row == 20||row == 21||row == 22||row == 23||row == 24||row == 25||row == 26||row == 27||row == 28||row == 29||row == 30||row == 31||row == 32||row == 33||row == 34||row == 35||row == 36||row == 37||row == 38||row == 39||row == 40||row == 41||row == 42||row == 43||row == 44||row == 45||row == 46||row == 47||row == 48||row == 49||row == 50||row == 51||row == 52||row == 53||row == 54||row == 55||row == 56||row == 57||row == 58||row == 59||row == 60||row == 61||row == 62||row == 63||row == 64||row == 65||row == 66||row == 67||row == 68||row == 69||row == 70||row == 71||row == 72||row == 73||row == 74||row == 75||row == 76||row == 77||row == 78||row == 79){
                
                ModelPredicate = [NSPredicate predicateWithFormat:@"Model == %@", [ModelArray objectAtIndex:row]];
                [self setModels];
            }
        [self.ModelPicker reloadAllComponents];
    }//Model PickerView Actions End


}

- (void) retrieveData;
{
    NSURL * url = [NSURL URLWithString:getDataURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

    carArray = [[NSMutableArray alloc] init];
    
    //Loop through jsonarray
    for (int i=0; i < jsonArray.count; i++)
    {
        //Create our city object
        NSString * cMake = [[jsonArray objectAtIndex:i] objectForKey:@"Make"];
        NSString * dModel = [[jsonArray objectAtIndex:i] objectForKey:@"Model"];
        NSString * cYearsMade = [[jsonArray objectAtIndex:i] objectForKey:@"Years Made"];
        NSString * cPrice = [[jsonArray objectAtIndex:i] objectForKey:@"Price"];
        NSString * cEngine = [[jsonArray objectAtIndex:i] objectForKey:@"Engine"];
        NSString * cTransmission = [[jsonArray objectAtIndex:i] objectForKey:@"Transmission"];
        NSString * cDriveType = [[jsonArray objectAtIndex:i] objectForKey:@"Drive Type"];
        NSString * cHorsepower = [[jsonArray objectAtIndex:i] objectForKey:@"Horsepower"];
        NSString * cZeroToSixty = [[jsonArray objectAtIndex:i] objectForKey:@"0-60"];
        NSString * cTopSpeed = [[jsonArray objectAtIndex:i] objectForKey:@"Top Speed (mph)"];
        NSString * cWeight = [[jsonArray objectAtIndex:i] objectForKey:@"Weight (lbs)"];
        NSString * cFuelEconomy = [[jsonArray objectAtIndex:i] objectForKey:@"Fuel Economy (mpg)"];
        NSString * cURL = [[jsonArray objectAtIndex:i] objectForKey:@"Image URL"];
        NSString * cWebsite = [[jsonArray objectAtIndex:i]objectForKey:@"Make Link"];
        
        //Add the city object to our cities array
        [carArray addObject:[[Model alloc]initWithCarMake:cMake andCarModel:dModel andCarYearsMade:cYearsMade andCarPrice:cPrice andCarEngine:cEngine andCarTransmission:cTransmission andCarDriveType:cDriveType andCarHorsepower:cHorsepower andCarZeroToSixty:cZeroToSixty andCarTopSpeed:cTopSpeed andCarWeight:cWeight andCarFuelEconomy:cFuelEconomy andCarImageURL:cURL andCarWebsite:cWebsite]];
        
        
        
    }
}

- (void) makeAppDelModelArray;
{
    jsonArray = [[NSMutableArray alloc]init];
    appdelmodeljsonArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"appdelarray2: %@", appdel.modelArray);
    [jsonArray addObjectsFromArray:appdel.modeljsonArray];
    NSLog(@"appdelarray3: %@", appdelmodeljsonArray);
    
    makeimageArray = [[NSMutableArray alloc]init];
    [makeimageArray addObjectsFromArray:appdel.makeimageArray];
}


- (void) retrieveMakeImageData;
{
    NSURL * makeurl = [NSURL URLWithString:getMakeDataURL];
    NSData * makedata = [NSData dataWithContentsOfURL:makeurl];
    
    makejsonArray = [NSJSONSerialization JSONObjectWithData:makedata options:kNilOptions error:nil];
    
    //set up the makes array
    makeimageArray = [[NSMutableArray alloc]init];
    
    NSSortDescriptor * alphasort = [NSSortDescriptor sortDescriptorWithKey:@"Make" ascending:YES];
    AlphabeticalArray = [makejsonArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphasort]];
    
    //Loop through our makejsonArray
    for (int i = 0; i < AlphabeticalArray.count; i++)
    {
        //Create the MakeImage object
        NSString * mName = [[AlphabeticalArray objectAtIndex:i] objectForKey:@"Make"];
        
        //Add the MakeImage object to the MakeImage array
        NSLog(@"mname %@", mName);
        
        [makeimageArray addObject:mName];
    }
    NSString * defaultrow = @"Select a Make";
    [makeimageArray insertObject:defaultrow atIndex:0];
}

- (void) setModels;
{
    ModelArray = [[NSMutableArray alloc]init];
    
    testArray = [jsonArray filteredArrayUsingPredicate:MakePredicate];
    
    for (int i = 0; i < testArray.count; i++)
    {
        cModel = [[testArray objectAtIndex:i] objectForKey:@"Model"];
        NSLog(@"cModel %@", cModel);
        [ModelArray addObject:cModel];
    }
    NSString * defaultrow = @"Select a Model";
    [ModelArray insertObject:defaultrow atIndex:0];

    NSLog(@"testarray%@", testArray);
    
    NSLog(@"modelarray%lu", (unsigned long)ModelArray.count);

}

- (IBAction)UsePredicates {
    if (PricePredicate == nil)
    {
        PricePredicate = [NSPredicate predicateWithFormat:@"Price.length > 0"];
    }
    if (EnginePredicate == nil)
    {
        EnginePredicate = [NSPredicate predicateWithFormat:@"Price.length > 0"];
    }

    if (TransmissionPredicate == nil)
    {
        TransmissionPredicate = [NSPredicate predicateWithFormat:@"Price.length > 0"];
    }

    if (DriveTypePredicate == nil)
    {
        DriveTypePredicate = [NSPredicate predicateWithFormat:@"Price.length > 0"];
    }

    if (HorsepowerPredicate == nil)
    {
        HorsepowerPredicate = [NSPredicate predicateWithFormat:@"Price.length > 0"];
    }

    if (ZeroToSixtyPredicate == nil)
    {
        ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"Price.length > 0"];
    }

    PriceArray1 = [jsonArray filteredArrayUsingPredicate:PricePredicate];
    EngineArray1 = [PriceArray1 filteredArrayUsingPredicate:EnginePredicate];
    TransmissionArray1 = [EngineArray1 filteredArrayUsingPredicate:TransmissionPredicate];
    DriveTypeArray1 = [TransmissionArray1 filteredArrayUsingPredicate:DriveTypePredicate];
    HorsepowerArray1 = [DriveTypeArray1 filteredArrayUsingPredicate:HorsepowerPredicate];
    ZerotoSixtyArray1 = [HorsepowerArray1 filteredArrayUsingPredicate:ZeroToSixtyPredicate];
    
    NSSortDescriptor * alphasort = [NSSortDescriptor sortDescriptorWithKey:@"Model" ascending:YES];
    ZerotoSixtyArray1 = [ZerotoSixtyArray1 sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphasort]];
    
    NSLog(@"predicates%@", ZerotoSixtyArray1);
    NSLog(@"predicatescount%lu", (unsigned long)ZerotoSixtyArray1.count);
}
- (IBAction)UseModelPredicates {
    if (ModelPredicate == nil)
    {
     ModelPredicate = [NSPredicate predicateWithFormat:@"Price.length > 100000"];
    }
    
    finalModelArray = [jsonArray filteredArrayUsingPredicate:ModelPredicate];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"pushModelView"])
    {
        NSArray * searcharray = ZerotoSixtyArray1;
        [[segue destinationViewController] getsearcharray:searcharray];
    }
    if ([[segue identifier] isEqualToString:@"pushCarView"])
    {
        NSArray * searcharray = finalModelArray;
        [[segue destinationViewController] getsearcharray:searcharray];
    }
    
}

@end
