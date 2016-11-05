#import "TestViewController.h"
#import "CarViewCell.h"
#import "News.h"
#import "AppDelegate.h"
#import "TestNewsViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "SWRevealViewController.h"
#import "NewsCell.h"
#import "HomepageCell.h"
#import "HomePageMedia.h"
#import "Race.h"
#import "Model.h"
#import "DetailViewController.h"
#import "PageItemController.h"
#import "CheckInternet.h"
#import "RaceCVCell.h"
#import "RaceType.h"
#import <Google/Analytics.h>
#import "ViewController.h"
#import "PageItemController.h"
#import "YTPlayerView.h"

@interface TestViewController()

@end

@implementation TestViewController
@synthesize newsArray, mediaArray, carOfTheDayArray, latestArticlesArray, latestVideosArray, racesArray, addedCarsArray, CarOfTheDayCV, LatestArticlesCV, LatestVideosCV, RacesCV, AddedCarsCV, currentRaceID, currentCarOfTheDay, refreshControl, CarOfTheDayLabel, Spec1Label, Spec2Label, COTDSpec1, COTDSpec2, pageControl1, pageControl2, pageControl3, pageControl4, pageControl5, TableView, CardView1, CardView2, CardView3, CardView4, CardView5, SpecImage1, SpecImage2, currentNewCar, selectedNews, gradient, shouldKeepSpinning, fullSpecsArrow, fullSpecsLabel, latestVideosLabel, latestArticlesLabel, recentRacesLabel, newlyAddedCarsLabel, shouldDoInitialLoad, noDataLabel, refreshImage, COTDMediaObject, shouldPushToModel, savedNotification, shouldPushToArticle, shouldPushToVideo, shouldPushToRace, playerView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewdidload");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preloadToModel:) name:@"preloadToModel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preloadToArticle:) name:@"preloadToArticle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preloadToVideo:) name:@"preloadToVideo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preloadToRace:) name:@"preloadToRace" object:nil];
    
    [self preloadWebview];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.TableView.separatorColor = [UIColor clearColor];
        
    self.barButton.target = self.revealViewController;
    self.barButton.action = @selector(revealToggle:);
    
    self.title = @"Home";
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:self.title];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [self makeAppDelMediaArray];
    [self splitMediaArray];
    [self SetUpCardViews];
    [self SetScrollDirections];
    [self setUpNavigationGestures];
    [self setupRefreshControl];
    
    pageControl1.numberOfPages =  carOfTheDayArray.count;
    pageControl2.numberOfPages =  latestArticlesArray.count;
    pageControl3.numberOfPages =  latestVideosArray.count;
    pageControl4.numberOfPages =  racesArray.count;
    pageControl5.numberOfPages =  addedCarsArray.count;
    
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appdel.hasLoaded == NO && [appdel isInternetConnectionAvailable] == YES)
    {
        [Spec1Label setAlpha:0.0];
        [Spec2Label setAlpha:0.0];
        [CarOfTheDayLabel setAlpha:0.0];
        [fullSpecsArrow setAlpha:0.0];
        [fullSpecsLabel setAlpha:0.0];
        [latestArticlesLabel setAlpha:0.0];
        [CardView1 setAlpha:0];
        [CardView2 setAlpha:0];
        [CardView3 setAlpha:0];
        [CardView4 setAlpha:0];
        [CardView5 setAlpha:0];
                
        shouldDoInitialLoad = YES;
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        self.TableView.contentOffset = CGPointMake(0, - self.refreshControl.frame.size.height);
        [self.refreshControl beginRefreshing];
        [self reloadData];
    }
    else if(appdel.hasLoaded == NO && [appdel isInternetConnectionAvailable] == NO)
    {
        [noDataLabel removeFromSuperview];
        [refreshImage removeFromSuperview];
        
        [Spec1Label setAlpha:0.0];
        [Spec2Label setAlpha:0.0];
        [CarOfTheDayLabel setAlpha:0.0];
        [fullSpecsArrow setAlpha:0.0];
        [fullSpecsLabel setAlpha:0.0];
        [latestArticlesLabel setAlpha:0.0];
        [CardView1 setAlpha:0];
        [CardView2 setAlpha:0];
        [CardView3 setAlpha:0];
        [CardView4 setAlpha:0];
        [CardView5 setAlpha:0];
        
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        
        noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.TableView.bounds.size.width, self.TableView.bounds.size.height)];
        noDataLabel.text = @"No Internet Connection";
        noDataLabel.textColor = [UIColor blackColor];
        noDataLabel.font = [UIFont fontWithName:@"MavenProRegular" size:16];
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        
        refreshImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [refreshImage setCenter:CGPointMake(self.TableView.center.x, self.TableView.center.y-40)];
        [refreshImage setImage:[UIImage imageNamed:@"updateArrow.png"]];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapRefresh)];
        [refreshImage addGestureRecognizer:tap];
        [refreshImage setUserInteractionEnabled:YES];
        
        [self.TableView addSubview:noDataLabel];
        [self.TableView addSubview:refreshImage];
    }
}

