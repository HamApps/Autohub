//
//  RaceTypeViewController.m
//  Carhub
//
//  Created by Christopher Clark on 9/21/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "RaceTypeViewController.h"
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "NewsCell.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "CarViewCell.h"
#import "RaceType.h"
#import "RaceViewController.h"
#import "HomepageCell.h"
#import "HomePageMedia.h"
#import "PageItemController.h"
#import "Race.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "RaceCVCell.h"
#import "AllRacesViewController.h"
#import <Google/Analytics.h>

@interface RaceTypeViewController ()

@end

@implementation RaceTypeViewController
@synthesize raceTypeArray, recentRacesArray, raceTypeID, TableView, RecentRacesCV, RaceClassCV, CardView1, CardView2, pageControl1, pageControl2, recentRace, refreshControl, shouldKeepSpinning, raceListArray, CardView3, raceResultsCircleImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [raceResultsCircleImage setImage:[self resizeImage:[UIImage imageNamed:@"RaceResults.png"] reSize:raceResultsCircleImage.frame.size]];
    [self SetUpCardViews];
    [self SetScrollDirections];
    [self makeAppDelRaceTypeArray];
    [self makeAppDelRecentRacesArray];
    [self setUpNavigationGestures];
    [self setupRefreshControl];
    
    self.barButton.target = self.revealViewController;
    self.barButton.action = @selector(revealToggle:);
    self.view.backgroundColor = [UIColor whiteColor];
    self.TableView.separatorColor = [UIColor clearColor];
    self.title = @"Race Results";
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:self.title];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    pageControl1.numberOfPages = recentRacesArray.count;
    pageControl2.numberOfPages = raceTypeArray.count;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [CardView1 setAlpha:1];
    [CardView2 setAlpha:1];
    [CardView3 setAlpha:1];
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
        
        [raceTypeArray removeAllObjects];
        [recentRacesArray removeAllObjects];
        
        [self makeAppDelRaceTypeArray];
        [self makeAppDelRecentRacesArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //update ui elements and methods for the view
            [self.TableView reloadData];
            [self.RaceClassCV reloadData];
            [self.RecentRacesCV reloadData];
            
            pageControl1.numberOfPages = recentRacesArray.count;
            pageControl2.numberOfPages = raceTypeArray.count;
            
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

#pragma mark - Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    return cell;
}

