//
//  SearchViewController.m
//  Carhub
//
//  Created by Christoper Clark on 10/2/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "SearchViewController.h"
#import <Google/Analytics.h>
#import "SWRevealViewController.h"
#import "SearchCell.h"
#import "AppDelegate.h"
#import "Make.h"
#import "Model.h"
#import "SearchModelController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize expandedIndexPath, makeArray, fullModelArray, alteredModelArray, alteredModelSpecsArray, currencySymbol, hpUnit, speedUnit, torqueUnit, weightUnit, fuelEconomyUnit;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeAppDelModelArray];
    
    [self setTitle:@"Car Finder"];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:self.title];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    self.barButton.target = self.revealViewController;
    self.barButton.action = @selector(revealToggle:);
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeCellTable) name:@"closeCellTable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchMake) name:@"switchMake" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSpecsResults) name:@"updateSpecsResults" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:@"Any" forKey:@"Make Setting"];
    
    Model *defaultModel = [[Model alloc]initWithCarPrimaryKey:[NSNumber numberWithInt:0] andCarMake:@"" andCarModel:@"Any" andCarYearsMade:@"" andCarMSRP:[NSNumber numberWithInt:0] andCarPrice:@"" andCarPriceLow:[NSNumber numberWithInt:0] andCarPriceHigh:[NSNumber numberWithInt:0] andCarEngine:@"" andCarTransmission:@"" andCarDriveType:@"" andCarHorsepower:@"" andCarHorsepowerLow:[NSNumber numberWithInt:0] andCarHorsepowerHigh:[NSNumber numberWithInt:0] andCarTorque:@"" andCarTorqueLow:[NSNumber numberWithInt:0] andCarTorqueHigh:[NSNumber numberWithInt:0] andCarZeroToSixty:@"" andCarZeroToSixtyLow:[NSNumber numberWithInt:0]  andCarZeroToSixtyHigh:[NSNumber numberWithInt:0] andCarTopSpeed:@"" andCarTopSpeedLow:@"" andCarTopSpeedHigh:@"" andCarWeight:@"" andCarWeightLow:[NSNumber numberWithInt:0] andCarWeightHigh:[NSNumber numberWithInt:0] andCarFuelEconomy:@"" andCarFuelEconomyLow:[NSNumber numberWithInt:0] andCarFuelEconomyHigh:[NSNumber numberWithInt:0] andCarImageURL:@"" andCarWebsite:@"" andCarFullName:@"Any" andCarExhaust:@"" andCarHTML:@"" andShouldFlipEvox:@"" andisClass:[NSNumber numberWithInt:0] andisSubclass:[NSNumber numberWithInt:0] andisModel:[NSNumber numberWithInt:0] andisStyle:[NSNumber numberWithInt:0] andCarClass:@"" andCarSubclass:@"" andCarStyle:@"" andRemoveLogo:[NSNumber numberWithInteger:0] andZoomScale:[NSNumber numberWithInt:0]];
    
    NSData *defaultModelData = [NSKeyedArchiver archivedDataWithRootObject:defaultModel];
    
    [defaults setObject:defaultModelData forKey:@"Model Setting"];
    [defaults setObject:@"Any" forKey:@"Price Setting"];
    [defaults setObject:@"Any" forKey:@"Converted Price Setting"];
    [defaults setObject:@"Any" forKey:@"Engine Setting"];
    [defaults setObject:@"Any" forKey:@"Transmission Setting"];
    [defaults setObject:@"Any" forKey:@"Drive Type Setting"];
    [defaults setObject:@"Any" forKey:@"Horsepower Setting"];
    [defaults setObject:@"Any" forKey:@"Converted Horsepower Setting"];
    [defaults setObject:@"Any" forKey:@"Torque Setting"];
    [defaults setObject:@"Any" forKey:@"Converted Torque Setting"];
    [defaults setObject:@"Any" forKey:@"0-60 Time Setting"];
    [defaults setObject:@"Any" forKey:@"Fuel Economy Setting"];
    [defaults setObject:@"Any" forKey:@"Converted Fuel Economy Setting"];
    [defaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        [cell setSeparatorInset:UIEdgeInsetsZero];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        [cell setLayoutMargins:UIEdgeInsetsZero];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 3;
    if(section == 1)
        return 9;
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"Search by Model";
    else
        return @"Search by Specifications";
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0, 200, 300, 244)];
    tempView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    tempView.layer.borderWidth = 0.5f;
    tempView.layer.borderColor = ([UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0]).CGColor;
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, -5, 300, 44)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.textColor = [UIColor darkGrayColor];
    tempLabel.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    
    switch (section)
    {
        case 0:
            tempLabel.text=@"Search by Model";
            break;
        case 1:
            tempLabel.text=@"Search by Specifications";
            break;
        default:
            break;
    }
    
    [tempView addSubview:tempLabel];
    
    return tempView;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame)
    {
        if([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:0]])
            return 220;
        if([indexPath isEqual:[NSIndexPath indexPathForRow:1 inSection:0]])
            return 220;
        if([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:1]])
            return 220;
        if([indexPath isEqual:[NSIndexPath indexPathForRow:1 inSection:1]])
            return 220;
        if([indexPath isEqual:[NSIndexPath indexPathForRow:2 inSection:1]])
            return 220;
        if([indexPath isEqual:[NSIndexPath indexPathForRow:3 inSection:1]])
            return 220;
        if([indexPath isEqual:[NSIndexPath indexPathForRow:4 inSection:1]])
            return 220;
        if([indexPath isEqual:[NSIndexPath indexPathForRow:5 inSection:1]])
            return 220;
        if([indexPath isEqual:[NSIndexPath indexPathForRow:6 inSection:1]])
            return 220;
        if([indexPath isEqual:[NSIndexPath indexPathForRow:7 inSection:1]])
            return 220;
        return 100;
    }
    return 44.0; // Normal height
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchCell";
    SearchCell *cell = (SearchCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.settingLabel setFont:[UIFont fontWithName:@"MavenProRegular" size:17]];
    
    [cell.viewCarLabel setAlpha:0];
    [cell.settingImage setAlpha:1];
    [cell.settingLabel setAlpha:1];
    [cell.currentSelectionLabel setAlpha:1];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            [cell.currentSelectionLabel setText:[defaults objectForKey:@"Make Setting"]];
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"Home.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"Make:";
            cell.dataArray = makeArray;
        }
        if(indexPath.row == 1)
        {
            Model *currentModel = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"Model Setting"]];
            [cell.currentSelectionLabel setText:currentModel.CarModel];
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"Makes.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"Model:";
            
            if([[defaults objectForKey:@"Make Setting"] isEqualToString:@"Any"])
                cell.dataArray = fullModelArray;
            else
                cell.dataArray = alteredModelArray;
        }
        if(indexPath.row == 2)
        {
            [cell.settingImage setAlpha:0];
            [cell.settingLabel setAlpha:0];
            [cell.currentSelectionLabel setAlpha:0];
            [cell.viewCarLabel setAlpha:1];
            
            Model *selectedModel = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"Model Setting"]];
            if([selectedModel.CarModel isEqualToString:@"Any"])
                [cell.viewCarLabel setText:[NSString stringWithFormat:@"View Results (%lu)", (unsigned long)alteredModelArray.count-1]];
            else
                [cell.viewCarLabel setText:[NSString stringWithFormat:@"View Result (1)"]];
        }
    }
    if(indexPath.section == 1)
    {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
        [numberFormatter setMaximumFractionDigits:0];
        
        if(indexPath.row == 0)
        {
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"Price.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"Price:";
            
            [self determineCarPrice:0];
            
            NSString *priceRange1 = [NSString stringWithFormat:@"%@%@-%@", currencySymbol, [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:0]]], [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:5000]]]];
            NSString *priceRange2 = [NSString stringWithFormat:@"%@%@-%@", currencySymbol, [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:5000]]], [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:10000]]]];
            NSString *priceRange3 = [NSString stringWithFormat:@"%@%@-%@", currencySymbol, [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:10000]]], [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:20000]]]];
            NSString *priceRange4 = [NSString stringWithFormat:@"%@%@-%@", currencySymbol, [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:20000]]], [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:30000]]]];
            NSString *priceRange5 = [NSString stringWithFormat:@"%@%@-%@", currencySymbol, [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:30000]]], [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:40000]]]];
            NSString *priceRange6 = [NSString stringWithFormat:@"%@%@-%@", currencySymbol, [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:40000]]], [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:50000]]]];
            NSString *priceRange7 = [NSString stringWithFormat:@"%@%@-%@", currencySymbol, [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:50000]]], [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:65000]]]];
            NSString *priceRange8 = [NSString stringWithFormat:@"%@%@-%@", currencySymbol, [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:65000]]], [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:80000]]]];
            NSString *priceRange9 = [NSString stringWithFormat:@"%@%@-%@", currencySymbol, [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:80000]]], [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:100000]]]];
            NSString *priceRange10 = [NSString stringWithFormat:@"%@%@-%@", currencySymbol, [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:100000]]], [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:150000]]]];
            NSString *priceRange11 = [NSString stringWithFormat:@"%@%@-%@", currencySymbol, [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:150000]]], [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:200000]]]];
            NSString *priceRange12 = [NSString stringWithFormat:@"%@%@-%@", currencySymbol, [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:200000]]], [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:500000]]]];
            NSString *priceRange13 = [NSString stringWithFormat:@"%@%@+", currencySymbol, [numberFormatter stringFromNumber: [self determineCarPrice:[NSNumber numberWithInt:500000]]]];
            
            cell.dataArray = [NSMutableArray arrayWithObjects: @"Any", priceRange1, priceRange2, priceRange3, priceRange4, priceRange5, priceRange6, priceRange7, priceRange8, priceRange9, priceRange10, priceRange11, priceRange12, priceRange13, nil];
            
            NSString *currentSelection = [defaults objectForKey:@"Price Setting"];
            
            if([currentSelection isEqualToString:@"Any"])
                [cell.currentSelectionLabel setText:@"Any"];
            if([currentSelection isEqualToString:@"$0-5,000"])
                [cell.currentSelectionLabel setText:priceRange1];
            if([currentSelection isEqualToString:@"$5,000-10,000"])
                [cell.currentSelectionLabel setText:priceRange2];
            if([currentSelection isEqualToString:@"$10,000-20,000"])
                [cell.currentSelectionLabel setText:priceRange3];
            if([currentSelection isEqualToString:@"$20,000-30,000"])
                [cell.currentSelectionLabel setText:priceRange4];
            if([currentSelection isEqualToString:@"$30,000-40,000"])
                [cell.currentSelectionLabel setText:priceRange5];
            if([currentSelection isEqualToString:@"$40,000-50,000"])
                [cell.currentSelectionLabel setText:priceRange6];
            if([currentSelection isEqualToString:@"$50,000-65,000"])
                [cell.currentSelectionLabel setText:priceRange7];
            if([currentSelection isEqualToString:@"$65,000-80,000"])
                [cell.currentSelectionLabel setText:priceRange8];
            if([currentSelection isEqualToString:@"$80,000-100,000"])
                [cell.currentSelectionLabel setText:priceRange9];
            if([currentSelection isEqualToString:@"$100,000-150,000"])
                [cell.currentSelectionLabel setText:priceRange10];
            if([currentSelection isEqualToString:@"$150,000-200,000"])
                [cell.currentSelectionLabel setText:priceRange11];
            if([currentSelection isEqualToString:@"$200,000-500,000"])
                [cell.currentSelectionLabel setText:priceRange12];
            if([currentSelection isEqualToString:@"$500,000+"])
                [cell.currentSelectionLabel setText:priceRange13];
        }
        if(indexPath.row == 1)
        {
            [cell.currentSelectionLabel setText:[defaults objectForKey:@"Engine Setting"]];
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"Engine.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"Engine:";
            cell.dataArray =  [[NSMutableArray alloc] initWithObjects:@"Any", @"Electric/Hybrid", @"3 Cylinder", @"4 Cylinder", @"5 Cylinder", @"6 Cylinder", @"8 Cylinder", @"10 Cylinder", @"12 Cylinder", @"16 Cylinder", @"Rotary", nil];
        }
        if(indexPath.row == 2)
        {
            [cell.currentSelectionLabel setText:[defaults objectForKey:@"Transmission Setting"]];
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"Transmission&Settings.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"Transmission:";
            cell.dataArray = [[NSMutableArray alloc] initWithObjects:@"Any", @"Automatic", @"Manual", @"CVT", nil];
        }
        if(indexPath.row == 3)
        {
            [cell.currentSelectionLabel setText:[defaults objectForKey:@"Drive Type Setting"]];
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"DriveType.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"Drive Type:";
            cell.dataArray = [[NSMutableArray alloc] initWithObjects:@"Any", @"4WD", @"AWD", @"FWD", @"RWD", nil];
        }
        if(indexPath.row == 4)
        {
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"Horsepower.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"Horsepower:";
            
            [self determineHorsepower:0];
            
            NSString *hpRange1 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineHorsepower:[NSNumber numberWithInt:0]]], [numberFormatter stringFromNumber: [self determineHorsepower:[NSNumber numberWithInt:100]]], hpUnit];
            NSString *hpRange2 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineHorsepower:[NSNumber numberWithInt:101]]], [numberFormatter stringFromNumber: [self determineHorsepower:[NSNumber numberWithInt:200]]], hpUnit];
            NSString *hpRange3 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineHorsepower:[NSNumber numberWithInt:201]]], [numberFormatter stringFromNumber: [self determineHorsepower:[NSNumber numberWithInt:300]]], hpUnit];
            NSString *hpRange4 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineHorsepower:[NSNumber numberWithInt:301]]], [numberFormatter stringFromNumber: [self determineHorsepower:[NSNumber numberWithInt:400]]], hpUnit];
            NSString *hpRange5 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineHorsepower:[NSNumber numberWithInt:401]]], [numberFormatter stringFromNumber: [self determineHorsepower:[NSNumber numberWithInt:500]]], hpUnit];
            NSString *hpRange6 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineHorsepower:[NSNumber numberWithInt:501]]], [numberFormatter stringFromNumber: [self determineHorsepower:[NSNumber numberWithInt:600]]], hpUnit];
            NSString *hpRange7 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineHorsepower:[NSNumber numberWithInt:601]]], [numberFormatter stringFromNumber: [self determineHorsepower:[NSNumber numberWithInt:700]]], hpUnit];
            NSString *hpRange8 = [NSString stringWithFormat:@"%@+%@", [numberFormatter stringFromNumber: [self determineHorsepower:[NSNumber numberWithInt:700]]], hpUnit];
            
            cell.dataArray = [[NSMutableArray alloc] initWithObjects:@"Any", hpRange1, hpRange2, hpRange3, hpRange4, hpRange5, hpRange6, hpRange7, hpRange8, nil];
            
            NSString *currentSelection = [defaults objectForKey:@"Horsepower Setting"];

            if([currentSelection isEqualToString:@"Any"])
                [cell.currentSelectionLabel setText:@"Any"];
            if([currentSelection isEqualToString:@"0-100 hp"])
                [cell.currentSelectionLabel setText:hpRange1];
            if([currentSelection isEqualToString:@"101-200 hp"])
                [cell.currentSelectionLabel setText:hpRange2];
            if([currentSelection isEqualToString:@"201-300 hp"])
                [cell.currentSelectionLabel setText:hpRange3];
            if([currentSelection isEqualToString:@"301-400 hp"])
                [cell.currentSelectionLabel setText:hpRange4];
            if([currentSelection isEqualToString:@"401-500 hp"])
                [cell.currentSelectionLabel setText:hpRange5];
            if([currentSelection isEqualToString:@"501-600 hp"])
                [cell.currentSelectionLabel setText:hpRange6];
            if([currentSelection isEqualToString:@"601-700 hp"])
                [cell.currentSelectionLabel setText:hpRange7];
            if([currentSelection isEqualToString:@"700+ hp"])
                [cell.currentSelectionLabel setText:hpRange8];
        }
        if(indexPath.row == 5)
        {
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"Torque.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"Torque:";
            
            [self determineTorque:0];
            
            NSString *torqueRange1 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineTorque:[NSNumber numberWithInt:0]]], [numberFormatter stringFromNumber: [self determineTorque:[NSNumber numberWithInt:100]]], torqueUnit];
            NSString *torqueRange2 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineTorque:[NSNumber numberWithInt:101]]], [numberFormatter stringFromNumber: [self determineTorque:[NSNumber numberWithInt:200]]], torqueUnit];
            NSString *torqueRange3 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineTorque:[NSNumber numberWithInt:201]]], [numberFormatter stringFromNumber: [self determineTorque:[NSNumber numberWithInt:300]]], torqueUnit];
            NSString *torqueRange4 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineTorque:[NSNumber numberWithInt:301]]], [numberFormatter stringFromNumber: [self determineTorque:[NSNumber numberWithInt:400]]], torqueUnit];
            NSString *torqueRange5 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineTorque:[NSNumber numberWithInt:401]]], [numberFormatter stringFromNumber: [self determineTorque:[NSNumber numberWithInt:500]]], torqueUnit];
            NSString *torqueRange6 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineTorque:[NSNumber numberWithInt:501]]], [numberFormatter stringFromNumber: [self determineTorque:[NSNumber numberWithInt:600]]], torqueUnit];
            NSString *torqueRange7 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineTorque:[NSNumber numberWithInt:601]]], [numberFormatter stringFromNumber: [self determineTorque:[NSNumber numberWithInt:700]]], torqueUnit];
            NSString *torqueRange8 = [NSString stringWithFormat:@"%@+%@", [numberFormatter stringFromNumber: [self determineTorque:[NSNumber numberWithInt:700]]], torqueUnit];
            
            cell.dataArray = [[NSMutableArray alloc] initWithObjects:@"Any", torqueRange1, torqueRange2, torqueRange3, torqueRange4, torqueRange5, torqueRange6, torqueRange7, torqueRange8, nil];
            
            NSString *currentSelection = [defaults objectForKey:@"Torque Setting"];
            
            if([currentSelection isEqualToString:@"Any"])
                [cell.currentSelectionLabel setText:@"Any"];
            if([currentSelection isEqualToString:@"0-100 lb·ft"])
                [cell.currentSelectionLabel setText:torqueRange1];
            if([currentSelection isEqualToString:@"101-200 lb·ft"])
                [cell.currentSelectionLabel setText:torqueRange2];
            if([currentSelection isEqualToString:@"201-300 lb·ft"])
                [cell.currentSelectionLabel setText:torqueRange3];
            if([currentSelection isEqualToString:@"301-400 lb·ft"])
                [cell.currentSelectionLabel setText:torqueRange4];
            if([currentSelection isEqualToString:@"401-500 lb·ft"])
                [cell.currentSelectionLabel setText:torqueRange5];
            if([currentSelection isEqualToString:@"501-600 lb·ft"])
                [cell.currentSelectionLabel setText:torqueRange6];
            if([currentSelection isEqualToString:@"601-700 lb·ft"])
                [cell.currentSelectionLabel setText:torqueRange7];
            if([currentSelection isEqualToString:@"700+ lb·ft"])
                [cell.currentSelectionLabel setText:torqueRange8];
        }
        if(indexPath.row == 6)
        {
            [cell.currentSelectionLabel setText:[defaults objectForKey:@"0-60 Time Setting"]];
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"0-60.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"0-60 Time:";
            cell.dataArray = [[NSMutableArray alloc] initWithObjects:@"Any", @"2-3.0 secs", @"3.1-4.0 secs", @"4.1-5.0 secs", @"5.1-5.5 secs", @"5.6-6.0 secs", @"6.1-6.5 secs", @"6.6-7.0 secs", @"7.1-8.0 secs", @"8.1-9.0 secs", @"9.1-10.0 secs", @"10.1+ secs", nil];
        }
        if(indexPath.row == 7)
        {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
            [numberFormatter setMaximumFractionDigits:1];
            
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"FuelEconomy.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"Fuel Economy:";
            
            [self determineFuelEconomy:0];
            
            NSString *feRange1 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineFuelEconomy:[NSNumber numberWithInt:0]]], [numberFormatter stringFromNumber: [self determineFuelEconomy:[NSNumber numberWithInt:10]]], fuelEconomyUnit];
            NSString *feRange2 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineFuelEconomy:[NSNumber numberWithInt:11]]], [numberFormatter stringFromNumber: [self determineFuelEconomy:[NSNumber numberWithInt:20]]], fuelEconomyUnit];
            NSString *feRange3 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineFuelEconomy:[NSNumber numberWithInt:21]]], [numberFormatter stringFromNumber: [self determineFuelEconomy:[NSNumber numberWithInt:30]]], fuelEconomyUnit];
            NSString *feRange4 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineFuelEconomy:[NSNumber numberWithInt:31]]], [numberFormatter stringFromNumber: [self determineFuelEconomy:[NSNumber numberWithInt:40]]], fuelEconomyUnit];
            NSString *feRange5 = [NSString stringWithFormat:@"%@-%@%@", [numberFormatter stringFromNumber: [self determineFuelEconomy:[NSNumber numberWithInt:41]]], [numberFormatter stringFromNumber: [self determineFuelEconomy:[NSNumber numberWithInt:50]]], fuelEconomyUnit];
            NSString *feRange6 = [NSString stringWithFormat:@"%@+%@", [numberFormatter stringFromNumber: [self determineFuelEconomy:[NSNumber numberWithInt:51]]], fuelEconomyUnit];
            
            cell.dataArray = [[NSMutableArray alloc] initWithObjects:@"Any", feRange1, feRange2, feRange3, feRange4, feRange5, feRange6, nil];
            
            NSString *currentSelection = [defaults objectForKey:@"Fuel Economy Setting"];
            
            if([currentSelection isEqualToString:@"Any"])
                [cell.currentSelectionLabel setText:@"Any"];
            if([currentSelection isEqualToString:@"0-10 MPG US"])
                [cell.currentSelectionLabel setText:feRange1];
            if([currentSelection isEqualToString:@"11-20 MPG US"])
                [cell.currentSelectionLabel setText:feRange2];
            if([currentSelection isEqualToString:@"21-30 MPG US"])
                [cell.currentSelectionLabel setText:feRange3];
            if([currentSelection isEqualToString:@"31-40 MPG US"])
                [cell.currentSelectionLabel setText:feRange4];
            if([currentSelection isEqualToString:@"41-50 MPG US"])
                [cell.currentSelectionLabel setText:feRange5];
            if([currentSelection isEqualToString:@"51+ MPG US"])
                [cell.currentSelectionLabel setText:feRange6];
        }
        if(indexPath.row == 8)
        {
            [cell.settingImage setAlpha:0];
            [cell.settingLabel setAlpha:0];
            [cell.currentSelectionLabel setAlpha:0];
            [cell.viewCarLabel setAlpha:1];
            
            [cell.viewCarLabel setText:[NSString stringWithFormat:@"View Results (%lu)", (unsigned long)alteredModelSpecsArray.count]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if([indexPath isEqual:[NSIndexPath indexPathForRow:2 inSection:0]])
    {
        [self performSegueWithIdentifier:@"pushModels" sender:self];
        return;
    }
    
    if([indexPath isEqual:[NSIndexPath indexPathForRow:8 inSection:1]])
    {
        [self performSegueWithIdentifier:@"pushSpecs" sender:self];
        return;
    }
    
    [tableView beginUpdates];
    
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        self.expandedIndexPath = nil;
    } else {
        self.expandedIndexPath = indexPath;
    }
    
    [tableView endUpdates];
    
    SearchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [cell scrollTableToCurrentIndex];
    });
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