-(void)preloadWebview
{
    //preloads UIWebView and YTPlayerView since they take time on the first load
    UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    webview.delegate = self;
    [webview loadHTMLString:@"<div style=\"background-color:#fff; display:inline-block; font-family:Arial,sans-serif; color:#c0c0c0; font-size:1em; width:100%; max-width:410px; min-width:300px;\"><div style=\"overflow:hidden; position:relative; height:0; padding:92% 0 49px 0; width:100%;\"><iframe src=\"http://www.evoxstock.com/apis/media/embed/V0508647/XiB74FbcWN9R30zVY9df2lzWXNJY5Vbo4Q\" width=\"410\" scrolling=\"no\" frameborder=\"0\" style=\"display:inline-block; position:absolute; top:0; left:0; width:100%; height:100%;\"></iframe></div></div>" baseURL:nil];
    [self.view addSubview:webview];
    
    playerView = [[YTPlayerView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    playerView.delegate = self;
    NSString *videoID = @"kXz6iwLm9nE";
    [playerView loadWithVideoId:videoID];
}

-(void)playerViewDidBecomeReady:(YTPlayerView *)playerView
{
    NSLog(@"player finished loading");
}

-(void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    NSLog(@"changedtostate");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"didfinishload");
}

-(void)viewDidDisappear:(BOOL)animated
{
    [CardView1 setAlpha:1];
    [CardView2 setAlpha:1];
    [CardView3 setAlpha:1];
    [CardView4 setAlpha:1];
    [CardView5 setAlpha:1];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.title = @"Home";
}

- (UIImage*)resizeImage:(UIImage*)aImage reSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [aImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)rotateLayerInfinite:(CALayer *)layer
{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    rotation.duration = 0.7f; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [layer removeAllAnimations];
    [layer addAnimation:rotation forKey:@"Spin"];
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
    HomePageMedia * mediaObject;
    HomepageCell *cell;
    
    if (collectionView != self.RacesCV)
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
    
    if (collectionView == self.CarOfTheDayCV)
    {
        mediaObject = [carOfTheDayArray objectAtIndex:indexPath.item];

        CarOfTheDayCV.clipsToBounds = YES;
        cell.imageScroller2.clipsToBounds = YES;
        NSString *imageURL = [carOfTheDayArray objectAtIndex:indexPath.item];
        
        NSURL *url;
        if([imageURL containsString:@"carno"])
            url = [NSURL URLWithString:imageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
        else
            url = [NSURL URLWithString:imageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.hidesWhenStopped = YES;
        activityIndicator.color = [UIColor blackColor];
        activityIndicator.center = cell.CellImageView.center;
        [cell addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        cell.CellImageView.tag = 1;
        [cell.imageScroller2 setDelegate:self];

        [cell.imageScroller2 setScrollEnabled:NO];
        
        [cell.CellImageView sd_setImageWithURL:url
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                      [activityIndicator stopAnimating];
                                      [cell.CellImageView setAlpha:0.0];
                                      [UIImageView animateWithDuration:0.5 animations:^{
                                          [cell.CellImageView setAlpha:1.0];
                                      }];
                                  }];
    
        cell.CellImageView.contentMode = UIViewContentModeScaleAspectFill;
        return cell;
    }
    
    if (collectionView == self.LatestArticlesCV || collectionView == self.LatestVideosCV)
    {
        if (collectionView == self.LatestArticlesCV)
            mediaObject = [latestArticlesArray objectAtIndex:indexPath.item];
        if (collectionView == self.LatestVideosCV)
            mediaObject = [latestVideosArray objectAtIndex:indexPath.item];
        
        NSURL *imageURL;
        if([mediaObject.ImageURL containsString:@"newsno"])
            imageURL = [NSURL URLWithString:mediaObject.ImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/newsimage.php"]];
        else
            imageURL = [NSURL URLWithString:mediaObject.ImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.hidesWhenStopped = YES;
        activityIndicator.color = [UIColor blackColor];
        activityIndicator.center = cell.CellImageView.center;
        [cell addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        cell.CellImageView.tag = 1;
        [cell.imageScroller2 setDelegate:self];

        [cell.imageScroller2 setScrollEnabled:NO];

        [cell.CellImageView sd_setImageWithURL:imageURL
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                             [activityIndicator stopAnimating];
                                             [cell.CellImageView setAlpha:0.0];
                                             [UIImageView animateWithDuration:0.5 animations:^{
                                                 [cell.CellImageView setClipsToBounds:YES];
                                                 [cell.CellImageView setAlpha:1.0];
                                             }];
                                         }];

        cell.DescriptionLabel.text=mediaObject.Description;
        return cell;
    }
    
    if (collectionView == self.RacesCV)
    {
        RaceCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RaceCVCell" forIndexPath:indexPath];

        mediaObject = [racesArray objectAtIndex:indexPath.item];
        
        NSURL *imageURL;
        if([mediaObject.ImageURL containsString:@"raceno"])
            imageURL = [NSURL URLWithString:mediaObject.ImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/raceimage.php"]];
        else
            imageURL = [NSURL URLWithString:mediaObject.ImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.hidesWhenStopped = YES;
        activityIndicator.color = [UIColor blackColor];
        activityIndicator.center = cell.raceImageView.center;
        [cell addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        [cell.raceImageView sd_setImageWithURL:imageURL
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                             [activityIndicator stopAnimating];
                                             [cell.raceImageView setAlpha:0.0];
                                             [UIImageView animateWithDuration:0.5 animations:^{
                                                 [cell.raceImageView setAlpha:1.0];
                                             }];
                                         }];
        
        Race *raceObject2 = [self findRaceObjectFromHomeData:mediaObject];
        RaceType *raceTypeObject = [self findRaceTypeFromRaceObject:raceObject2];
        
        NSURL *imageURL2;
        if([raceTypeObject.TypeImageURL containsString:@"carno"])
            imageURL2 = [NSURL URLWithString:raceTypeObject.TypeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
        else
            imageURL2 = [NSURL URLWithString:raceTypeObject.TypeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
        
        [cell.raceClassImageView sd_setImageWithURL:imageURL2
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                           [cell.raceClassImageView setAlpha:0.0];
                                           [UIImageView animateWithDuration:0.5 animations:^{
                                               [cell.raceClassImageView setAlpha:1.0];
                                           }];
                                       }];
        
        cell.raceImageView.tag = 1;
        [cell.imageScroller setDelegate:self];

        [cell.imageScroller setScrollEnabled:NO];
        
        cell.raceNameLabel.text = mediaObject.Description;
        cell.raceDateLabel.text = mediaObject.RaceDate;
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
    if (collectionView == self.AddedCarsCV)
        mediaObject = [addedCarsArray objectAtIndex:indexPath.item];
    
    cell.CellImageView.tag = 1;
    
    [cell removeActvityIndicators];
    
    [cell setUpCarImageWithModel:[self getModelFromMediaObject:mediaObject]];
    
    cell.DescriptionLabel.text=mediaObject.Description;
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
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
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Race *currentRace;
    
    for(int i=0; i<appdel.raceListArray.count; i++)
    {
        Race *race = (Race *)[appdel.raceListArray objectAtIndex:i];
        if([race.RaceName isEqualToString:homeData.Description])
            currentRace = race;
    }
    return currentRace;
}

-(RaceType *)findRaceTypeFromRaceObject:(Race *)raceObject
{
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *raceTypeString = raceObject.RaceType;
    RaceType *currentType;
    
    for(int i=0; i<appdel.raceTypeArray.count; i++)
    {
        RaceType *type = [appdel.raceTypeArray objectAtIndex:i];
        if([type.RaceTypeString isEqualToString:raceTypeString])
            currentType = type;
    }
    return currentType;
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
    
    pageWidth = LatestVideosCV.frame.size.width;
    currentPage = LatestVideosCV.contentOffset.x / pageWidth;
    
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

#pragma mark - Refresh Control Setup

- (void)setupRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, -30, self.view.frame.size.width, 30)];
    
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
        if(appdel.hasLoaded == NO && [appdel isInternetConnectionAvailable] == YES)
        {
            [appdel updateAllData];
            [mediaArray removeAllObjects];
            [mediaArray addObjectsFromArray:appdel.homePageArray];
            [self.navigationController.navigationBar setUserInteractionEnabled:YES];
        }
        else
        {
            //remove objects and update data from arrays that use appdel arrays
            [appdel updateAllData];
            [mediaArray removeAllObjects];
            [mediaArray addObjectsFromArray:appdel.homePageArray];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //update ui elements and methods for the view
            [self.CarOfTheDayCV reloadData];
            [self.LatestArticlesCV reloadData];
            [self.LatestVideosCV reloadData];
            [self.RacesCV reloadData];
            [self.AddedCarsCV reloadData];
            
            [self splitMediaArray];
            
            pageControl1.numberOfPages = carOfTheDayArray.count;
            pageControl2.numberOfPages = latestArticlesArray.count;
            pageControl3.numberOfPages = latestVideosArray.count;
            pageControl4.numberOfPages = racesArray.count;
            pageControl5.numberOfPages = addedCarsArray.count;
            [self scrollViewDidEndDecelerating:CarOfTheDayCV];
            
            shouldDoInitialLoad = NO;
            shouldKeepSpinning = NO;
            [self.refreshControl endRefreshing];
            
            if(shouldPushToModel)
            {
                [self preloadToModel:savedNotification];
                shouldPushToModel = NO;
            }
            if(shouldPushToArticle)
            {
                [self preloadToArticle:savedNotification];
                shouldPushToArticle = NO;
            }
            if(shouldPushToVideo)
            {
                [self preloadToVideo:savedNotification];
                shouldPushToVideo = NO;
            }
            if(shouldPushToRace)
            {
                [self preloadToRace:savedNotification];
                shouldPushToRace = NO;
            }
            
            AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if([appdel isInternetConnectionAvailable] == YES)
            {
                //self.TableView.contentOffset = CGPointMake(0, 0);
                [Spec1Label setAlpha:1];
                [Spec2Label setAlpha:1];
                [CarOfTheDayLabel setAlpha:1];
                [fullSpecsArrow setAlpha:1];
                [fullSpecsLabel setAlpha:1];
                [latestArticlesLabel setAlpha:1];
                [CardView1 setAlpha:1];
                [CardView2 setAlpha:1];
                [CardView3 setAlpha:1];
                [CardView4 setAlpha:1];
                [CardView5 setAlpha:1];
                
                [refreshImage removeFromSuperview];
                [noDataLabel removeFromSuperview];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please check your internet connectivity." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                [noDataLabel removeFromSuperview];
                [refreshImage removeFromSuperview];
                
                [Spec1Label setAlpha:0];
                [Spec2Label setAlpha:0];
                [CarOfTheDayLabel setAlpha:0];
                [fullSpecsArrow setAlpha:0];
                [fullSpecsLabel setAlpha:0];
                [latestArticlesLabel setAlpha:0];
                [CardView1 setAlpha:0];
                [CardView2 setAlpha:0];
                [CardView3 setAlpha:0];
                [CardView4 setAlpha:0];
                [CardView5 setAlpha:0];
                
                noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.TableView.bounds.size.width, self.TableView.bounds.size.height)];
                noDataLabel.text = @"No Internet Connection";
                noDataLabel.textColor = [UIColor blackColor];
                noDataLabel.font = [UIFont fontWithName:@"MavenProRegular" size:16];
                noDataLabel.textAlignment = NSTextAlignmentCenter;
                
                refreshImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                [refreshImage setCenter:CGPointMake(self.TableView.center.x, self.TableView.center.y-40)];
                [refreshImage setImage:[UIImage imageNamed:@"updateArrow.png"]];
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapRefresh)];
                [refreshImage addGestureRecognizer:tap];
                [refreshImage setUserInteractionEnabled:YES];
                
                [self.TableView addSubview:noDataLabel];
                [self.TableView addSubview:refreshImage];
            }
        });
    });
}