#pragma - Collection View Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == RecentRacesCV)
        return recentRacesArray.count;
    if (collectionView == RaceClassCV)
        return raceTypeArray.count;
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *currentCell;

    if (collectionView == RaceClassCV)
    {
        HomepageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
        currentCell = cell;

        RaceType * raceTypeObject = [self.raceTypeArray objectAtIndex:indexPath.row];
        
        [cell removeActvityIndicators];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.hidesWhenStopped = YES;
        activityIndicator.color = [UIColor blackColor];
        activityIndicator.center = cell.imageScroller2.center;
        [cell addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        NSURL *imageURL;
        if([raceTypeObject.TypeImageURL containsString:@"carno"])
            imageURL = [NSURL URLWithString:raceTypeObject.TypeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
        else
            imageURL = [NSURL URLWithString:raceTypeObject.TypeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
        
        [cell.CellImageView sd_setImageWithURL:imageURL
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                     [activityIndicator stopAnimating];
                                     [cell.CellImageView setAlpha:0.0];
                                     [UIImageView animateWithDuration:0.5 animations:^{
                                         [cell.CellImageView setAlpha:1.0];
                                     }];
                                 }];
        
        cell.CellImageView.tag = 1;
        [cell.imageScroller2 setDelegate:self];

        [cell.imageScroller2 setScrollEnabled:NO];
        
        cell.DescriptionLabel.text = raceTypeObject.RaceTypeString;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if (collectionView == RecentRacesCV)
    {
        RaceCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RaceCVCell" forIndexPath:indexPath];
        currentCell = cell;
        
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0, 10.0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cell.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;

        HomePageMedia * raceObject = [self.recentRacesArray objectAtIndex:indexPath.row];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.hidesWhenStopped = YES;
        activityIndicator.color = [UIColor blackColor];
        activityIndicator.center = cell.imageScroller.center;
        [cell addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        NSURL *imageURL;
        if([raceObject.ImageURL containsString:@"raceno"])
            imageURL = [NSURL URLWithString:raceObject.ImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/raceimage.php"]];
        else
            imageURL = [NSURL URLWithString:raceObject.ImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
        
        [cell.raceImageView sd_setImageWithURL:imageURL
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                         [activityIndicator stopAnimating];
                                         [cell.raceImageView setAlpha:0.0];
                                         [UIImageView animateWithDuration:0.5 animations:^{
                                             [cell.raceImageView setAlpha:1.0];
                                         }];
                                     }];
        
        Race *raceObject2 = [self findRaceObjectFromHomeData:raceObject];
        RaceType *raceTypeObject = [self findRaceTypeFromRaceObject:raceObject2];
        
        NSURL *imageURL2;
        if([raceTypeObject.TypeImageURL containsString:@"carno"])
            imageURL2 = [NSURL URLWithString:raceTypeObject.TypeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
        else
            imageURL2 = [NSURL URLWithString:raceTypeObject.TypeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
        
        [cell.raceClassImageView setImageWithURL:imageURL2
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                      [cell.raceClassImageView setAlpha:0.0];
                                      [UIImageView animateWithDuration:0.5 animations:^{
                                          [cell.raceClassImageView setAlpha:1.0];
                                          [cell.raceClassImageView setImage:[self imageWithImage:cell.raceClassImageView.image scaledToWidth:cell.raceClassImageView.frame.size.width]];
                                      }];
                                  }
                usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        cell.raceImageView.tag = 1;
        [cell.imageScroller setDelegate:self];

        [cell.imageScroller setScrollEnabled:NO];
        
        cell.raceNameLabel.text = raceObject.Description;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yy"];
        cell.raceDateLabel.text = [formatter stringFromDate:raceObject2.RaceDate];
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
    return currentCell;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:1];
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat top = 0, left = 0;
    if (scrollView.contentSize.width < scrollView.bounds.size.width) {
        left = (scrollView.bounds.size.width-scrollView.contentSize.width) * 0.5f;
    }
    if (scrollView.contentSize.height < scrollView.bounds.size.height) {
        top = (scrollView.bounds.size.height-scrollView.contentSize.height) * 0.5f;
    }
    scrollView.contentInset = UIEdgeInsetsMake(top, left, top, left);
}

-(Race *)findRaceObjectFromHomeData: (HomePageMedia *)homeData
{
    Race *currentRace;
    
    for(int i=0; i<raceListArray.count; i++)
    {
        Race *race = (Race *)[raceListArray objectAtIndex:i];
        if([race.RaceName isEqualToString:homeData.Description])
            currentRace = race;
    }
    return currentRace;
}

-(RaceType *)findRaceTypeFromRaceObject:(Race *)raceObject
{
    NSString *raceTypeString = raceObject.RaceType;
    RaceType *currentType;
    
    for(int i=0; i<raceTypeArray.count; i++)
    {
        RaceType *type = [raceTypeArray objectAtIndex:i];
        if([type.RaceTypeString isEqualToString:raceTypeString])
            currentType = type;
    }
    return currentType;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = RecentRacesCV.frame.size.width;
    float currentPage = RecentRacesCV.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f))
        pageControl1.currentPage = currentPage + 1;
    else
        pageControl1.currentPage = currentPage;
    
    pageWidth = RaceClassCV.frame.size.width;
    currentPage = RaceClassCV.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f))
        pageControl2.currentPage = currentPage + 1;
    else
        pageControl2.currentPage = currentPage;
}

#pragma mark - Internal Loading Methods

-(void)SetUpCardViews
{
    [self SetUpCard:CardView1];
    [self SetUpCard:CardView2];
    [self SetUpCard:CardView3];
}

-(void)SetUpCard:(UIView *)CardView
{
    [CardView setAlpha:1];
    CardView.layer.masksToBounds = NO;
    CardView.layer.cornerRadius = 10;
    CardView.layer.shadowOffset = CGSizeMake(-.2f, .2f);
    CardView.layer.shadowRadius = 1.5;
    CardView.layer.shadowOpacity = .5;
    CardView.backgroundColor = [UIColor whiteColor];
    
    if(CardView == CardView3)
    {
        UITableViewCell *disclosure = [[UITableViewCell alloc] init];
        [CardView3 addSubview:disclosure];
        disclosure.frame = CardView3.bounds;
        disclosure.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        disclosure.userInteractionEnabled = NO;
        return;
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CardView.bounds.origin.y+35, CardView.bounds.size.width, 1.5)];
    lineView.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
    [CardView addSubview:lineView];
}

-(void)SetScrollDirections
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)[self.RecentRacesCV collectionViewLayout];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout = (UICollectionViewFlowLayout *)[self.RaceClassCV collectionViewLayout];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (void) makeAppDelRaceTypeArray;
{
    raceTypeArray = [[NSMutableArray alloc]init];
    raceListArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [raceTypeArray addObjectsFromArray:appdel.raceTypeArray];
    [raceListArray addObjectsFromArray:appdel.raceListArray];
}