-(void)closeCellTable
{
    [self.tableView beginUpdates];
    self.expandedIndexPath = nil;
    [self.tableView endUpdates];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(void)switchMake
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentMakeString = [defaults objectForKey:@"Make Setting"];
    
    NSPredicate *MakePredicate = [NSPredicate predicateWithFormat:@"CarMake == %@", currentMakeString];
    alteredModelArray = [[NSMutableArray alloc]initWithArray:[fullModelArray filteredArrayUsingPredicate:MakePredicate]];
    
    NSPredicate *actualCarPredicate = [NSPredicate predicateWithFormat:@"CarEngine.length > 0"];
    alteredModelArray = [[NSMutableArray alloc]initWithArray:[alteredModelArray filteredArrayUsingPredicate:actualCarPredicate]];
    
    Model *defaultModel = [[Model alloc]initWithCarPrimaryKey:[NSNumber numberWithInt:0] andCarMake:@"" andCarModel:@"Any" andCarYearsMade:@"" andCarMSRP:[NSNumber numberWithInt:0] andCarPrice:@"" andCarPriceLow:[NSNumber numberWithInt:0] andCarPriceHigh:[NSNumber numberWithInt:0] andCarEngine:@"" andCarTransmission:@"" andCarDriveType:@"" andCarHorsepower:@"" andCarHorsepowerLow:[NSNumber numberWithInt:0] andCarHorsepowerHigh:[NSNumber numberWithInt:0] andCarTorque:@"" andCarTorqueLow:[NSNumber numberWithInt:0] andCarTorqueHigh:[NSNumber numberWithInt:0] andCarZeroToSixty:@"" andCarZeroToSixtyLow:[NSNumber numberWithInt:0]  andCarZeroToSixtyHigh:[NSNumber numberWithInt:0] andCarTopSpeed:@"" andCarTopSpeedLow:@"" andCarTopSpeedHigh:@"" andCarWeight:@"" andCarWeightLow:[NSNumber numberWithInt:0] andCarWeightHigh:[NSNumber numberWithInt:0] andCarFuelEconomy:@"" andCarFuelEconomyLow:[NSNumber numberWithInt:0] andCarFuelEconomyHigh:[NSNumber numberWithInt:0] andCarImageURL:@"" andCarWebsite:@"" andCarFullName:@"Any" andCarExhaust:@"" andCarHTML:@"" andShouldFlipEvox:@"" andisClass:[NSNumber numberWithInt:0] andisSubclass:[NSNumber numberWithInt:0] andisModel:[NSNumber numberWithInt:0] andisStyle:[NSNumber numberWithInt:0] andCarClass:@"" andCarSubclass:@"" andCarStyle:@"" andRemoveLogo:[NSNumber numberWithInteger:0] andZoomScale:[NSNumber numberWithInt:0]];
    [alteredModelArray insertObject:defaultModel atIndex:0];
    
    if([currentMakeString isEqualToString:@"Any"])
        alteredModelArray = fullModelArray;
}

