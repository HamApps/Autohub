//
//  HomeViewController.m
//  Carhub
//
//  Created by Christopher Clark on 10/17/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import "HomeViewController.h"
#import "CarViewCell.h"
#import "News.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "NewsCell.h"
#import "HomepageCell.h"
#import "HomePageMedia.h"
#import "Race.h"
#import "RaceResultsViewController.h"
#import "Model.h"
#import "DetailViewController.h"
#import "ViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize newsArray, mediaArray, carOfTheDayArray, latestArticlesArray, latestVideosArray, racesArray, addedCarsArray, CarOfTheDayCV, LatestArticlesCV, LatestVideosCV, RacesCV, AddedCarsCV, currentRaceID, currentCarOfTheDay, refreshControl, CarOfTheDayLabel, Spec1Label, Spec2Label, COTDSpec1, COTDSpec2, pageControl1, pageControl2, pageControl3, pageControl4, pageControl5, ScrollView, TableView, selectedNews;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self SetUpCardViews];
    [self SetScrollDirections];
    
    [ScrollView setScrollEnabled:YES];
    ScrollView.contentSize = CGSizeMake(320, 2200);
    self.ScrollView.alwaysBounceVertical = TRUE;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.barButton.target = self.revealViewController;
    self.barButton.action = @selector(revealToggle:);
    self.title = @"Home";
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //Load Data
    [self makeAppDelNewsArray];
    [self makeAppDelMediaArray];
    [self splitMediaArray];
    [self setupRefreshControl];
    
    pageControl1.numberOfPages =  carOfTheDayArray.count;
    pageControl2.numberOfPages =  latestArticlesArray.count;
    pageControl3.numberOfPages =  latestVideosArray.count;
    pageControl4.numberOfPages =  racesArray.count;
    pageControl5.numberOfPages =  addedCarsArray.count;
}

#pragma - Collection View Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == CarOfTheDayCV)
        return carOfTheDayArray.count;
    if (collectionView == LatestArticlesCV)
        return latestArticlesArray.count;
    if (collectionView == LatestVideosCV)
        return latestVideosArray.count;
    if (collectionView == RacesCV)
        return racesArray.count;
    if (collectionView == AddedCarsCV)
        return addedCarsArray.count;
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomepageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
    HomePageMedia * mediaObject;
    
    NSLog(@"Indexpath.item: %lu", (long)indexPath.item);
    
    if (collectionView == self.CarOfTheDayCV)
    {
        CarOfTheDayCV.clipsToBounds = YES;
        cell.CellImageView.clipsToBounds = YES;
        NSString *imageURL = [carOfTheDayArray objectAtIndex:indexPath.item];
            [cell.CellImageView setImageWithURL:[NSURL URLWithString:imageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                             [cell.CellImageView setAlpha:0.0];
                                             [UIImageView animateWithDuration:0.5 animations:^{
                                                 [cell.CellImageView setAlpha:1.0];
                                             }];
                                         }
                    usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

        return cell;
    }
    if (collectionView == self.LatestArticlesCV)
        mediaObject = [latestArticlesArray objectAtIndex:indexPath.item];
    if (collectionView == self.LatestVideosCV)
        mediaObject = [latestVideosArray objectAtIndex:indexPath.item];
    if (collectionView == self.RacesCV)
        mediaObject = [racesArray objectAtIndex:indexPath.item];
    if (collectionView == self.AddedCarsCV)
        mediaObject = [addedCarsArray objectAtIndex:indexPath.item];

    cell.layer.borderColor=[UIColor clearColor].CGColor;
    
    //Load and fade image
    [cell.CellImageView setImageWithURL:[NSURL URLWithString:mediaObject.ImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                     [cell.CellImageView setAlpha:0.0];
                                     [UIImageView animateWithDuration:0.5 animations:^{
                                         [cell.CellImageView setAlpha:1.0];
                                     }];
                                 }
            usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    cell.DescriptionLabel.text=mediaObject.Description;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == CarOfTheDayCV)
    {
        HomePageMedia* media = [carOfTheDayArray objectAtIndex:indexPath.row];
        AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        for (int i = 0; i < appdel.modelArray.count; i++)
        {
            Model *currentModel = [appdel.modelArray objectAtIndex:i];
            if([currentModel.CarFullName isEqualToString:media.Description])
                currentCarOfTheDay = currentModel;
        }
        [self performSegueWithIdentifier:@"pushDetailView" sender:self];
    }

    if (collectionView == RacesCV)
    {
        HomePageMedia* media = [racesArray objectAtIndex:indexPath.row];
        AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        for (int i = 0; i < appdel.raceListArray.count; i++)
        {
            Race *currentRace = [appdel.raceListArray objectAtIndex:i];
            if([currentRace.RaceName isEqualToString:media.Description])
                currentRaceID = currentRace;
        }
        NSString *raceType = currentRaceID.RaceType;
        
        if([raceType isEqualToString:@"Formula 1"])
            [self performSegueWithIdentifier:@"pushFormula1" sender:self];
        if([raceType isEqualToString:@"Nascar"])
            [self performSegueWithIdentifier:@"pushNascar" sender:self];
        if([raceType isEqualToString:@"IndyCar"])
            [self performSegueWithIdentifier:@"pushIndyCar" sender:self];
        if([raceType isEqualToString:@"FIA World Endurance Championships"])
            [self performSegueWithIdentifier:@"pushFIA" sender:self];
        if([raceType isEqualToString:@"WRC"])
            [self performSegueWithIdentifier:@"pushWRC" sender:self];
    }
    
    if (collectionView == LatestArticlesCV)
    {
        HomePageMedia* media = [latestArticlesArray objectAtIndex:indexPath.row];
        AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        for (int i = 0; i < appdel.newsArray.count; i++)
        {
            News *currentNews = [appdel.newsArray objectAtIndex:i];
            if([currentNews.NewsImageURL isEqualToString:media.ImageURL])
                selectedNews = currentNews;
        }
        [self performSegueWithIdentifier:@"pushArticle" sender:self];
    }
    
    if (collectionView == LatestVideosCV)
    {
        HomePageMedia* media = [latestVideosArray objectAtIndex:indexPath.row];
        AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        for (int i = 0; i < appdel.newsArray.count; i++)
        {
            News *currentNews = [appdel.newsArray objectAtIndex:i];
            if([currentNews.NewsImageURL isEqualToString:media.ImageURL])
                selectedNews = currentNews;
        }
        [self performSegueWithIdentifier:@"pushVideo" sender:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CarOfTheDayCV.frame.size.width;
    float currentPage = CarOfTheDayCV.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f))
        pageControl1.currentPage = currentPage + 1;
    else
        pageControl1.currentPage = currentPage;
    
    pageWidth = LatestArticlesCV.frame.size.width;
    currentPage = LatestArticlesCV.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f))
        pageControl2.currentPage = currentPage + 1;
    else
        pageControl2.currentPage = currentPage;
    
    pageWidth = LatestArticlesCV.frame.size.width;
    currentPage = LatestArticlesCV.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f))
        pageControl3.currentPage = currentPage + 1;
    else
        pageControl3.currentPage = currentPage;
    
    pageWidth = RacesCV.frame.size.width;
    currentPage = RacesCV.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f))
        pageControl4.currentPage = currentPage + 1;
    else
        pageControl4.currentPage = currentPage;
    
    pageWidth = AddedCarsCV.frame.size.width;
    currentPage = AddedCarsCV.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f))
        pageControl5.currentPage = currentPage + 1;
    else
        pageControl5.currentPage = currentPage;
}