-(void)tapRefresh
{
    shouldDoInitialLoad = YES;
    self.TableView.contentOffset = CGPointMake(0, - self.refreshControl.frame.size.height);
    [self.refreshControl beginRefreshing];
    [self reloadData];
}

- (BOOL) isInternetConnectionAvailable
{
    CheckInternet *internet = [CheckInternet reachabilityWithHostName: @"www.google.com"];
    NetworkStatus netStatus = [internet currentReachabilityStatus];
    bool netConnection = false;
    switch (netStatus)
    {
        case NotReachable:
        {
            NSLog(@"Access Not Available");
            netConnection = false;
            break;
        }
        case ReachableViaWWAN:
        {
            netConnection = true;
            break;
        }
        case ReachableViaWiFi:
        {
            netConnection = true;
            break;
        }
    }
    return netConnection;
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
    if(shouldDoInitialLoad)
        compassFrame.origin.y = compassY-self.refreshControl.frame.size.height/2;
    else
        compassFrame.origin.y = compassY;
    
    CGRect spinnerFrame = self.compass_spinner.frame;
    spinnerFrame.origin.x = spinnerX;
    if(shouldDoInitialLoad)
        spinnerFrame.origin.y = spinnerY-self.refreshControl.frame.size.height/2;
    else
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

#pragma mark - Initial Internal Methods

-(void)SetUpCardViews
{
    [self SetUpCard:CardView1];
    [self SetUpCard:CardView2];
    [self SetUpCard:CardView3];
    [self SetUpCard:CardView4];
    [self SetUpCard:CardView5];
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
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CardView.bounds.origin.y+35, CardView.bounds.size.width, 1.5)];
    lineView.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
    [CardView addSubview:lineView];
}

