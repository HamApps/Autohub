//
//  PageItemController.m
//  Carhub
//
//  Created by Christoper Clark on 11/6/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import "PageItemController.h"
#import "UIImageView+WebCache.h"
#import "RaceResultCell.h"
#import "RaceResult.h"
#import "AppDelegate.h"
#import "HomepageCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "ImageViewController.h"
#import <Google/Analytics.h>

@interface PageItemController ()

@end

@implementation PageItemController
@synthesize itemIndex, imageURLString, currentRaceResultsArray, resultsTableView, currentRace, raceImagesCV, currentRaceImagesArray, pageControl1, raceNameLabel, upperView, initialCVFrame, initialPageControlFrame, refreshControl, shouldKeepSpinning;

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Race Results";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupRefreshControl];
    
    [resultsTableView setDelegate:self];
    [resultsTableView setDataSource:self];
    //self.resultsTableView.separatorColor = [UIColor clearColor];
    
    pageControl1.numberOfPages = currentRaceImagesArray.count;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)[self.raceImagesCV collectionViewLayout];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [raceNameLabel setText:[currentRace.RaceName stringByAppendingString:@": Results"]];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:raceNameLabel.text];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    initialCVFrame = raceImagesCV.frame;
    initialPageControlFrame = pageControl1.frame;
    
    [resultsTableView sendSubviewToBack:upperView];
    [resultsTableView sendSubviewToBack:pageControl1];
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
    [self.resultsTableView addSubview:self.refreshControl];
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
        
        for(int i=0; i<appdel.raceListArray.count; i++)
        {
            Race *race = [appdel.raceListArray objectAtIndex:i];
            if([race.RaceName isEqualToString:currentRace.RaceName])
                currentRace = race;
        }
        
        [currentRaceResultsArray removeAllObjects];
        [currentRaceImagesArray removeAllObjects];
        
        [self getRaceResults:currentRace];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //update ui elements and methods for the view
            
            [self getRaceResults:currentRace];
            [self.resultsTableView reloadData];
            [self.raceImagesCV reloadData];
            pageControl1.numberOfPages = currentRaceImagesArray.count;
            
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
    if(scrollView == self.resultsTableView)
    {
        CGPoint currentPosition = resultsTableView.contentOffset;
        
        if(currentPosition.y >= -64)
        {
            [raceImagesCV setFrame:CGRectMake(0, (currentPosition.y+64)/2, initialCVFrame.size.width, initialCVFrame.size.height)];
            [pageControl1 setFrame:CGRectMake(initialPageControlFrame.origin.x, initialPageControlFrame.origin.y +(currentPosition.y+64)/2, initialPageControlFrame.size.width, initialPageControlFrame.size.height)];
        }
        if(currentPosition.y < -64)
        {
            [raceImagesCV setFrame:CGRectMake(0, 0, initialCVFrame.size.width, initialCVFrame.size.height)];
            [pageControl1 setFrame:CGRectMake(initialPageControlFrame.origin.x, initialPageControlFrame.origin.y, initialPageControlFrame.size.width, initialPageControlFrame.size.height)];
        }
    }
    
    // Get the current size of the refresh controller
    CGRect refreshBounds = self.refreshControl.bounds;
    
    // Distance the table has been pulled >= 0
    CGFloat pullDistance = MAX(0.0, -self.refreshControl.frame.origin.y);
    
    // Half the width of the table
    CGFloat midX = self.resultsTableView.frame.size.width / 2.0;
    
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
    if ([resultsTableView respondsToSelector:@selector(setSeparatorInset:)])
        [resultsTableView setSeparatorInset:UIEdgeInsetsZero];
    if ([resultsTableView respondsToSelector:@selector(setLayoutMargins:)])
        [resultsTableView setLayoutMargins:UIEdgeInsetsZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return currentRaceResultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RaceCell";
    RaceResultCell *cell = (RaceResultCell *)[self.resultsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil)
    {
        cell = [[RaceResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    RaceResult * raceResultObject;
    
    raceResultObject = [currentRaceResultsArray objectAtIndex:indexPath.row];
    
    cell.positionLabel.text = [raceResultObject.Position stringValue];
    cell.driverLabel.text = raceResultObject.Driver;
    cell.teamLabel.text = raceResultObject.Team;
    cell.CarLabel.text = raceResultObject.Car;
    cell.timeLabel.text = raceResultObject.Time;
    cell.bestLapTimeLabel.text = raceResultObject.BestLapTime;
    cell.RaceClass.text = raceResultObject.RaceClass;
    cell.carNumberLabel.text = raceResultObject.CarNumber;
    cell.driverLabel2.text = raceResultObject.Driver2;
    cell.driverLabel3.text = raceResultObject.Driver3;
    cell.categoryLabel.text = raceResultObject.Category;
    
    if([raceResultObject.Excluded isEqualToString:@""])
    {
        NSString *urlString = [[raceResultObject.Position stringValue] stringByAppendingString:@".png"];
        [cell.RankImageView setImage:[self resizeImage:[UIImage imageNamed:urlString] reSize:cell.RankImageView.frame.size]];
    }
    else
    {
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"MavenProRegular" size:28],
                                     NSParagraphStyleAttributeName:paragraphStyle};
        [cell.RankImageView setImage:[self imageFromString:@"-" attributes:attributes size:cell.RankImageView.frame.size]];
    }

    return cell;
}

- (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma - Collection View Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return currentRaceImagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomepageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
    NSString *imageURL = [self.currentRaceImagesArray objectAtIndex:indexPath.row];
    
    NSURL *URL;
    if([imageURL containsString:@"raceno"])
        URL = [NSURL URLWithString:imageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/raceimage.php"]];
    else
        URL = [NSURL URLWithString:imageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
    
    [cell.CellImageView setImageWithURL:URL
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                         [cell.CellImageView setAlpha:0.0];
                                         [UIImageView animateWithDuration:0.5 animations:^{
                                             [cell.CellImageView setAlpha:1.0];
                                             [cell.CellImageView setImage:[self resizeImage:cell.CellImageView.image reSize:cell.CellImageView.frame.size]];
                                         }];
                                     }
            usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    imageURLString = [self.currentRaceImagesArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"pushImageView" sender:self];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = raceImagesCV.frame.size.width;
    float currentPage = raceImagesCV.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f))
        pageControl1.currentPage = currentPage + 1;
    else
        pageControl1.currentPage = currentPage;
}

- (UIImage*)resizeImage:(UIImage*)aImage reSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [aImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pushImageView"])
    {
        [[segue destinationViewController] getArticleImage:imageURLString];
    }
}

#pragma mark -
#pragma mark Content

-(void)getRaceResults:(id)currentRaceID
{
    currentRace = currentRaceID;
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    currentRaceResultsArray = [[NSMutableArray alloc]init];
        
    for(int i=0; i<appdel.raceResultsArray.count; i++)
    {
        RaceResult *raceResult = [appdel.raceResultsArray objectAtIndex:i];
        
        if([raceResult.RaceID isEqualToString:currentRace.RaceName])
            [currentRaceResultsArray addObject:[appdel.raceResultsArray objectAtIndex:i]];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Position" ascending:YES];
    [currentRaceResultsArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    currentRaceImagesArray = [[NSMutableArray alloc]init];
    [currentRaceImagesArray removeAllObjects];

    if (![currentRace.ResultsImageURL1 isEqualToString:@""])
        [currentRaceImagesArray addObject:currentRace.ResultsImageURL1];
    if (![currentRace.ResultsImageURL2 isEqualToString:@""])
        [currentRaceImagesArray addObject:currentRace.ResultsImageURL2];
    if (![currentRace.ResultsImageURL3 isEqualToString:@""])
        [currentRaceImagesArray addObject:currentRace.ResultsImageURL3];
    if (![currentRace.ResultsImageURL4 isEqualToString:@""])
        [currentRaceImagesArray addObject:currentRace.ResultsImageURL4];
}

@end
