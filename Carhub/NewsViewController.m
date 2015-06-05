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

@interface NewsViewController ()

@end

@implementation NewsViewController

@synthesize jsonArray, newsArray, cachedImages;

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
    
    self.title = @"Auto News";
    
    //Load Data
    [self makeAppDelNewsArray];
    self.cachedImages = [[NSMutableDictionary alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    //return newsArray.count;
    return newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"NewsCell";
    CarViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    News * newsObject;
    newsObject = [newsArray objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[CarViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
    }
    
    cell.CarName.text = newsObject.NewsTitle;
    cell.NewsDescription.text = newsObject.NewsDescription;
    
    //Load and fade image
    [cell.CarImage sd_setImageWithURL:[NSURL URLWithString:newsObject.NewsImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/newsimage.php"]]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                [cell.CarImage setAlpha:0.0];
                                [UIImageView animateWithDuration:.5 animations:^{
                                [cell.CarImage setAlpha:1.0];
                                }];
                            }];

    
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
    }
    
}

- (void) makeAppDelNewsArray;
{
    newsArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [newsArray addObjectsFromArray:appdel.newsArray];
    //NSLog(@"appdelarray3: %@", newsArray);
}

@end