#pragma mark - Refresh Control Setup

- (void)setupRefreshControl
{
    // Adding UIRefreshControl Programatically
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    // Setup the loading view, which will hold the moving graphics
    self.refreshLoadingView = [[UIView alloc] initWithFrame:self.refreshControl.bounds];
    self.refreshLoadingView.backgroundColor = [UIColor clearColor];
    
    // Setup the color view, which will display the rainbowed background
    self.refreshColorView = [[UIView alloc] initWithFrame:self.refreshControl.bounds];
    self.refreshColorView.backgroundColor = [UIColor clearColor];
    self.refreshColorView.alpha = 0.30;
    
    // Create the graphic image views
    self.compass_background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LittleCaliper.png"]];
    self.compass_spinner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LittleWheel3.png"]];
    
    // Add the graphics to the loading view
    [self.refreshLoadingView addSubview:self.compass_background];
    [self.refreshLoadingView addSubview:self.compass_spinner];
    
    // Clip so the graphics don't stick out
    self.refreshLoadingView.clipsToBounds = YES;
    
    // Hide the original spinner icon
    self.refreshControl.tintColor = [UIColor clearColor];
    
    // Add the loading and colors views to our refresh control
    [self.refreshControl addSubview:self.refreshColorView];
    [self.refreshControl addSubview:self.refreshLoadingView];
    
    // Initalize flags
    self.isRefreshIconsOverlap = NO;
    self.isRefreshAnimating = NO;
    
    // When activated, invoke our refresh function
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    [self.ScrollView addSubview:self.refreshControl];
}

- (void)reloadData;
{
    [self refresh:self];
}