-(void)SetScrollDirections
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)[self.CarOfTheDayCV collectionViewLayout];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout = (UICollectionViewFlowLayout *)[self.LatestArticlesCV collectionViewLayout];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout = (UICollectionViewFlowLayout *)[self.LatestVideosCV collectionViewLayout];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout = (UICollectionViewFlowLayout *)[self.RacesCV collectionViewLayout];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout = (UICollectionViewFlowLayout *)[self.AddedCarsCV collectionViewLayout];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
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
            COTDMediaObject = currentMedia;
            AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            for (int i = 0; i < appdel.modelArray.count; i++)
            {
                Model *currentModel = [appdel.modelArray objectAtIndex:i];
                if([currentModel.CarFullName isEqualToString:currentMedia.FullCarModel])
                    currentCarOfTheDay = currentModel;
            }
            
            COTDSpec1 = currentMedia.SpecLabel1;
            COTDSpec2 = currentMedia.SpecLabel2;
            [self SetCOTDSpecImages:currentMedia];
            
            CarOfTheDayLabel.text = [@"Car of The Day: " stringByAppendingString:currentMedia.Description];
            
            [Spec1Label setText:currentMedia.SpecLabel1];
            [Spec2Label setText:currentMedia.SpecLabel2];

            if(![currentMedia.ImageURL isEqualToString:@""])
                [carOfTheDayArray addObject:currentMedia.ImageURL];
            if(![currentMedia.ImageURL2 isEqualToString:@""])
                [carOfTheDayArray addObject:currentMedia.ImageURL2];
            if(![currentMedia.ImageURL3 isEqualToString:@""])
                [carOfTheDayArray addObject:currentMedia.ImageURL3];
            if(![currentMedia.ImageURL4 isEqualToString:@""])
                [carOfTheDayArray addObject:currentMedia.ImageURL4];
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

