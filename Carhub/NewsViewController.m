//
//  NewsViewController.m
//  Carhub
//
//  Created by Christopher Clark on 8/22/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "NewsViewController.h"
#import "CarViewCell.h"
#import "News.h"
#import "NewsDetailViewController.h"
#import "AppDelegate.h"
#import "TestNewsViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SWRevealViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController
@synthesize jsonArray, newsArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    self.title = @"Auto News";
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //Load Data
    [self makeAppDelNewsArray];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    CarViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    News * newsObject;
    newsObject = [newsArray objectAtIndex:indexPath.row];
    
    cell.NewsText.dataDetectorTypes = UIDataDetectorTypeAll;
    cell.NewsText.editable = NO;
    cell.NewsText.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(forwardToDidSelect:)];
    
    cell.tag = indexPath.row;
    [cell.NewsText addGestureRecognizer: tap];
    
    if (cell == nil) {
        cell = [[CarViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
    }
    
    //Load and fade image
    [cell.CarImage sd_setImageWithURL:[NSURL URLWithString:newsObject.NewsImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/newsimage.php"]]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                [cell.CarImage setAlpha:0.0];
                                [UIImageView animateWithDuration:.5 animations:^{
                                [cell.CarImage setAlpha:1.0];
                                }];
                            }];
    cell.NewsText.text = newsObject.NewsTitle;

    //Accessory
    /*
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.layer.borderWidth=1.0f;
    cell.layer.borderColor=[UIColor blackColor].CGColor;
    cell.CarName.layer.borderWidth=1.0f;
    cell.CarName.layer.borderColor=[UIColor whiteColor].CGColor;
    */
    
    return cell;
}

- (void) forwardToDidSelect: (UITapGestureRecognizer *) tap
{
    [self performSegueWithIdentifier:@"pushNewsDetailView" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushNewsDetailView"])
    {
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        
        //Get the object for the selected row
        News * object = [newsArray objectAtIndex:indexPath.row];
        [[segue destinationViewController] getNews:object];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

- (void) makeAppDelNewsArray;
{
    newsArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [newsArray addObjectsFromArray:appdel.newsArray];
}

@end
