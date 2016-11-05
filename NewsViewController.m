//
//  NewsViewController.m
//  Carhub
//
//  Created by Christoper Clark on 12/30/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import "NewsViewController.h"
#import "CarViewCell.h"
#import "News.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "SWRevealViewController.h"
#import "NewsCell.h"
#import "HeadlineCell.h"
#import <Google/Analytics.h>

@interface NewsViewController ()

@end

@implementation NewsViewController
@synthesize newsArray, TableView, refreshControl, selectedNews, selectedCell, selectedHeadlineCell, shouldKeepSpinning, headlineCell, initialHeadlineFrame;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.TableView.separatorColor = [UIColor clearColor];
    
    self.barButton.target = self.revealViewController;
    self.barButton.action = @selector(revealToggle:);
    self.title = @"News";
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:self.title];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [self setupRefreshControl];
    [self makeAppDelNewsArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    if(selectedHeadlineCell != NULL)
    {
        [selectedHeadlineCell.newsImage setAlpha:1];
        [selectedHeadlineCell.newsDescription setAlpha:1];
    }
    
    if(selectedCell != NULL)
    {
        [selectedCell.newsImage setAlpha:1];
        [selectedCell.newsDescription setAlpha:1];
    }
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
    News * newsObject;
    newsObject = [newsArray objectAtIndex:indexPath.row];
    
    if(indexPath.row == 0)
    {
        static NSString *CellIdentifier2 = @"HeadlineCell";
        headlineCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
        initialHeadlineFrame = headlineCell.frame;
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.hidesWhenStopped = YES;
        activityIndicator.color = [UIColor blackColor];
        activityIndicator.center = headlineCell.newsImage.center;
        [headlineCell addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        NSURL *imageURL;
        if([newsObject.NewsImageURL containsString:@"newsno"])
            imageURL = [NSURL URLWithString:newsObject.NewsImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/newsimage.php"]];
        else
            imageURL = [NSURL URLWithString:newsObject.NewsImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
        
        [headlineCell.newsImage sd_setImageWithURL:imageURL
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                          [activityIndicator stopAnimating];
                                          [headlineCell.newsImage setAlpha:0.0];
                                          [UIImageView animateWithDuration:0.5 animations:^{
                                              [headlineCell.newsImage setAlpha:1.0];
                                          }];
                                      }];
        
        headlineCell.newsDescription.text = newsObject.NewsTitle;
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0, headlineCell.frame.size.height-1, self.view.frame.size.width, 0.75f);
        bottomBorder.backgroundColor = ([UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1.0]).CGColor;
        [headlineCell.layer addSublayer:bottomBorder];
        
        return headlineCell;
    }
    
    static NSString *CellIdentifier = @"NewsCell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    [cell cardSetup];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(forwardToDidSelect:)];
    
    cell.tag = indexPath.row;
    [cell.newsDescription addGestureRecognizer: tap];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.color = [UIColor blackColor];
    activityIndicator.center = cell.newsImage.center;
    [cell.cardView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    NSURL *imageURL;
    if([newsObject.NewsImageURL containsString:@"newsno"])
        imageURL = [NSURL URLWithString:newsObject.NewsImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/newsimage.php"]];
    else
        imageURL = [NSURL URLWithString:newsObject.NewsImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
    
    [cell.newsImage sd_setImageWithURL:imageURL
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                      [activityIndicator stopAnimating];
                                      [cell.newsImage setAlpha:0.0];
                                      [UIImageView animateWithDuration:0.5 animations:^{
                                          [cell.newsImage setAlpha:1.0];
                                      }];
                                  }];
    
    cell.newsDescription.text = newsObject.NewsTitle;
    
    cell.layer.zPosition = 1;
    
    return cell;
}

#pragma mark - Refresh Control Setup

- (void)setupRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
    self.refreshLoadingView = [[UIView alloc] initWithFrame:self.refreshControl.frame];
    self.refreshLoadingView.backgroundColor = [UIColor clearColor];
    
    self.compass_background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoadingWheelBrake.png"]];
    self.compass_spinner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoadingWheelWheel.png"]];
    
    [self.refreshLoadingView addSubview:self.compass_background];
    [self.refreshLoadingView addSubview:self.compass_spinner];
    
    self.refreshLoadingView.clipsToBounds = YES;
    
    self.refreshControl.tintColor = [UIColor clearColor];
    
    [self.refreshControl addSubview:self.refreshLoadingView];
    
    self.isRefreshIconsOverlap = NO;
    self.isRefreshAnimating = NO;
    
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    [self.TableView addSubview:self.refreshControl];
}

- (void)reloadData;
{
    [self refresh:self];
}

- (void)refresh:(id)sender
{
    if (self.refreshControl.isRefreshing && !self.isRefreshAnimating)
        [self animateRefreshView];
    
    shouldKeepSpinning = YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];

        //remove objects and update data from arrays that use appdel arrays
        [appdel updateAllData];
        [newsArray removeAllObjects];
        [newsArray addObjectsFromArray:appdel.newsArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //update ui elements and methods for the view
            [self.TableView reloadData];
            
            //[self splitMediaArray];
            
            shouldKeepSpinning = NO;
            [self.refreshControl endRefreshing];
            
            AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if([appdel isInternetConnectionAvailable] == NO)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please check your internet connectivity." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        });
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == TableView)
    {
        CGPoint currentPosition = TableView.contentOffset;
        
        if(currentPosition.y >= -64)
            [headlineCell setFrame:CGRectMake(0, (currentPosition.y+64)/2, initialHeadlineFrame.size.width, initialHeadlineFrame.size.height)];
        
        if(currentPosition.y < -64)
            [headlineCell setFrame:CGRectMake(0, 0, initialHeadlineFrame.size.width, initialHeadlineFrame.size.height)];
        
        [TableView sendSubviewToBack:headlineCell];
    }
    
    // Get the current size of the refresh controller
    CGRect refreshBounds = self.refreshControl.bounds;
    
    // Distance the table has been pulled >= 0
    CGFloat pullDistance = MAX(0.0, -self.refreshControl.frame.origin.y);
    
    // Half the width of the table
    CGFloat midX = self.TableView.frame.size.width / 2.0;
    
    // Calculate the width and height of our graphics
    CGFloat compassHeight = self.compass_background.bounds.size.height;
    CGFloat compassWidth = self.compass_background.bounds.size.width;
    CGFloat compassWidthHalf = compassWidth / 2.0;
    
    CGFloat spinnerHeight = self.compass_spinner.bounds.size.height;
    CGFloat spinnerWidth = self.compass_spinner.bounds.size.width;
    CGFloat spinnerWidthHalf = spinnerWidth / 2.0;
    
    // Calculate the pull ratio, between 0.0-1.0
    CGFloat pullRatio = MIN( MAX(pullDistance, 0.0), 100.0) / 100.0;
    
    // Set the Y coord of the graphics, based on pull distance
    CGFloat compassY = pullDistance - compassHeight;
    CGFloat spinnerY = pullDistance - spinnerHeight;
    
    // Calculate the X coord of the graphics, adjust based on pull ratio
    CGFloat compassX = (midX + compassWidthHalf) - (compassWidth * pullRatio);
    CGFloat spinnerX = (midX - spinnerWidth - spinnerWidthHalf) + (spinnerWidth * pullRatio);
    
    // When the compass and spinner overlap, keep them together
    if (fabs(compassX - spinnerX) < 1.0) {
        self.isRefreshIconsOverlap = YES;
    }
    
    // If the graphics have overlapped or we are refreshing, keep them together
    if (self.isRefreshIconsOverlap || self.refreshControl.isRefreshing)
    {
        compassX = midX - compassWidthHalf;
        spinnerX = midX - spinnerWidthHalf;
        compassY = pullDistance/2 - compassHeight/2;
        spinnerY = pullDistance/2 - spinnerHeight/2;
    }
    
    if(pullDistance >= spinnerHeight)
    {
        compassY = pullDistance/2 - compassHeight/2;
        spinnerY = pullDistance/2 - spinnerHeight/2;
    }
    
    // Set the graphic's frames
    CGRect compassFrame = self.compass_background.frame;
    compassFrame.origin.x = compassX;
    compassFrame.origin.y = compassY;
    
    CGRect spinnerFrame = self.compass_spinner.frame;
    spinnerFrame.origin.x = spinnerX;
    spinnerFrame.origin.y = spinnerY;
    
    // Set the encompassing view's frames
    refreshBounds.size.height = pullDistance;
    
    self.refreshLoadingView.frame = refreshBounds;
    self.compass_background.frame = compassFrame;
    self.compass_spinner.frame = spinnerFrame;
    
    // If we're refreshing and the animation is not playing, then play the animation
    if (self.refreshControl.isRefreshing && !self.isRefreshAnimating)
    [self animateRefreshView];
}

- (void)animateRefreshView
{
    // Flag that we are animating
    self.isRefreshAnimating = YES;
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         // Rotate the spinner by M_PI_2 = PI/2 = 90 degrees
                         [self.compass_spinner setTransform:CGAffineTransformRotate(self.compass_spinner.transform, M_PI_2)];
                     }
                     completion:^(BOOL finished) {
                         // If still refreshing, keep spinning, else reset
                         if (shouldKeepSpinning) {
                             [self animateRefreshView];
                         }else{
                             [self resetAnimation];
                         }
                     }];
}

