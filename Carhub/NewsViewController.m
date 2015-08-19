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
#import "NewsCell.h"

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
    
    self.view.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
    self.tableView.separatorColor = [UIColor clearColor];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    News * newsObject;
    newsObject = [newsArray objectAtIndex:indexPath.row];
    
    cell.newsDescription.dataDetectorTypes = UIDataDetectorTypeAll;
    cell.newsDescription.editable = NO;
    cell.newsDescription.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(forwardToDidSelect:)];
    
    cell.tag = indexPath.row;
    [cell.newsDescription addGestureRecognizer: tap];
    
    if (cell == nil) {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
    }
    
    //Load and fade image
    [cell.newsImage sd_setImageWithURL:[NSURL URLWithString:newsObject.NewsImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/newsimage.php"]]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                [cell.newsImage setAlpha:0.0];
                                [UIImageView animateWithDuration:.5 animations:^{
                                [cell.newsImage setAlpha:1.0];
                                }];
                            }];
    cell.newsDescription.text = newsObject.NewsTitle;
    
    int height = [UIScreen mainScreen].bounds.size.height;
    if (height == 667)
        cell.cardView.frame = CGRectMake(10, 5, 355, 200);
    else if (height == 736)
        cell.cardView.frame = CGRectMake(10, 5, 394, 200);
    else
        cell.cardView.frame = CGRectMake(10, 5, 300, 200);
    
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