- (void)refresh:(id)sender{
    // -- DO SOMETHING AWESOME (... or just wait 3 seconds) --
    // This is where you'll make requests to an API, reload data, or process information
    
    if (self.refreshControl.isRefreshing && !self.isRefreshAnimating) {
        [self animateRefreshView];
    }
    
    double delayInSeconds = 0.25;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    //dispatch_async(dispatch_get_main_queue(), ^{
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
        AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appdel retrievenewsData];
        [appdel retrieveHomePageData];
        
        [mediaArray removeAllObjects];
        [mediaArray addObjectsFromArray:appdel.homePageArray];
        
        [self splitMediaArray];
        
        [self.CarOfTheDayCV reloadData];
        [self.CarOfTheDayCV numberOfItemsInSection:carOfTheDayArray.count];
        [self.LatestArticlesCV reloadData];
        [self.LatestArticlesCV numberOfItemsInSection:latestArticlesArray.count];
        [self.LatestVideosCV reloadData];
        [self.LatestVideosCV numberOfItemsInSection:latestVideosArray.count];
        [self.RacesCV reloadData];
        [self.RacesCV numberOfItemsInSection:racesArray.count];
        [self.AddedCarsCV reloadData];
        [self.AddedCarsCV numberOfItemsInSection:addedCarsArray.count];
        
        // When done requesting/reloading/processing invoke endRefreshing, to close the control
        [self.refreshControl endRefreshing];
    });
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Get the current size of the refresh controller
    CGRect refreshBounds = self.refreshControl.bounds;
    
    // Distance the table has been pulled >= 0
    CGFloat pullDistance = MAX(0.0, -self.refreshControl.frame.origin.y);
    
    // Half the width of the table
    CGFloat midX = self.view.frame.size.width / 2.0;
    
    // Calculate the width and height of our graphics
    CGFloat compassHeight = self.compass_background.bounds.size.height;
    CGFloat compassHeightHalf = compassHeight / 2.0;
    
    CGFloat compassWidth = self.compass_background.bounds.size.width;
    CGFloat compassWidthHalf = compassWidth / 2.0;
    
    CGFloat spinnerHeight = self.compass_spinner.bounds.size.height;
    CGFloat spinnerHeightHalf = spinnerHeight / 2.0;
    
    CGFloat spinnerWidth = self.compass_spinner.bounds.size.width;
    CGFloat spinnerWidthHalf = spinnerWidth / 2.0;
    
    // Calculate the pull ratio, between 0.0-1.0
    CGFloat pullRatio = MIN( MAX(pullDistance, 0.0), 100.0) / 100.0;
    
    // Set the Y coord of the graphics, based on pull distance
    CGFloat compassY = pullDistance / 2.0 - compassHeightHalf;
    CGFloat spinnerY = pullDistance / 2.0 - spinnerHeightHalf;
    
    // Calculate the X coord of the graphics, adjust based on pull ratio
    CGFloat compassX = (midX + compassWidthHalf) - (compassWidth * pullRatio);
    CGFloat spinnerX = (midX - spinnerWidth - spinnerWidthHalf) + (spinnerWidth * pullRatio);
    
    // When the compass and spinner overlap, keep them together
    if (fabsf(compassX - spinnerX) < 1.0) {
        self.isRefreshIconsOverlap = YES;
    }
    
    // If the graphics have overlapped or we are refreshing, keep them together
    if (self.isRefreshIconsOverlap || self.refreshControl.isRefreshing) {
        compassX = midX - compassWidthHalf;
        spinnerX = midX - spinnerWidthHalf;
    }
    
    // Set the graphic's frames
    CGRect compassFrame = self.compass_background.frame;
    compassFrame.origin.x = compassX;
    compassFrame.origin.y = compassY;
    
    CGRect spinnerFrame = self.compass_spinner.frame;
    spinnerFrame.origin.x = spinnerX;
    spinnerFrame.origin.y = spinnerY;
    
    self.compass_background.frame = compassFrame;
    self.compass_spinner.frame = spinnerFrame;
    
    // Set the encompassing view's frames
    refreshBounds.size.height = pullDistance;
    
    self.refreshColorView.frame = refreshBounds;
    self.refreshLoadingView.frame = refreshBounds;
    
    // If we're refreshing and the animation is not playing, then play the animation
    if (self.refreshControl.isRefreshing && !self.isRefreshAnimating) {
        [self animateRefreshView];
    }
}

- (void)animateRefreshView
{
    // Background color to loop through for our color view
    NSArray *colorArray = @[[UIColor redColor],[UIColor blueColor],[UIColor purpleColor],[UIColor cyanColor],[UIColor orangeColor],[UIColor magentaColor]];
    static int colorIndex = 0;
    
    // Flag that we are animating
    self.isRefreshAnimating = YES;
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         // Rotate the spinner by M_PI_2 = PI/2 = 90 degrees
                         [self.compass_spinner setTransform:CGAffineTransformRotate(self.compass_spinner.transform, M_PI_2)];
                         
                         // Change the background color
                         self.refreshColorView.backgroundColor = [colorArray objectAtIndex:colorIndex];
                         colorIndex = (colorIndex + 1) % colorArray.count;
                     }
                     completion:^(BOOL finished) {
                         // If still refreshing, keep spinning, else reset
                         if (self.refreshControl.isRefreshing) {
                             [self animateRefreshView];
                         }else{
                             [self resetAnimation];
                         }
                     }];
}

