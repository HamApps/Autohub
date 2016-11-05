//
//  NavigationViewController.m
//  Carhub
//
//  Created by Christopher Clark on 6/16/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "NavigationViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "SideBarCell.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController{
    NSArray *menu;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    menu = @[@"Home", @"News", @"Makes", @"Race Results", @"Search", @"Favorites", @"Top Tens", @"Settings"];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
    [revealController panGestureRecognizer];
    
    self.shouldSelectHome = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.revealViewController.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [menu objectAtIndex:indexPath.row];
    SideBarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(indexPath.row == 0)
        [cell.tabImageView setImage:[self resizeImage:[UIImage imageNamed:@"Home.png"] reSize:cell.tabImageView.frame.size]];
    if(indexPath.row == 1)
        [cell.tabImageView setImage:[self resizeImage:[UIImage imageNamed:@"News.png"] reSize:cell.tabImageView.frame.size]];
    if(indexPath.row == 2)
        [cell.tabImageView setImage:[self resizeImage:[UIImage imageNamed:@"Makes.png"] reSize:cell.tabImageView.frame.size]];
    if(indexPath.row == 3)
        [cell.tabImageView setImage:[self resizeImage:[UIImage imageNamed:@"RaceResults.png"] reSize:cell.tabImageView.frame.size]];
    if(indexPath.row == 4)
        [cell.tabImageView setImage:[self resizeImage:[UIImage imageNamed:@"Search.png"] reSize:cell.tabImageView.frame.size]];
    if(indexPath.row == 5)
        [cell.tabImageView setImage:[self resizeImage:[UIImage imageNamed:@"FavoriteFilled.png"] reSize:cell.tabImageView.frame.size]];
    if(indexPath.row == 6)
        [cell.tabImageView setImage:[self resizeImage:[UIImage imageNamed:@"TopTens.png"] reSize:cell.tabImageView.frame.size]];
    if(indexPath.row == 7)
        [cell.tabImageView setImage:[self resizeImage:[UIImage imageNamed:@"Transmission&Settings.png"] reSize:cell.tabImageView.frame.size]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    tableView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    
    if(self.shouldSelectHome && indexPath.row == 0)
    {
        self.shouldSelectHome = NO;
        cell.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    }
    
    return cell;
}

- (UIImage*)resizeImage:(UIImage*)aImage reSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [aImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SideBarCell *homeCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    homeCell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];

    SideBarCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SideBarCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass:[SWRevealViewControllerSegue class]])
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue *)segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc){
            
            UINavigationController* navController = (UINavigationController *)self.revealViewController.frontViewController;
            [navController setViewControllers:@[dvc] animated:NO];
            [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        };
    }
}

@end