-(void)SetCOTDSpecImages: (HomePageMedia *)currentMedia
{
    NSString *spec1 = currentMedia.SpecType1;
    NSString *spec2 = currentMedia.SpecType2;
    
    if ([spec1 isEqualToString:@"Price"])
        SpecImage1.image = [self resizeImage:[UIImage imageNamed:@"Price.png"] reSize:SpecImage1.frame.size];
    if ([spec1 isEqualToString:@"Engine"])
        SpecImage1.image = [self resizeImage:[UIImage imageNamed:@"Engine.png"] reSize:SpecImage1.frame.size];
    if ([spec1 isEqualToString:@"Horsepower"])
        SpecImage1.image = [self resizeImage:[UIImage imageNamed:@"Horsepower.png"] reSize:SpecImage1.frame.size];
    if ([spec1 isEqualToString:@"Torque"])
        SpecImage1.image = [self resizeImage:[UIImage imageNamed:@"Torque.png"] reSize:SpecImage1.frame.size];
    if ([spec1 isEqualToString:@"0-60"])
        SpecImage1.image = [self resizeImage:[UIImage imageNamed:@"0-60.png"] reSize:SpecImage1.frame.size];
    if ([spec1 isEqualToString:@"Top Speed"])
        SpecImage1.image = [self resizeImage:[UIImage imageNamed:@"TopSpeed.png"] reSize:SpecImage1.frame.size];
    if ([spec1 isEqualToString:@"Fuel Economy"])
        SpecImage1.image = [self resizeImage:[UIImage imageNamed:@"FuelEconomy.png"] reSize:SpecImage1.frame.size];
    
    if ([spec2 isEqualToString:@"Price"])
        SpecImage2.image = [self resizeImage:[UIImage imageNamed:@"Price.png"] reSize:SpecImage2.frame.size];
    if ([spec2 isEqualToString:@"Engine"])
        SpecImage2.image = [self resizeImage:[UIImage imageNamed:@"Engine.png"] reSize:SpecImage2.frame.size];
    if ([spec2 isEqualToString:@"Horsepower"])
        SpecImage2.image = [self resizeImage:[UIImage imageNamed:@"Horsepower.png"] reSize:SpecImage2.frame.size];
    if ([spec2 isEqualToString:@"Torque"])
        SpecImage2.image = [self resizeImage:[UIImage imageNamed:@"Torque.png"] reSize:SpecImage2.frame.size];
    if ([spec2 isEqualToString:@"0-60"])
        SpecImage2.image = [self resizeImage:[UIImage imageNamed:@"0-60.png"] reSize:SpecImage2.frame.size];
    if ([spec2 isEqualToString:@"Top Speed"])
        SpecImage2.image = [self resizeImage:[UIImage imageNamed:@"TopSpeed.png"] reSize:SpecImage2.frame.size];
    if ([spec2 isEqualToString:@"Fuel Economy"])
        SpecImage2.image = [self resizeImage:[UIImage imageNamed:@"FuelEconomy.png"] reSize:SpecImage2.frame.size];
}

