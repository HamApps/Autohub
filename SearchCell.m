//
//  SearchCell.m
//  Carhub
//
//  Created by Christoper Clark on 7/18/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "SearchCell.h"
#import "SearchViewController.h"
#import "Model.h"
#import "Make.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "Currency.h"

@implementation SearchCell

@synthesize dataArray, cellTableView;

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    // Initialization code
    cellTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    cellTableView.tag = 100;
    cellTableView.delegate = self;
    cellTableView.dataSource = self;
    [self addSubview:cellTableView];
    cellTableView.frame = CGRectMake(0, 44, self.bounds.size.width, self.bounds.size.height-44);
    //[cellTableView setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
}

//manage datasource and  delegate for submenu tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if(cell == nil)
    {
        cell = [[SearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        
        //[cell setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
        
        cell.cellTableView = nil;
        if([self.settingLabel.text isEqual:@"Make:"])
        {
            cell.settingImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 4, 36, 36)];
            cell.settingLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, cell.frame.size.width-50, 44)];
        }
        else
            cell.settingLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, cell.frame.size.width-15, 44)];

        [cell.settingLabel setFont:[UIFont fontWithName:@"MavenProRegular" size:16]];
        
        [cell addSubview:cell.settingImage];
        [cell addSubview:cell.settingLabel];
    }
    
    if([self.settingLabel.text isEqual:@"Make:"])
    {
        Make *currentMake = [self findMakeWithMakeString:[self.dataArray objectAtIndex:indexPath.row]];
        
        NSURL *imageURL;
        if([currentMake.MakeImageURL containsString:@"carno"])
            imageURL = [NSURL URLWithString:currentMake.MakeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image2.php"]];
        else
            imageURL = [NSURL URLWithString:currentMake.MakeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];
        
        [cell.settingImage sd_setImageWithURL:imageURL
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                 [cell.settingImage setAlpha:0.0];
                                 cell.settingImage.contentMode = UIViewContentModeScaleAspectFit;
                                 [cell.settingImage setImage:[self scaleImage:cell.settingImage.image toSize:cell.settingImage.frame.size]];
                                 [UIImageView animateWithDuration:0.25 animations:^{
                                     [cell.settingImage setAlpha:1.0];
                                 }];
                            }];
    }
    
     if([self.settingLabel.text isEqual:@"Model:"])
    {
        Model *currentModel = [self.dataArray objectAtIndex:indexPath.row];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([[defaults objectForKey:@"Make Setting"] isEqualToString:@"Any"])
            cell.settingLabel.text = currentModel.CarFullName;
        else
        {
            cell.settingLabel.text = currentModel.CarModel;
        }
    }
    else
        cell.settingLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if(([self.settingLabel.text isEqual: @"Make:"] && [cell.settingLabel.text isEqualToString:[defaults objectForKey:@"Make Setting"]]))
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else if([[defaults objectForKey:@"Make Setting"]isEqualToString:@"Any"] && [self.settingLabel.text isEqual: @"Model:"] && [cell.settingLabel.text isEqualToString:([[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"Model Setting"]] CarFullName])])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else if(![[defaults objectForKey:@"Make Setting"]isEqualToString:@"Any"] && [self.settingLabel.text isEqual: @"Model:"] && [cell.settingLabel.text isEqualToString:([[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"Model Setting"]] CarModel])])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else if([self.settingLabel.text isEqual: @"Price:"] && [cell.settingLabel.text isEqualToString:[defaults objectForKey:@"Price Setting"]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else if([self.settingLabel.text isEqual: @"Price:"] && [cell.settingLabel.text isEqualToString:[defaults objectForKey:@"Converted Price Setting"]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else if([self.settingLabel.text isEqual: @"Engine:"] && [cell.settingLabel.text isEqualToString:[defaults objectForKey:@"Engine Setting"]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else if([self.settingLabel.text isEqual: @"Transmission:"] && [cell.settingLabel.text isEqualToString:[defaults objectForKey:@"Transmission Setting"]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else if([self.settingLabel.text isEqual: @"Drive Type:"] && [cell.settingLabel.text isEqualToString:[defaults objectForKey:@"Drive Type Setting"]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else if([self.settingLabel.text isEqual: @"Horsepower:"] && [cell.settingLabel.text isEqualToString:[defaults objectForKey:@"Horsepower Setting"]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else if([self.settingLabel.text isEqual: @"Horsepower:"] && [cell.settingLabel.text isEqualToString:[defaults objectForKey:@"Converted Horsepower Setting"]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else if([self.settingLabel.text isEqual: @"Torque:"] && [cell.settingLabel.text isEqualToString:[defaults objectForKey:@"Torque Setting"]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else if([self.settingLabel.text isEqual: @"Torque:"] && [cell.settingLabel.text isEqualToString:[defaults objectForKey:@"Converted Torque Setting"]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else if([self.settingLabel.text isEqual: @"0-60 Time:"] && [cell.settingLabel.text isEqualToString:[defaults objectForKey:@"0-60 Time Setting"]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else if([self.settingLabel.text isEqual: @"Fuel Economy:"] && [cell.settingLabel.text isEqualToString:[defaults objectForKey:@"Fuel Economy Setting"]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else if([self.settingLabel.text isEqual: @"Fuel Economy:"] && [cell.settingLabel.text isEqualToString:[defaults objectForKey:@"Converted Fuel Economy Setting"]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if([self.settingLabel.text isEqual: @"Make:"])
    {
        [defaults setObject:cell.settingLabel.text forKey:@"Make Setting"];
        
        Model *defaultModel = [[Model alloc]initWithCarPrimaryKey:[NSNumber numberWithInt:0] andCarMake:@"" andCarModel:@"Any" andCarYearsMade:@"" andCarMSRP:[NSNumber numberWithInt:0] andCarPrice:@"" andCarPriceLow:[NSNumber numberWithInt:0] andCarPriceHigh:[NSNumber numberWithInt:0] andCarEngine:@"" andCarTransmission:@"" andCarDriveType:@"" andCarHorsepower:@"" andCarHorsepowerLow:[NSNumber numberWithInt:0] andCarHorsepowerHigh:[NSNumber numberWithInt:0] andCarTorque:@"" andCarTorqueLow:[NSNumber numberWithInt:0] andCarTorqueHigh:[NSNumber numberWithInt:0] andCarZeroToSixty:@"" andCarZeroToSixtyLow:[NSNumber numberWithInt:0]  andCarZeroToSixtyHigh:[NSNumber numberWithInt:0] andCarTopSpeed:@"" andCarTopSpeedLow:@"" andCarTopSpeedHigh:@"" andCarWeight:@"" andCarWeightLow:[NSNumber numberWithInt:0] andCarWeightHigh:[NSNumber numberWithInt:0] andCarFuelEconomy:@"" andCarFuelEconomyLow:[NSNumber numberWithInt:0] andCarFuelEconomyHigh:[NSNumber numberWithInt:0] andCarImageURL:@"" andCarWebsite:@"" andCarFullName:@"Any" andCarExhaust:@"" andCarHTML:@"" andShouldFlipEvox:@"" andisClass:[NSNumber numberWithInt:0] andisSubclass:[NSNumber numberWithInt:0] andisModel:[NSNumber numberWithInt:0] andisStyle:[NSNumber numberWithInt:0] andCarClass:@"" andCarSubclass:@"" andCarStyle:@"" andRemoveLogo:[NSNumber numberWithInteger:0] andZoomScale:[NSNumber numberWithInt:0]];
                
        NSData *defaultModelData = [NSKeyedArchiver archivedDataWithRootObject:defaultModel];
        [defaults setObject:defaultModelData forKey:@"Model Setting"];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"switchMake" object:nil];
    }
    if([self.settingLabel.text isEqual: @"Model:"])
    {
        Model * modelToSave = [dataArray objectAtIndex:indexPath.row];
        NSData *carData = [NSKeyedArchiver archivedDataWithRootObject:modelToSave];
        [defaults setObject:carData forKey:@"Model Setting"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateViewResults" object:nil];
    }
    if([self.settingLabel.text isEqual: @"Price:"])
    {
        NSMutableArray *priceArray = [NSMutableArray arrayWithObjects: @"Any", @"$0-5,000",@"$5,000-10,000",@"$10,000-20,000",@"$20,000-30,000", @"$30,000-40,000", @"$40,000-50,000", @"$50,000-65,000", @"$65,000-80,000", @"$80,000-100,000", @"$100,000-150,000", @"$150,000-200,000", @"$200,000-500,000", @"$500,000+", nil];
        [defaults setObject:[priceArray objectAtIndex:indexPath.row] forKey:@"Price Setting"];
        [defaults setObject:cell.settingLabel.text forKey:@"Converted Price Setting"];
    }
    if([self.settingLabel.text isEqual: @"Engine:"])
    {
        [defaults setObject:cell.settingLabel.text forKey:@"Engine Setting"];
    }
    if([self.settingLabel.text isEqual: @"Transmission:"])
    {
        [defaults setObject:cell.settingLabel.text forKey:@"Transmission Setting"];
    }
    if([self.settingLabel.text isEqual: @"Drive Type:"])
    {
        [defaults setObject:cell.settingLabel.text forKey:@"Drive Type Setting"];
    }
    if([self.settingLabel.text isEqual: @"Horsepower:"])
    {
        NSMutableArray *hpArray = [NSMutableArray arrayWithObjects:@"Any", @"0-100 hp", @"101-200 hp", @"201-300 hp", @"301-400 hp", @"401-500 hp", @"501-600 hp", @"601-700 hp", @"700+ hp", nil];
        [defaults setObject:[hpArray objectAtIndex:indexPath.row] forKey:@"Horsepower Setting"];
        [defaults setObject:cell.settingLabel.text forKey:@"Converted Horsepower Setting"];
    }
    if([self.settingLabel.text isEqual: @"Torque:"])
    {
        NSMutableArray *torqueArray = [NSMutableArray arrayWithObjects:@"Any", @"0-100 lb·ft", @"101-200 lb·ft", @"201-300 lb·ft", @"301-400 lb·ft", @"401-500 lb·ft", @"501-600 lb·ft", @"601-700 lb·ft", @"700+ lb·ft", nil];
        [defaults setObject:[torqueArray objectAtIndex:indexPath.row] forKey:@"Torque Setting"];
        [defaults setObject:cell.settingLabel.text forKey:@"Converted Torque Setting"];
    }
    if([self.settingLabel.text isEqual: @"0-60 Time:"])
    {
        [defaults setObject:cell.settingLabel.text forKey:@"0-60 Time Setting"];
    }
    if([self.settingLabel.text isEqual: @"Fuel Economy:"])
    {
        NSMutableArray *feArray = [NSMutableArray arrayWithObjects:@"Any", @"0-10 MPG US", @"11-20 MPG US", @"21-30 MPG US", @"31-40 MPG US", @"41-50 MPG US", @"51+ MPG US", nil];

        [defaults setObject:[feArray objectAtIndex:indexPath.row] forKey:@"Fuel Economy Setting"];
        [defaults setObject:cell.settingLabel.text forKey:@"Converted Fuel Economy Setting"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSpecsResults" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeCellTable" object:nil];
}

-(void)scrollTableToCurrentIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentSpec = @"";
    
    if([self.settingLabel.text isEqual: @"Make:"])
    {
        currentSpec = [defaults objectForKey:@"Make Setting"];
    }
    if([self.settingLabel.text isEqual: @"Model:"])
    {
        Model *currentModel = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"Model Setting"]];
        
        NSIndexPath *indexToScrollTo;
        for(int i=0; i<dataArray.count; i++)
        {
            Model *model = [dataArray objectAtIndex:i];
            if([model.CarFullName isEqualToString:currentModel.CarFullName])
                indexToScrollTo = [NSIndexPath indexPathForRow:i inSection:0];
        }
            [cellTableView scrollToRowAtIndexPath:indexToScrollTo atScrollPosition:UITableViewScrollPositionTop animated:NO];
        return;
    }
    if([self.settingLabel.text isEqual: @"Price:"])
    {
        currentSpec = [defaults objectForKey:@"Converted Price Setting"];
    }
    if([self.settingLabel.text isEqual: @"Engine:"])
    {
        currentSpec = [defaults objectForKey:@"Engine Setting"];
    }
    if([self.settingLabel.text isEqual: @"Transmission:"])
    {
        currentSpec = [defaults objectForKey:@"Transmission Setting"];
    }
    if([self.settingLabel.text isEqual: @"Drive Type:"])
    {
        currentSpec = [defaults objectForKey:@"Drive Type Setting"];
    }
    if([self.settingLabel.text isEqual: @"Horsepower:"])
    {
        currentSpec = [defaults objectForKey:@"Converted Horsepower Setting"];
    }
    if([self.settingLabel.text isEqual: @"Torque:"])
    {
        currentSpec = [defaults objectForKey:@"Converted Torque Setting"];
    }
    if([self.settingLabel.text isEqual: @"0-60 Time:"])
    {
        currentSpec = [defaults objectForKey:@"0-60 Time Setting"];
    }
    if([self.settingLabel.text isEqual: @"Fuel Economy:"])
    {
        currentSpec = [defaults objectForKey:@"Converted Fuel Economy Setting"];
    }
    
    NSIndexPath *indexToScrollTo;
    for(int i=0; i<dataArray.count; i++)
    {
        if([[dataArray objectAtIndex:i] isEqualToString:currentSpec])
            indexToScrollTo = [NSIndexPath indexPathForRow:i inSection:0];
    }
    [cellTableView scrollToRowAtIndexPath:indexToScrollTo atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(Make *)findMakeWithMakeString:(NSString *)makeString
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    Make *currentMake;
    for(int i=0; i<appDelegate.makeimageArray2.count; i++)
    {
        Make *appdelMake = [appDelegate.makeimageArray2 objectAtIndex:i];
        if([appdelMake.MakeName isEqualToString:makeString])
        {
            currentMake = appdelMake;
            break;
        }
    }
    return currentMake;
}

- (UIImage*)resizeImage:(UIImage*)aImage reSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [aImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    if( image.size.width > image.size.height ) {
        scaleFactor = image.size.width / image.size.height;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.height / scaleFactor;
    }
    else {
        scaleFactor = image.size.height / image.size.width;
        scaledSize.height = newSize.height;
        scaledSize.width = newSize.width / scaleFactor;
    }
    
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end

