//
//  SettingsCell.m
//  Carhub
//
//  Created by Christoper Clark on 6/23/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "SettingsCell.h"
#import "SettingsViewController.h"

@implementation SettingsCell
@synthesize dataArray, cellTableView;

- (void)awakeFromNib {
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
    cellTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain]; //create tableview a
    
    cellTableView.tag = 100;
    cellTableView.delegate = self;
    cellTableView.dataSource = self;
    [self addSubview:cellTableView]; // add it cell
    cellTableView.frame = CGRectMake(0, 44, self.bounds.size.width, self.bounds.size.height-44);//set the frames for tableview
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    [cell.textLabel setFont:[UIFont fontWithName:@"MavenProRegular" size:16]];
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([cell.textLabel.text isEqualToString:[defaults objectForKey:@"Currency"]] || [cell.textLabel.text isEqualToString:[defaults objectForKey:@"Horsepower"]] || [cell.textLabel.text isEqualToString:[defaults objectForKey:@"Torque"]] || [cell.textLabel.text isEqualToString:[defaults objectForKey:@"Top Speed"]] || [cell.textLabel.text isEqualToString:[defaults objectForKey:@"Weight"]] || [cell.textLabel.text isEqualToString:[defaults objectForKey:@"Fuel Economy"]] || [cell.textLabel.text isEqualToString:[defaults objectForKey:@"Makes Layout Preference"]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    SettingsCell *settingsCell = (SettingsCell *)cell.superview.superview.superview;
    if([settingsCell.settingLabel.text isEqual: @"Terms and Conditions"])
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SettingsCell *settingsCell = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([settingsCell.settingLabel.text isEqual: @"Currency"])
    {
        [defaults setObject:cell.textLabel.text forKey:@"Currency"];
        [defaults setObject:@"Any" forKey:@"Price Setting"];
        [defaults setObject:@"Any" forKey:@"Converted Price Setting"];
    }
    if([settingsCell.settingLabel.text isEqual: @"Horsepower"])
    {
        [defaults setObject:cell.textLabel.text forKey:@"Horsepower"];
        [defaults setObject:@"Any" forKey:@"Horsepower Setting"];
        [defaults setObject:@"Any" forKey:@"Converted Horsepower Setting"];
    }
    if([settingsCell.settingLabel.text isEqual: @"Torque"])
    {
        [defaults setObject:cell.textLabel.text forKey:@"Torque"];
        [defaults setObject:@"Any" forKey:@"Torque Setting"];
        [defaults setObject:@"Any" forKey:@"Converted Torque Setting"];
    }
    if([settingsCell.settingLabel.text isEqual: @"Top Speed"])
    {
        [defaults setObject:cell.textLabel.text forKey:@"Top Speed"];
    }
    if([settingsCell.settingLabel.text isEqual: @"Weight"])
    {
        [defaults setObject:cell.textLabel.text forKey:@"Weight"];
    }
    if([settingsCell.settingLabel.text isEqual: @"Fuel Economy"])
    {
        [defaults setObject:cell.textLabel.text forKey:@"Fuel Economy"];
        [defaults setObject:@"Any" forKey:@"Fuel Economy Setting"];
        [defaults setObject:@"Any" forKey:@"Converted Fuel Economy Setting"];
    }
    if([settingsCell.settingLabel.text isEqual: @"Makes Layout Preference"])
    {
        [defaults setObject:cell.textLabel.text forKey:@"Makes Layout Preference"];
    }
    if([settingsCell.settingLabel.text isEqual: @"Terms and Conditions"])
    {
        if(indexPath.row == 0)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushTerms" object:nil];
        if(indexPath.row == 1)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushPrivacy" object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeCellTable" object:nil];
}

-(void)scrollTableToCurrentIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentCurrency = [defaults objectForKey:@"Currency"];
    NSIndexPath *indexToScrollTo;
    for(int i=0; i<dataArray.count; i++)
    {
        if([[dataArray objectAtIndex:i] isEqualToString:currentCurrency])
            indexToScrollTo = [NSIndexPath indexPathForRow:i inSection:0];
    }
    [cellTableView scrollToRowAtIndexPath:indexToScrollTo atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

@end