- (void)resetAnimation
{
    self.isRefreshAnimating = NO;
    self.isRefreshIconsOverlap = NO;
}

#pragma mark - Navigation

- (void) forwardToDidSelect: (UITapGestureRecognizer *) tap
{
    [self performSegueWithIdentifier:@"pushArticle" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushVideo"])
    {
        [[segue destinationViewController] getNews:selectedNews];
    }
    if ([[segue identifier] isEqualToString:@"pushArticle"])
    {
        [[segue destinationViewController] getNews:selectedNews];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    News * object = [newsArray objectAtIndex:indexPath.row];
    selectedNews = object;
    if([object.NewsVideoID isEqualToString:@""])
        [self performSegueWithIdentifier:@"pushArticle" sender:self];
    else
        [self performSegueWithIdentifier:@"pushVideo" sender:self];
    
    if(indexPath.row == 0)
    {
        HeadlineCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.newsImage setAlpha:.5];
        [cell.newsDescription setAlpha:.5];
        selectedHeadlineCell = cell;
    }
    else
    {
        NewsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.newsImage setAlpha:.5];
        [cell.newsDescription setAlpha:.5];
        selectedCell = cell;
    }
}

- (void)makeAppDelNewsArray;
{
    newsArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [newsArray addObjectsFromArray:appdel.newsArray];
}

@end