#pragma mark - Navigation

-(void)setUpNavigationGestures
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(COTDSelected:)];
    [CardView1 addGestureRecognizer: tap];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(ArticleSelected:)];
    [CardView2 addGestureRecognizer: tap2];
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(VideoSelected:)];
    [CardView3 addGestureRecognizer: tap3];
    UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(RaceSelected:)];
    [CardView4 addGestureRecognizer: tap4];
    UITapGestureRecognizer * tap5 = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(NewCarSelected:)];
    [CardView5 addGestureRecognizer: tap5];
}

- (void) COTDSelected:(UITapGestureRecognizer *) tap
{
    [CardView1 setAlpha:.5];
    [self performSegueWithIdentifier:@"pushDetailView" sender:self];
}

- (void) ArticleSelected: (UITapGestureRecognizer *) tap
{
    [CardView2 setAlpha:.5];
    selectedNews = NULL;
    HomePageMedia *currentMedia = [latestArticlesArray objectAtIndex:pageControl2.currentPage];
    
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (int i = 0; i < appdel.newsArray.count; i++)
    {
        News *currentNews = [appdel.newsArray objectAtIndex:i];
        if([currentNews.NewsImageURL isEqualToString:currentMedia.ImageURL])
            selectedNews = currentNews;
    }
    [self performSegueWithIdentifier:@"pushArticle" sender:self];
}