- (void)resetAnimation
{
    // Reset our flags and background color
    self.isRefreshAnimating = NO;
    self.isRefreshIconsOverlap = NO;
    self.refreshColorView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Navigation

- (void) forwardToDidSelect: (UITapGestureRecognizer *) tap
{
    [self performSegueWithIdentifier:@"pushNewsDetailView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushArticle"])
    {
        [[segue destinationViewController] getNews:selectedNews];
    }
    if ([[segue identifier] isEqualToString:@"pushVideo"])
    {
        [[segue destinationViewController] getNews:selectedNews];
    }
    if ([[segue identifier] isEqualToString:@"pushDetailView"])
    {
        [[segue destinationViewController] getModel:currentCarOfTheDay];
    }
    if ([[segue identifier] isEqualToString:@"pushFormula1"] || [[segue identifier] isEqualToString:@"pushNascar"] || [[segue identifier] isEqualToString:@"pushIndyCar"] || [[segue identifier] isEqualToString:@"pushFIA"] || [[segue identifier] isEqualToString:@"pushWRC"])
    {
        [[segue destinationViewController] getRaceResults:currentRaceID];
    }
}

-(void)SetUpCardViews
{
    [self.CardView setAlpha:1];
    self.CardView.layer.masksToBounds = NO;
    self.CardView.layer.cornerRadius = 5;
    self.CardView.layer.shadowOffset = CGSizeMake(-.2f, .2f);
    self.CardView.layer.shadowRadius = 1.5;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.CardView.bounds];
    self.CardView.layer.shadowPath = path.CGPath;
    self.CardView.layer.shadowOpacity = .75;
    self.CardView.backgroundColor = [UIColor whiteColor];
}

-(void)SetScrollDirections
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)[self.CarOfTheDayCV collectionViewLayout];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
     layout = (UICollectionViewFlowLayout *)[self.LatestArticlesCV collectionViewLayout];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

#pragma mark - Initial Loading Methods

- (void)makeAppDelNewsArray;
{
    newsArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [newsArray addObjectsFromArray:appdel.newsArray];
}

- (void)makeAppDelMediaArray;
{
    mediaArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [mediaArray addObjectsFromArray:appdel.homePageArray];
}

- (void)splitMediaArray;
{
    self.carOfTheDayArray = [[NSMutableArray alloc]init];
    self.latestArticlesArray = [[NSMutableArray alloc]init];
    self.latestVideosArray = [[NSMutableArray alloc]init];
    self.racesArray = [[NSMutableArray alloc]init];
    self.addedCarsArray = [[NSMutableArray alloc]init];

    for (int i = 0;i<mediaArray.count;i++)
    {
        HomePageMedia *currentMedia = [mediaArray objectAtIndex:i];
        if ([currentMedia.MediaType isEqualToString:@"Car"])
        {
            AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            for (int i = 0; i < appdel.modelArray.count; i++)
            {
                Model *currentModel = [appdel.modelArray objectAtIndex:i];
                if([currentModel.CarFullName isEqualToString:currentMedia.Description])
                    currentCarOfTheDay = currentModel;
            }
            COTDSpec1 = currentMedia.SpecLabel1;
            COTDSpec2 = currentMedia.SpecLabel2;
            CarOfTheDayLabel.text = currentMedia.Description;
            Spec1Label.text = currentMedia.SpecLabel1;
            Spec2Label.text = currentMedia.SpecLabel2;
            [carOfTheDayArray addObject:currentMedia.ImageURL];
            [carOfTheDayArray addObject:currentMedia.ImageURL2];
            [carOfTheDayArray addObject:currentMedia.ImageURL3];
            [carOfTheDayArray addObject:currentMedia.ImageURL4];
            NSLog(@"carofthedayarray: %@", carOfTheDayArray);
        }
        if ([currentMedia.MediaType isEqualToString:@"Article"])
            [latestArticlesArray addObject:currentMedia];
        if ([currentMedia.MediaType isEqualToString:@"Video"])
            [latestVideosArray addObject:currentMedia];
        if ([currentMedia.MediaType isEqualToString:@"Race"])
            [racesArray addObject:currentMedia];
        if ([currentMedia.MediaType isEqualToString:@"New Car"])
            [addedCarsArray addObject:currentMedia];
    }
}

@end