-(void) makeAppDelRecentRacesArray;
{
    NSMutableArray* mediaArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [mediaArray addObjectsFromArray:appdel.homePageArray];
    
    recentRacesArray = [[NSMutableArray alloc]init];
    
    for (int i = 0;i<mediaArray.count;i++)
    {
        HomePageMedia *currentMedia = [mediaArray objectAtIndex:i];
        
        if ([currentMedia.MediaType isEqualToString:@"Race"])
            [recentRacesArray addObject:currentMedia];
    }
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize
{
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage*)resizeImage:(UIImage*)aImage reSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [aImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight), NO, 0);
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Navigation

-(void)setUpNavigationGestures
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(RecentRaceSelected:)];
    [CardView1 addGestureRecognizer: tap];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(RaceTypeSelected:)];
    [CardView2 addGestureRecognizer: tap2];
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(ViewAllRacesSelected:)];
    [CardView3 addGestureRecognizer: tap3];
}

- (void) RecentRaceSelected: (UITapGestureRecognizer *) tap
{
    recentRace = NULL;
    [CardView1 setAlpha:.5];
    HomePageMedia * selectedMedia = [recentRacesArray objectAtIndex:pageControl1.currentPage];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (int i = 0; i<appdel.raceListArray.count; i++)
    {
        Race *currentRace = [appdel.raceListArray objectAtIndex:i];
        if ([currentRace.RaceName isEqualToString:selectedMedia.Description])
            recentRace = currentRace;
    }
    
    if([recentRace.RaceType isEqualToString:@"Formula 1"] || [recentRace.RaceType isEqualToString:@"Supercars Championship"])
        [self performSegueWithIdentifier:@"pushResults1" sender:self];
    if([recentRace.RaceType isEqualToString:@"NASCAR"])
        [self performSegueWithIdentifier:@"pushResults2" sender:self];
    if([recentRace.RaceType isEqualToString:@"FIA World Endurance Championship"])
        [self performSegueWithIdentifier:@"pushResults3" sender:self];
    if([recentRace.RaceType isEqualToString:@"IndyCar"])
        [self performSegueWithIdentifier:@"pushResults4" sender:self];
    if([recentRace.RaceType isEqualToString:@"DTM"])
        [self performSegueWithIdentifier:@"pushResults5" sender:self];
    if([recentRace.RaceType isEqualToString:@"WRC"] || [recentRace.RaceType isEqualToString:@"Formula E"])
        [self performSegueWithIdentifier:@"pushResults6" sender:self];
}

- (void) RaceTypeSelected: (UITapGestureRecognizer *) tap
{
    [CardView2 setAlpha:.3];
    [self performSegueWithIdentifier:@"pushRaceType" sender:self];
}

- (void) ViewAllRacesSelected: (UITapGestureRecognizer *) tap
{
    [CardView3 setAlpha:.3];
    [self performSegueWithIdentifier:@"pushAllRaces" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    raceTypeID = [raceTypeArray objectAtIndex:pageControl2.currentPage];
    
    if ([[segue identifier] isEqualToString:@"pushRaceType"])
    {
        [[segue destinationViewController] getRaceTypeID:raceTypeID];
    }
    if ([[segue identifier] isEqualToString:@"pushResults1"] || [[segue identifier] isEqualToString:@"pushResults2"] || [[segue identifier] isEqualToString:@"pushResults3"] || [[segue identifier] isEqualToString:@"pushResults4"] || [[segue identifier] isEqualToString:@"pushResults5"] || [[segue identifier] isEqualToString:@"pushResults6"])
    {
        [[segue destinationViewController] getRaceResults:recentRace];
    }
    if ([[segue identifier] isEqualToString:@"pushAllRaces"])
    {
        [[segue destinationViewController] setUpAllRacesArray];
    }
}

@end
