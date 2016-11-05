//
//  SettingsViewController.m
//  Carhub
//
//  Created by Christoper Clark on 6/23/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsCell.h"
#import "SWRevealViewController.h"
#import <Google/Analytics.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize expandedIndexPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Settings"];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:self.title];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    self.barButton.target = self.revealViewController;
    self.barButton.action = @selector(revealToggle:);
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeCellTable) name:@"closeCellTable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToTerms) name:@"pushTerms" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToPrivacy) name:@"pushPrivacy" object:nil];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 6;
    if(section == 1)
        return 1;
    if(section == 2)
        return 1;
    if(section == 3)
        return 1;
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"Units";
            break;
        case 1:
            return @"Interface";
            break;
        case 2:
            return @"Terms";
            break;
        case 3:
            return @"Contact";
            break;
        default:
            return @"";
    }
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
            tempLabel.text=@"Units";
            break;
        case 1:
            tempLabel.text=@"Interface";
            break;
        case 2:
            tempLabel.text=@"Terms";
            break;
        case 3:
            tempLabel.text=@"Contact";
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
            return 176;
        if([indexPath isEqual:[NSIndexPath indexPathForRow:2 inSection:0]])
            return 132;
        if([indexPath isEqual:[NSIndexPath indexPathForRow:3 inSection:0]])
            return 132;
        if([indexPath isEqual:[NSIndexPath indexPathForRow:4 inSection:0]])
            return 132;
        if([indexPath isEqual:[NSIndexPath indexPathForRow:5 inSection:0]])
            return 176;
        if([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:1]])
            return 132;
        if([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:2]])
            return 132;
        return 100;
    }
    return 44.0; // Normal height
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingsCell";
    SettingsCell *cell = (SettingsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[SettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.settingLabel setFont:[UIFont fontWithName:@"MavenProRegular" size:17]];
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"Price.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"Currency";
            cell.dataArray = [NSMutableArray arrayWithObjects:@"($) US Dollar", @"($) Argentinian Peso", @"($) Australian Dollar", @"(R$) Brazilian Real", @"(£) British Pound", @"($) Canadian Dollar", @"($) Chilean Peso", @"(¥) Chinese Yuan", @"(Kč) Czech Koruna", @"(kr.) Danish Krone", @"(RD$) Dominican Peso", @"(£) Egyptian Pound", @"(€) European Euro", @"($) Hong Kong Dollar", @"(Ft) Hungarian Forint", @"(INR) Indian Rupee", @"(Rp) Indonesian Rupiah", @"(₪) Israeli New Shekel", @"(¥) Japanese Yen", @"(RM) Malaysian Ringgit", @"($) Mexican Peso", @"($) New Zealand Dollar", @"(kr) Norwegian Krone", @"(Rs) Pakistani Rupee", @"(zł) Polish Zloty", @"(руб) Russian Ruble", @"($) Singapore Dollar", @"(R) South African Rand", @"(₩) South Korean Won", @"(kr) Swedish Kronor", @"(CHF) Swiss Franc", @"(NT$) Taiwanese New Dollar", @"(฿) Thai Baht", @"(TRY) Turkish New Lira", @"(AED) UAE Dirham", nil];
        }
        if(indexPath.row == 1)
        {
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"Horsepower.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"Horsepower";
            cell.dataArray = [NSMutableArray arrayWithObjects:@"hp", @"PS", @"kW", nil];
        }
        if(indexPath.row == 2)
        {
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"Torque.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"Torque";
            cell.dataArray = [NSMutableArray arrayWithObjects:@"lb·ft", @"N·m", nil];
        }
        if(indexPath.row == 3)
        {
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"TopSpeed.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"Top Speed";
            cell.dataArray = [NSMutableArray arrayWithObjects:@"MPH", @"km/h", nil];
        }
        if(indexPath.row == 4)
        {
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"Weight.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"Weight";
            cell.dataArray = [NSMutableArray arrayWithObjects:@"lbs", @"kg", nil];
        }
        if(indexPath.row == 5)
        {
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"FuelEconomy.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"Fuel Economy";
            cell.dataArray = [NSMutableArray arrayWithObjects:@"MPG US", @"MPG UK", @"L/100 km", nil];
        }
    }
    if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"Makes.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"Makes Layout Preference";
            cell.dataArray = [NSMutableArray arrayWithObjects: @"Horizontal Scroll", @"Grid", nil];
        }
    }
    if(indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"TermsandCondition.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"Terms and Conditions";
            cell.dataArray = [NSMutableArray arrayWithObjects: @"Terms and Conditions", @"Privacy Policy", nil];
        }
    }
    if(indexPath.section == 3)
    {
        if(indexPath.row == 0)
        {
            [cell.settingImage setImage:[self resizeImage:[UIImage imageNamed:@"Contact.png"] reSize:cell.settingImage.frame.size]];
            cell.settingLabel.text = @"Send Us An Email";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:3]])
    {
        [self performSegueWithIdentifier:@"pushDispute" sender:self];
        return;
    }
    
    [tableView beginUpdates];
    
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        self.expandedIndexPath = nil;
    } else {
        self.expandedIndexPath = indexPath;
    }
    
    [tableView endUpdates];
    
    SettingsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [cell scrollTableToCurrentIndex];
    });
    //[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

-(void)closeCellTable
{
    [self.tableView beginUpdates];
    self.expandedIndexPath = nil;
    [self.tableView endUpdates];
}

- (UIImage*)resizeImage:(UIImage*)aImage reSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [aImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Navigation

-(void)pushToTerms
{
    [self performSegueWithIdentifier:@"pushTerms" sender:self];
}

-(void)pushToPrivacy
{
    [self performSegueWithIdentifier:@"pushPrivacy" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushDispute"])
        [segue destinationViewController];
    if ([[segue identifier] isEqualToString:@"pushTerms"])
        [segue destinationViewController];
    if ([[segue identifier] isEqualToString:@"pushPrivacy"])
        [segue destinationViewController];
}

@end