-(void)updateSpecsResults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //PricePredicates
    NSString *currentPriceSelection = [defaults objectForKey:@"Price Setting"];
    NSPredicate *PricePredicate;
    
    if ([currentPriceSelection isEqualToString:@"Any"])
        PricePredicate = [NSPredicate predicateWithFormat:@"CarEngine.length > 0"];
        
    if ([currentPriceSelection isEqualToString:@"$0-5,000"])
        PricePredicate = [NSPredicate predicateWithFormat:@"(CarPriceHigh<=5000 OR CarPriceLow<=5000) AND NOT (CarPrice CONTAINS %@)", @"N/A"];
        
    if ([currentPriceSelection isEqualToString:@"$5,000-10,000"])
        PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=5000 AND CarPriceHigh<=10000) OR (CarPriceLow>=5000 AND CarPriceLow<=10000))"];
        
    if ([currentPriceSelection isEqualToString:@"$10,000-20,000"])
        PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=10000 AND CarPriceHigh<=20000) OR (CarPriceLow>=10000 AND CarPriceLow<=20000))"];
        
    if ([currentPriceSelection isEqualToString:@"$20,000-30,000"])
        PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=20000 AND CarPriceHigh<=30000) OR (CarPriceLow>=20000 AND CarPriceLow<=30000))"];
        
    if ([currentPriceSelection isEqualToString:@"$30,000-40,000"])
        PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=30000 AND CarPriceHigh<=40000) OR (CarPriceLow>=30000 AND CarPriceLow<=40000))"];
        
    if ([currentPriceSelection isEqualToString:@"$40,000-50,000"])
        PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=40000 AND CarPriceHigh<=50000) OR (CarPriceLow>=40000 AND CarPriceLow<=50000))"];
        
    if ([currentPriceSelection isEqualToString:@"$50,000-65,000"])
        PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=50000 AND CarPriceHigh<=65000) OR (CarPriceLow>=50000 AND CarPriceLow<=65000))"];
        
    if ([currentPriceSelection isEqualToString:@"$65,000-80,000"])
        PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=65000 AND CarPriceHigh<=80000) OR (CarPriceLow>=65000 AND CarPriceLow<=80000))"];
        
    if ([currentPriceSelection isEqualToString:@"$80,000-100,000"])
        PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=80000 AND CarPriceHigh<=100000) OR (CarPriceLow>=80000 AND CarPriceLow<=100000))"];
        
    if ([currentPriceSelection isEqualToString:@"$100,000-150,000"])
        PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=100000 AND CarPriceHigh<=150000) OR (CarPriceLow>=100000 AND CarPriceLow<=150000))"];
        
    if ([currentPriceSelection isEqualToString:@"$150,000-200,000"])
        PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=150000 AND CarPriceHigh<=200000) OR (CarPriceLow>=150000 AND CarPriceLow<=200000))"];
        
    if ([currentPriceSelection isEqualToString:@"$200,000-500,000"])
        PricePredicate = [NSPredicate predicateWithFormat:@"((CarPriceHigh>=200000 AND CarPriceHigh<=500000) OR (CarPriceLow>=200000 AND CarPriceLow<=500000))"];
        
    if ([currentPriceSelection isEqualToString:@"$500,000+"])
        PricePredicate = [NSPredicate predicateWithFormat:@"(CarPriceHigh>=500000 OR CarPriceLow>=500000)"];
    
    //EnginePredicates
    NSString *currentEngineSelection = [defaults objectForKey:@"Engine Setting"];
    NSPredicate *EnginePredicate;
    
    if ([currentEngineSelection isEqualToString:@"Any"])
        EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine.length > 0"];
            
    if ([currentEngineSelection isEqualToString:@"Electric/Hybrid"])
        EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine CONTAINS %@", @"Electric"];
        
    if ([currentEngineSelection isEqualToString:@"3 Cylinder"])
        EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine CONTAINS %@", @"l3"];
            
    if ([currentEngineSelection isEqualToString:@"4 Cylinder"])
        EnginePredicate = [NSPredicate predicateWithFormat:@"(CarEngine CONTAINS %@) OR (CarEngine CONTAINS %@)", @"Flat-4", @"l4"];
    
    if ([currentEngineSelection isEqualToString:@"5 Cylinder"])
        EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine CONTAINS %@", @"l5"];
    
    if ([currentEngineSelection isEqualToString:@"6 Cylinder"])
        EnginePredicate = [NSPredicate predicateWithFormat:@"(CarEngine CONTAINS %@) OR (CarEngine CONTAINS %@) OR (CarEngine CONTAINS %@)", @"Flat-6", @"V6", @"l6"];
            
    if ([currentEngineSelection isEqualToString:@"8 Cylinder"])
        EnginePredicate = [NSPredicate predicateWithFormat:@"(CarEngine CONTAINS %@) OR (CarEngine CONTAINS %@)", @"V8", @"l8"];
            
    if ([currentEngineSelection isEqualToString:@"10 Cylinder"])
        EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine CONTAINS %@", @"V10"];
            
    if ([currentEngineSelection isEqualToString:@"12 Cylinder"])
        EnginePredicate = [NSPredicate predicateWithFormat:@"(CarEngine CONTAINS %@) OR (CarEngine CONTAINS %@) OR (CarEngine CONTAINS %@)", @"F12", @"V12", @"W12"];
            
    if ([currentEngineSelection isEqualToString:@"16 Cylinder"])
        EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine CONTAINS %@", @"W16"];
            
    if ([currentEngineSelection isEqualToString:@"Rotary"])
        EnginePredicate = [NSPredicate predicateWithFormat:@"CarEngine CONTAINS %@", @"Rotary"];
    
    //TransmissionPredicates
    NSString *currentTransmissionSelection = [defaults objectForKey:@"Transmission Setting"];
    NSPredicate *TransmissionPredicate;
    
    if ([currentTransmissionSelection isEqualToString:@"Any"])
        TransmissionPredicate = [NSPredicate predicateWithFormat:@"CarEngine.length > 0"];
            
    if ([currentTransmissionSelection isEqualToString:@"Automatic"])
        TransmissionPredicate = [NSPredicate predicateWithFormat:@"CarTransmission CONTAINS %@", @"Automatic"];
    
    if ([currentTransmissionSelection isEqualToString:@"Manual"])
        TransmissionPredicate = [NSPredicate predicateWithFormat:@"CarTransmission CONTAINS %@", @"Manual"];
    
    if ([currentTransmissionSelection isEqualToString:@"CVT"])
        TransmissionPredicate = [NSPredicate predicateWithFormat:@"CarTransmission CONTAINS %@", @"CVT"];

    //DriveTypePredicates
    NSString *currentDriveTypeSelection = [defaults objectForKey:@"Drive Type Setting"];
    NSPredicate *DriveTypePredicate;
    
    if ([currentDriveTypeSelection isEqualToString:@"Any"])
        DriveTypePredicate = [NSPredicate predicateWithFormat:@"CarEngine.length > 0"];
 
    if ([currentDriveTypeSelection isEqualToString:@"4WD"])
        DriveTypePredicate = [NSPredicate predicateWithFormat:@"CarDriveType CONTAINS %@", @"4WD"];
    
    if ([currentDriveTypeSelection isEqualToString:@"AWD"])
        DriveTypePredicate = [NSPredicate predicateWithFormat:@"CarDriveType CONTAINS %@",@"AWD"];
    
    if ([currentDriveTypeSelection isEqualToString:@"FWD"])
        DriveTypePredicate = [NSPredicate predicateWithFormat:@"CarDriveType CONTAINS %@", @"FWD"];
    
    if ([currentDriveTypeSelection isEqualToString:@"RWD"])
        DriveTypePredicate = [NSPredicate predicateWithFormat:@"CarDriveType CONTAINS %@", @"RWD"];
    
    //HorsepowerPredicates
    NSString *currentHorsepowerSelection = [defaults objectForKey:@"Horsepower Setting"];
    NSPredicate *HorsepowerPredicate;
    
    
    if ([currentHorsepowerSelection isEqualToString:@"Any"])
        HorsepowerPredicate = [NSPredicate predicateWithFormat:@"CarEngine.length > 0"];

    if ([currentHorsepowerSelection isEqualToString:@"0-100 hp"])
        HorsepowerPredicate = [NSPredicate predicateWithFormat:@"(CarHorsepowerHigh<=100 OR CarHorsepowerLow<=100) AND NOT (CarHorsepower CONTAINS %@)", @"N/A"];

    if ([currentHorsepowerSelection isEqualToString:@"101-200 hp"])
        HorsepowerPredicate = [NSPredicate predicateWithFormat:@"((CarHorsepowerLow>=101 AND CarHorsepowerLow<=200) OR (CarHorsepowerHigh>=101 AND CarHorsepowerHigh<=200))"];

    if ([currentHorsepowerSelection isEqualToString:@"201-300 hp"])
        HorsepowerPredicate = [NSPredicate predicateWithFormat:@"((CarHorsepowerLow>=201 AND CarHorsepowerLow<=300) OR (CarHorsepowerHigh>=201 AND CarHorsepowerHigh<=300))"];

    if ([currentHorsepowerSelection isEqualToString:@"301-400 hp"])
        HorsepowerPredicate = [NSPredicate predicateWithFormat:@"((CarHorsepowerLow>=301 AND CarHorsepowerLow<=400) OR (CarHorsepowerHigh>=301 AND CarHorsepowerHigh<=400))"];

    if ([currentHorsepowerSelection isEqualToString:@"401-500 hp"])
        HorsepowerPredicate = [NSPredicate predicateWithFormat:@"((CarHorsepowerLow>=401 AND CarHorsepowerLow<=500) OR (CarHorsepowerHigh>=401 AND CarHorsepowerHigh<=500))"];

    if ([currentHorsepowerSelection isEqualToString:@"501-600 hp"])
        HorsepowerPredicate = [NSPredicate predicateWithFormat:@"((CarHorsepowerLow>=501 AND CarHorsepowerLow<=600) OR (CarHorsepowerHigh>=501 AND CarHorsepowerHigh<=600))"];

    if ([currentHorsepowerSelection isEqualToString:@"601-700 hp"])
        HorsepowerPredicate = [NSPredicate predicateWithFormat:@"((CarHorsepowerLow>=601 AND CarHorsepowerLow<=700) OR (CarHorsepowerHigh>=601 AND CarHorsepowerHigh<=700))"];

    if ([currentHorsepowerSelection isEqualToString:@"700+ hp"])
        HorsepowerPredicate = [NSPredicate predicateWithFormat:@"(CarHorsepowerLow>=701 OR CarHorsepowerHigh>=701)"];
    
    //TorquePredicates
    NSString *currentTorqueSelection = [defaults objectForKey:@"Torque Setting"];
    NSPredicate *TorquePredicate;
    
    if ([currentTorqueSelection isEqualToString:@"Any"])
        TorquePredicate = [NSPredicate predicateWithFormat:@"CarEngine.length > 0"];
    
    if ([currentTorqueSelection isEqualToString:@"0-100 lb·ft"])
        TorquePredicate = [NSPredicate predicateWithFormat:@"(CarTorqueHigh<=100 OR CarTorqueLow<=100) AND NOT (CarTorque CONTAINS %@)", @"N/A"];
    
    if ([currentTorqueSelection isEqualToString:@"101-200 lb·ft"])
        TorquePredicate = [NSPredicate predicateWithFormat:@"((CarTorqueLow>=101 AND CarTorqueLow<=200) OR (CarTorqueHigh>=101 AND CarTorqueHigh<=200))"];
    
    if ([currentTorqueSelection isEqualToString:@"201-300 lb·ft"])
        TorquePredicate = [NSPredicate predicateWithFormat:@"((CarTorqueLow>=201 AND CarTorqueLow<=300) OR (CarTorqueHigh>=201 AND CarTorqueHigh<=300))"];
    
    if ([currentTorqueSelection isEqualToString:@"301-400 lb·ft"])
        TorquePredicate = [NSPredicate predicateWithFormat:@"((CarTorqueLow>=301 AND CarTorqueLow<=400) OR (CarTorqueHigh>=301 AND CarTorqueHigh<=400))"];
    
    if ([currentTorqueSelection isEqualToString:@"401-500 lb·ft"])
        TorquePredicate = [NSPredicate predicateWithFormat:@"((CarTorqueLow>=401 AND CarTorqueLow<=500) OR (CarTorqueHigh>=401 AND CarTorqueHigh<=500))"];
    
    if ([currentTorqueSelection isEqualToString:@"501-600 lb·ft"])
        TorquePredicate = [NSPredicate predicateWithFormat:@"((CarTorqueLow>=501 AND CarTorqueLow<=600) OR (CarTorqueHigh>=501 AND CarTorqueHigh<=600))"];
    
    if ([currentTorqueSelection isEqualToString:@"601-700 lb·ft"])
        TorquePredicate = [NSPredicate predicateWithFormat:@"((CarTorqueLow>=601 AND CarTorqueLow<=700) OR (CarTorqueHigh>=601 AND CarTorqueHigh<=700))"];
    
    if ([currentTorqueSelection isEqualToString:@"700+ lb·ft"])
        TorquePredicate = [NSPredicate predicateWithFormat:@"(CarTorqueLow>=701 OR CarTorqueHigh>=701)"];
    
    //0-60Predicates
    NSString *currentZT60Selection = [defaults objectForKey:@"0-60 Time Setting"];
    NSPredicate *ZeroToSixtyPredicate;
    
    if ([currentZT60Selection isEqualToString:@"Any"])
        ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"CarEngine.length > 0"];
 
    if ([currentZT60Selection isEqualToString:@"2-3.0 secs"])
        ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"(CarZeroToSixtyLow<=3 Or CarZeroToSixtyHigh<=3) AND NOT (CarZeroToSixty CONTAINS %@)", @"N/A"];
 
    if ([currentZT60Selection isEqualToString:@"3.1-4.0 secs"])
        ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=3.1 AND CarZeroToSixtyLow<=4) OR (CarZeroToSixtyHigh>=3.1 AND CarZeroToSixtyHigh<=4))"];

    if ([currentZT60Selection isEqualToString:@"4.1-5.0 secs"])
        ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=4.1 AND CarZeroToSixtyLow<=5) OR (CarZeroToSixtyHigh>=4.1 AND CarZeroToSixtyHigh<=5))"];

    if ([currentZT60Selection isEqualToString:@"5.1-5.5 secs"])
        ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=5.1 AND CarZeroToSixtyLow<=5.5) OR (CarZeroToSixtyHigh>=5.1 AND CarZeroToSixtyHigh<=5.5))"];
 
    if ([currentZT60Selection isEqualToString:@"5.6-6.0 secs"])
        ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=5.6 AND CarZeroToSixtyLow<=6) OR (CarZeroToSixtyHigh>=5.6 AND CarZeroToSixtyHigh<=6))"];
 
    if ([currentZT60Selection isEqualToString:@"6.1-6.5 secs"])
        ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=6.1 AND CarZeroToSixtyLow<=6.5) OR (CarZeroToSixtyHigh>=6.1 AND CarZeroToSixtyHigh<=6.5))"];

    if ([currentZT60Selection isEqualToString:@"6.6-7.0 secs"])
        ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=6.6 AND CarZeroToSixtyLow<=7.0) OR (CarZeroToSixtyHigh>=6.6 AND CarZeroToSixtyHigh<=7.0))"];

    if ([currentZT60Selection isEqualToString:@"7.1-8.0 secs"])
        ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=7.1 AND CarZeroToSixtyLow<=8.0) OR (CarZeroToSixtyHigh>=7.1 AND CarZeroToSixtyHigh<=8.0))"];

    if ([currentZT60Selection isEqualToString:@"8.1-9.0 secs"])
        ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=8.1 AND CarZeroToSixtyLow<=9.0) OR (CarZeroToSixtyHigh>=8.1 AND CarZeroToSixtyHigh<=9.0))"];

    if ([currentZT60Selection isEqualToString:@"9.1-10.0 secs"])
        ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"((CarZeroToSixtyLow>=9.1 AND CarZeroToSixtyLow<=10.0) OR (CarZeroToSixtyHigh>=9.1 AND CarZeroToSixtyHigh<=10.0))"];

    if ([currentZT60Selection isEqualToString:@"10.1+ secs"])
        ZeroToSixtyPredicate = [NSPredicate predicateWithFormat:@"(CarZeroToSixtyLow>=10.1 Or CarZeroToSixtyHigh>=10.1)"];
    
    //FEPredicates
    NSString *currentFESelection = [defaults objectForKey:@"Fuel Economy Setting"];
    NSPredicate *FEPredicate;
    
    if ([currentFESelection isEqualToString:@"Any"])
        FEPredicate = [NSPredicate predicateWithFormat:@"CarEngine.length > 0"];

    if ([currentFESelection isEqualToString:@"0-10 MPG US"])
        FEPredicate = [NSPredicate predicateWithFormat:@"(CarFuelEconomyLow<=10 Or CarFuelEconomyHigh<=10) AND NOT (CarFuelEconomy CONTAINS %@)", @"N/A"];

    if ([currentFESelection isEqualToString:@"11-20 MPG US"])
        FEPredicate = [NSPredicate predicateWithFormat:@"((CarFuelEconomyLow>=11 AND CarFuelEconomyLow<=20) OR (CarFuelEconomyHigh>=11 AND CarFuelEconomyHigh<=20))"];

    if ([currentFESelection isEqualToString:@"21-30 MPG US"])
        FEPredicate = [NSPredicate predicateWithFormat:@"((CarFuelEconomyLow>=21 AND CarFuelEconomyLow<=30) OR (CarFuelEconomyHigh>=21 AND CarFuelEconomyHigh<=30))"];

    if ([currentFESelection isEqualToString:@"31-40 MPG US"])
        FEPredicate = [NSPredicate predicateWithFormat:@"((CarFuelEconomyLow>=31 AND CarFuelEconomyLow<=40) OR (CarFuelEconomyHigh>=31 AND CarFuelEconomyHigh<=40))"];

    if ([currentFESelection isEqualToString:@"41-50 MPG US"])
        FEPredicate = [NSPredicate predicateWithFormat:@"((CarFuelEconomyLow>=41 AND CarFuelEconomyLow<=50) OR (CarFuelEconomyHigh>=41 AND CarFuelEconomyHigh<=50))"];

    if ([currentFESelection isEqualToString:@"51+ MPG US"])
        FEPredicate = [NSPredicate predicateWithFormat:@"(CarFuelEconomyLow>=51 OR CarFuelEconomyHigh>=51)"];
    
    alteredModelSpecsArray = [[fullModelArray filteredArrayUsingPredicate:PricePredicate] mutableCopy];
    alteredModelSpecsArray = [[alteredModelSpecsArray filteredArrayUsingPredicate:EnginePredicate] mutableCopy];
    alteredModelSpecsArray = [[alteredModelSpecsArray filteredArrayUsingPredicate:TransmissionPredicate] mutableCopy];
    alteredModelSpecsArray = [[alteredModelSpecsArray filteredArrayUsingPredicate:DriveTypePredicate] mutableCopy];
    alteredModelSpecsArray = [[alteredModelSpecsArray filteredArrayUsingPredicate:HorsepowerPredicate] mutableCopy];
    alteredModelSpecsArray = [[alteredModelSpecsArray filteredArrayUsingPredicate:TorquePredicate] mutableCopy];
    alteredModelSpecsArray = [[alteredModelSpecsArray filteredArrayUsingPredicate:ZeroToSixtyPredicate] mutableCopy];
    alteredModelSpecsArray = [[alteredModelSpecsArray filteredArrayUsingPredicate:FEPredicate] mutableCopy];
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
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(kr.) Danish Krone"])
        {
            exchangeName = @"USD/DKK";
            currencySymbol = @"(kr.)";
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
        if([[defaults objectForKey:@"Horsepower"] isEqualToString:@"PS"])
        {
            convertedHP = [NSNumber numberWithDouble:([convertedHP doubleValue]*1.01387)];
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

-(NSNumber *)determineTorque:(NSNumber *)lbFootValue
{
    NSNumber *convertedTorque = lbFootValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![[defaults objectForKey:@"Torque"] isEqualToString:@"lb·ft"])
    {
        if([[defaults objectForKey:@"Torque"] isEqualToString:@"N·m"])
        {
            convertedTorque = [NSNumber numberWithDouble:([convertedTorque doubleValue]*1.3558179)];
            torqueUnit = @" N·m";
        }
    }
    else
        torqueUnit = @" lb·ft";
    
    return convertedTorque;
}

- (UIImage*)resizeImage:(UIImage*)aImage reSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [aImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) makeAppDelModelArray;
{
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    fullModelArray = [[NSMutableArray alloc]init];
    [fullModelArray addObjectsFromArray:appdel.modelArray];
    NSPredicate *actualCarPredicate = [NSPredicate predicateWithFormat:@"CarEngine.length > 0"];
    fullModelArray = [[NSMutableArray alloc]initWithArray:[fullModelArray filteredArrayUsingPredicate:actualCarPredicate]];
    
    Model *defaultModel = [[Model alloc]initWithCarPrimaryKey:[NSNumber numberWithInt:0] andCarMake:@"" andCarModel:@"Any" andCarYearsMade:@"" andCarMSRP:[NSNumber numberWithInt:0] andCarPrice:@"" andCarPriceLow:[NSNumber numberWithInt:0] andCarPriceHigh:[NSNumber numberWithInt:0] andCarEngine:@"" andCarTransmission:@"" andCarDriveType:@"" andCarHorsepower:@"" andCarHorsepowerLow:[NSNumber numberWithInt:0] andCarHorsepowerHigh:[NSNumber numberWithInt:0] andCarTorque:@"" andCarTorqueLow:[NSNumber numberWithInt:0] andCarTorqueHigh:[NSNumber numberWithInt:0] andCarZeroToSixty:@"" andCarZeroToSixtyLow:[NSNumber numberWithInt:0]  andCarZeroToSixtyHigh:[NSNumber numberWithInt:0] andCarTopSpeed:@"" andCarTopSpeedLow:@"" andCarTopSpeedHigh:@"" andCarWeight:@"" andCarWeightLow:[NSNumber numberWithInt:0] andCarWeightHigh:[NSNumber numberWithInt:0] andCarFuelEconomy:@"" andCarFuelEconomyLow:[NSNumber numberWithInt:0] andCarFuelEconomyHigh:[NSNumber numberWithInt:0] andCarImageURL:@"" andCarWebsite:@"" andCarFullName:@"Any" andCarExhaust:@"" andCarHTML:@"" andShouldFlipEvox:@"" andisClass:[NSNumber numberWithInt:0] andisSubclass:[NSNumber numberWithInt:0] andisModel:[NSNumber numberWithInt:0] andisStyle:[NSNumber numberWithInt:0] andCarClass:@"" andCarSubclass:@"" andCarStyle:@"" andRemoveLogo:[NSNumber numberWithInteger:0] andZoomScale:[NSNumber numberWithInt:0]];
    [fullModelArray insertObject:defaultModel atIndex:0];
    
    alteredModelArray = [[NSMutableArray alloc]initWithArray:fullModelArray];
    alteredModelSpecsArray = [[NSMutableArray alloc]initWithArray:fullModelArray];
    [alteredModelSpecsArray removeObjectAtIndex:0];
    
    makeArray = [[NSMutableArray alloc]init];
    [makeArray addObjectsFromArray:appdel.makeimageArray];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushModels"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        Model *selectedModel = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"Model Setting"]];
        if([selectedModel.CarModel isEqualToString:@"Any"])
        {
            NSMutableArray *searchArray = [[NSMutableArray alloc]initWithArray:alteredModelArray];
            [searchArray removeObjectAtIndex:0];
            [[segue destinationViewController] getsearcharray:searchArray];
        }
        else
        {
            NSMutableArray *selectedModelArray = [[NSMutableArray alloc]initWithObjects:selectedModel, nil];
            [[segue destinationViewController] getsearcharray:selectedModelArray];
        }
    }
    
    if ([[segue identifier] isEqualToString:@"pushSpecs"])
    {
        [[segue destinationViewController] getsearcharray:alteredModelSpecsArray];
    }
}

@end