- (void) VideoSelected: (UITapGestureRecognizer *) tap
{
    [CardView3 setAlpha:.5];
    selectedNews = NULL;
    HomePageMedia *currentMedia = [latestVideosArray objectAtIndex:pageControl3.currentPage];
    
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (int i = 0; i < appdel.newsArray.count; i++)
    {
        News *currentNews = [appdel.newsArray objectAtIndex:i];
        if([currentNews.NewsImageURL isEqualToString:currentMedia.ImageURL])
            selectedNews = currentNews;
    }
    [self performSegueWithIdentifier:@"pushVideo" sender:self];
}

- (void) RaceSelected: (UITapGestureRecognizer *) tap
{
    [CardView4 setAlpha:.5];
    currentRaceID = NULL;
    HomePageMedia *currentMedia = [racesArray objectAtIndex:pageControl4.currentPage];
    
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (int i = 0; i < appdel.raceListArray.count; i++)
    {
        Race *currentRace = [appdel.raceListArray objectAtIndex:i];
        if([currentRace.RaceName isEqualToString:currentMedia.Description])
            currentRaceID = currentRace;
    }
    
    if([currentRaceID.RaceType isEqualToString:@"Formula 1"] || [currentRaceID.RaceType isEqualToString:@"Supercars Championship"])
        [self performSegueWithIdentifier:@"pushResults1" sender:self];
    if([currentRaceID.RaceType isEqualToString:@"NASCAR"])
        [self performSegueWithIdentifier:@"pushResults2" sender:self];
    if([currentRaceID.RaceType isEqualToString:@"FIA World Endurance Championship"])
        [self performSegueWithIdentifier:@"pushResults3" sender:self];
    if([currentRaceID.RaceType isEqualToString:@"IndyCar"])
        [self performSegueWithIdentifier:@"pushResults4" sender:self];
    if([currentRaceID.RaceType isEqualToString:@"DTM"])
        [self performSegueWithIdentifier:@"pushResults5" sender:self];
    if([currentRaceID.RaceType isEqualToString:@"WRC"] || [currentRaceID.RaceType isEqualToString:@"Formula E"])
        [self performSegueWithIdentifier:@"pushResults6" sender:self];
}

- (void) NewCarSelected: (UITapGestureRecognizer *)tap
{
    [CardView5 setAlpha:.5];
    
    HomePageMedia *currentMedia = [addedCarsArray objectAtIndex:pageControl5.currentPage];
    
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (int i = 0; i < appdel.modelArray.count; i++)
    {
        Model *currentModel = [appdel.modelArray objectAtIndex:i];
        if([currentModel.CarFullName isEqualToString:currentMedia.Description])
            currentNewCar = currentModel;
    }
    [self performSegueWithIdentifier:@"pushNewCar" sender:self];
}

-(Model *)getModelFromMediaObject: (HomePageMedia *)mediaObject
{
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (int i = 0; i < appdel.modelArray.count; i++)
    {
        Model *currentModel = [appdel.modelArray objectAtIndex:i];
        if([currentModel.CarFullName isEqualToString:mediaObject.Description])
            currentNewCar = currentModel;
    }
    return currentNewCar;
}

- (void)preloadToModel:(NSNotification *)notification
{
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appdel.hasLoaded == NO)
    {
        shouldPushToModel = YES;
        savedNotification = notification;
        return;
    }
    
    NSString *carFullName = [[notification userInfo] valueForKey:@"Car"];
    Model *currentModel;
    
    for(int i=0; i<appdel.modelArray.count; i++)
    {
        Model *current = [appdel.modelArray objectAtIndex:i];
        if([current.CarFullName isEqualToString:carFullName])
        {
            currentModel = current;
            break;
        }
    }
    
    UIViewController *viewController = [appdel.activeStoryboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [(DetailViewController *)viewController getModel:currentModel];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)preloadToArticle:(NSNotification *)notification
{
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appdel.hasLoaded == NO)
    {
        shouldPushToArticle = YES;
        savedNotification = notification;
        return;
    }
    
    NSString *articleName = [[notification userInfo] valueForKey:@"Article"];
    News *newsToPush;
    
    for (int i = 0; i < appdel.newsArray.count; i++)
    {
        News *currentNews = [appdel.newsArray objectAtIndex:i];
        if([currentNews.NewsImageURL isEqualToString:articleName])
            newsToPush = currentNews;
    }
    
    UIViewController *viewController = [appdel.activeStoryboard instantiateViewControllerWithIdentifier:@"ArticleViewController"];
    [(ViewController *)viewController getNews:newsToPush];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)preloadToVideo:(NSNotification *)notification
{
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appdel.hasLoaded == NO)
    {
        shouldPushToVideo = YES;
        savedNotification = notification;
        return;
    }
    
    NSString *videoName = [[notification userInfo] valueForKey:@"Video"];
    News *newsToPush;
    
    for (int i = 0; i < appdel.newsArray.count; i++)
    {
        News *currentNews = [appdel.newsArray objectAtIndex:i];
        if([currentNews.NewsImageURL isEqualToString:videoName])
            newsToPush = currentNews;
    }
    
    UIViewController *viewController = [appdel.activeStoryboard instantiateViewControllerWithIdentifier:@"VideoViewController"];
    [(ViewController *)viewController getNews:newsToPush];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)preloadToRace:(NSNotification *)notification
{
    NSLog(@"preloadtorace");
    
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appdel.hasLoaded == NO)
    {
        shouldPushToRace = YES;
        savedNotification = notification;
        return;
    }
    
    NSString *raceName = [[notification userInfo] valueForKey:@"Race"];
    Race *raceToPush;
    
    for (int i = 0; i < appdel.raceListArray.count; i++)
    {
        Race *currentRace = [appdel.raceListArray objectAtIndex:i];
        if([currentRace.RaceName isEqualToString:raceName])
            raceToPush = currentRace;
    }
    
    UIViewController *viewController;
    
    if([raceToPush.RaceType isEqualToString:@"Formula 1"] || [raceToPush.RaceType isEqualToString:@"Supercars Championship"])
        viewController = [appdel.activeStoryboard instantiateViewControllerWithIdentifier:@"RaceViewController1"];
    if([raceToPush.RaceType isEqualToString:@"NASCAR"])
        viewController = [appdel.activeStoryboard instantiateViewControllerWithIdentifier:@"RaceViewController2"];
    if([raceToPush.RaceType isEqualToString:@"FIA World Endurance Championship"])
        viewController = [appdel.activeStoryboard instantiateViewControllerWithIdentifier:@"RaceViewController3"];
    if([raceToPush.RaceType isEqualToString:@"IndyCar"])
        viewController = [appdel.activeStoryboard instantiateViewControllerWithIdentifier:@"RaceViewController4"];
    if([raceToPush.RaceType isEqualToString:@"DTM"])
        viewController = [appdel.activeStoryboard instantiateViewControllerWithIdentifier:@"RaceViewController5"];
    if([raceToPush.RaceType isEqualToString:@"WRC"] || [raceToPush.RaceType isEqualToString:@"Formula E"])
        viewController = [appdel.activeStoryboard instantiateViewControllerWithIdentifier:@"RaceViewController6"];
    
    [(PageItemController *)viewController getRaceResults:raceToPush];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationController.navigationBar.topItem.title = @"";

    if ([[segue identifier] isEqualToString:@"pushDetailView"])
        [[segue destinationViewController] getCarToLoad:currentCarOfTheDay sender:self];
    if ([[segue identifier] isEqualToString:@"pushNewCar"])
        [[segue destinationViewController] getCarToLoad:currentNewCar sender:self];
    if ([[segue identifier] isEqualToString:@"pushArticle"])
        [[segue destinationViewController] getNews:selectedNews];
    if ([[segue identifier] isEqualToString:@"pushVideo"])
        [[segue destinationViewController] getNews:selectedNews];
    if ([[segue identifier] isEqualToString:@"pushResults1"] || [[segue identifier] isEqualToString:@"pushResults2"] || [[segue identifier] isEqualToString:@"pushResults3"] || [[segue identifier] isEqualToString:@"pushResults4"] || [[segue identifier] isEqualToString:@"pushResults5"] || [[segue identifier] isEqualToString:@"pushResults6"])
    {
        [[segue destinationViewController] getRaceResults:currentRaceID];
    }
}

- (IBAction)unwindToHomeVC:(UIStoryboardSegue *)segue
{
    [self.navigationItem setTitle:@"Home"];
}

@end
