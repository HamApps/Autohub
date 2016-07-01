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
#import "RaceResultsViewController.h"
#import "Model.h"
#import "DetailViewController.h"
#import "PageItemController.h"

@interface TestViewController()

@end

@implementation TestViewController
@synthesize newsArray, mediaArray, carOfTheDayArray, latestArticlesArray, latestVideosArray, racesArray, addedCarsArray, CarOfTheDayCV, LatestArticlesCV, LatestVideosCV, RacesCV, AddedCarsCV, currentRaceID, currentCarOfTheDay, refreshControl, CarOfTheDayLabel, Spec1Label, Spec2Label, COTDSpec1, COTDSpec2, pageControl1, pageControl2, pageControl3, pageControl4, pageControl5, TableView, CardView1, CardView2, CardView3, CardView4, CardView5, SpecImage1, SpecImage2, currentNewCar, selectedNews, gradient, shouldKeepSpinning;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appdel.hasLoaded == NO)
    {
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    }
    
    self.view.backgroundColor = [UIColor clearColor];
    self.TableView.separatorColor = [UIColor clearColor];
    
    self.barButton.target = self.revealViewController;
    self.barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
       NSFontAttributeName:[UIFont fontWithName:@"MavenProMedium" size:20]}];
    self.title = @"Home";
    
    //Initial Internal Methods
    [self setupRefreshControl];
    [self makeAppDelMediaArray];
    [self splitMediaArray];
    [self SetUpCardViews];
    [self SetScrollDirections];
    [self setUpNavigationGestures];
    
    pageControl1.numberOfPages =  carOfTheDayArray.count;
    pageControl2.numberOfPages =  latestArticlesArray.count;
    pageControl3.numberOfPages =  latestVideosArray.count;
    pageControl4.numberOfPages =  racesArray.count;
    pageControl5.numberOfPages =  addedCarsArray.count;
    
    CALayer * circle = [self.circleLabel layer];
    [circle setMasksToBounds:YES];
    [circle setCornerRadius:10.0];
    [circle setBorderWidth:1.0];
    [circle setBorderColor:[[UIColor colorWithRed:(214/255.0) green:(38/255.0) blue:(19/255.0) alpha:1] CGColor]];
}

-(void)viewDidDisappear:(BOOL)animated
{
    CardView1.backgroundColor = [UIColor whiteColor];
    CardView2.backgroundColor = [UIColor whiteColor];
    CardView3.backgroundColor = [UIColor whiteColor];
    CardView4.backgroundColor = [UIColor whiteColor];
    CardView5.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.title = @"Home";
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
    HomepageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
    HomePageMedia * mediaObject;
        
    if (collectionView == self.CarOfTheDayCV)
    {
        CarOfTheDayCV.clipsToBounds = YES;
        cell.CellImageView.clipsToBounds = YES;
        NSString *imageURL = [carOfTheDayArray objectAtIndex:indexPath.item];
        
        NSURL *url;
        if([imageURL containsString:@"carno"])
            url = [NSURL URLWithString:imageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
        else
            url = [NSURL URLWithString:imageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
        
        [cell.CellImageView setImageWithURL:url
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                      [cell.CellImageView setAlpha:0.0];
                                      [UIImageView animateWithDuration:0.5 animations:^{
                                          [cell.CellImageView setAlpha:1.0];
                                      }];
                                  }
                usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
        //[cell.CellImageView setFrame:CGRectMake(0, 0, 300, 140)];
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

        [cell.CellImageView setImageWithURL:imageURL
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
    
    if (collectionView == self.RacesCV)
    {
        mediaObject = [racesArray objectAtIndex:indexPath.item];
        
        NSURL *imageURL;
        if([mediaObject.ImageURL containsString:@"raceno"])
            imageURL = [NSURL URLWithString:mediaObject.ImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/raceimage.php"]];
        else
            imageURL = [NSURL URLWithString:mediaObject.ImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
        
        [cell.CellImageView setImageWithURL:imageURL
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                             [cell.CellImageView setAlpha:0.0];
                                             [UIImageView animateWithDuration:0.5 animations:^{
                                                 [cell.CellImageView setAlpha:1.0];
                                             }];
                                         }
                    usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
        cell.DescriptionLabel.text=mediaObject.Description;
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
    if (collectionView == self.AddedCarsCV)
        mediaObject = [addedCarsArray objectAtIndex:indexPath.item];
    
    [cell setUpCarImageWithModel:[self getModelFromMediaObject:mediaObject]];
    
    cell.DescriptionLabel.text=mediaObject.Description;
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
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
    // Adding UIRefreshControl Programatically
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    //self.refreshControl = [[UIRefreshControl alloc]init];
    
    // Setup the loading view, which will hold the moving graphics
    self.refreshLoadingView = [[UIView alloc] initWithFrame:self.refreshControl.frame];
    NSLog(@"frame :%f", self.refreshControl.frame.size.height);
    self.refreshLoadingView.backgroundColor = [UIColor clearColor];
    
    // Create the graphic image views
    self.compass_background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoadingWheelBrake.png"]];
    self.compass_spinner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoadingWheelWheel.png"]];
    
    // Add the graphics to the loading view
    [self.refreshLoadingView addSubview:self.compass_background];
    [self.refreshLoadingView addSubview:self.compass_spinner];
    
    // Clip so the graphics don't stick out
    self.refreshLoadingView.clipsToBounds = YES;
    
    // Hide the original spinner icon
    self.refreshControl.tintColor = [UIColor clearColor];
    
    // Add the loading and colors views to our refresh control
    [self.refreshControl addSubview:self.refreshLoadingView];
    
    // Initalize flags
    self.isRefreshIconsOverlap = NO;
    self.isRefreshAnimating = NO;
    
    // When activated, invoke our refresh function
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    [self.TableView addSubview:self.refreshControl];
}

- (void)reloadData;
{
    [self refresh:self];
}

- (void)refresh:(id)sender{
    // -- DO SOMETHING AWESOME (... or just wait 3 seconds) --
    // This is where you'll make requests to an API, reload data, or process information
    
    if (self.refreshControl.isRefreshing && !self.isRefreshAnimating)
        [self animateRefreshView];
    
    shouldKeepSpinning = YES;
    
    double delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_async(dispatch_get_main_queue(), ^{
    //dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if(appdel.hasLoaded == NO)
        {
            [appdel performInitialLoad];
            [mediaArray addObjectsFromArray:appdel.homePageArray];
            [self splitMediaArray];
            
            [self.CarOfTheDayCV reloadData];
            [self.LatestArticlesCV reloadData];
            [self.LatestVideosCV reloadData];
            [self.RacesCV reloadData];
            [self.AddedCarsCV reloadData];
            [self.navigationController.navigationBar setUserInteractionEnabled:YES];
        }
        else
        {
            [appdel retrieveHomePageData];
        
            [mediaArray removeAllObjects];
            [mediaArray addObjectsFromArray:appdel.homePageArray];
            [self splitMediaArray];
    
            [self.CarOfTheDayCV reloadData];
            [self.LatestArticlesCV reloadData];
            [self.LatestVideosCV reloadData];
            [self.RacesCV reloadData];
            [self.AddedCarsCV reloadData];
        }
        
        pageControl1.numberOfPages =  carOfTheDayArray.count;
        pageControl2.numberOfPages =  latestArticlesArray.count;
        pageControl3.numberOfPages =  latestVideosArray.count;
        pageControl4.numberOfPages =  racesArray.count;
        pageControl5.numberOfPages =  addedCarsArray.count;

        // When done requesting/reloading/processing invoke endRefreshing, to close the control
        NSLog(@"done loading");
        shouldKeepSpinning = NO;
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
    CGFloat midX = self.TableView.frame.size.width / 2.0;
    
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
    if (fabs(compassX - spinnerX) < 1.0) {
        self.isRefreshIconsOverlap = YES;
    }
    
    // If the graphics have overlapped or we are refreshing, keep them together
    if (self.isRefreshIconsOverlap || self.refreshControl.isRefreshing)
    {
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
    
    self.refreshLoadingView.frame = refreshBounds;
    
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
    // Reset our flags
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
            AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            for (int i = 0; i < appdel.modelArray.count; i++)
            {
                Model *currentModel = [appdel.modelArray objectAtIndex:i];
                if([currentModel.CarFullName isEqualToString:currentMedia.Description])
                    currentCarOfTheDay = currentModel;
            }
            
            COTDSpec1 = currentMedia.SpecLabel1;
            COTDSpec2 = currentMedia.SpecLabel2;
            [self SetCOTDSpecImages:currentMedia];
            
            CarOfTheDayLabel.text = [@"Car of The Day: " stringByAppendingString:currentMedia.Description];
            
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

-(void)SetCOTDSpecImages: (HomePageMedia *)currentMedia
{
    NSString *spec1 = currentMedia.SpecType1;
    NSString *spec2 = currentMedia.SpecType2;
    
    if ([spec1 isEqualToString:@"Price"])
        SpecImage1.image = [UIImage imageNamed:@"PriceIcon.png"];
    if ([spec1 isEqualToString:@"Engine"])
        SpecImage1.image = [UIImage imageNamed:@"EngineIcon.png"];
    if ([spec1 isEqualToString:@"Horsepower"])
        SpecImage1.image = [UIImage imageNamed:@"Horsepower Icon.png"];
    if ([spec1 isEqualToString:@"0-60"])
        SpecImage1.image = [UIImage imageNamed:@"0-60Home.png"];
    if ([spec1 isEqualToString:@"Top Speed"])
        SpecImage1.image = [UIImage imageNamed:@"TopSpeedIcon.png"];
    if ([spec1 isEqualToString:@"Fuel Economy"])
        SpecImage1.image = [UIImage imageNamed:@"fuelEconomyIcon.png"];
    
    if ([spec2 isEqualToString:@"Price"])
        SpecImage2.image = [UIImage imageNamed:@"PriceIcon.png"];
    if ([spec2 isEqualToString:@"Engine"])
        SpecImage2.image = [UIImage imageNamed:@"EngineIcon.png"];
    if ([spec2 isEqualToString:@"Horsepower"])
        SpecImage2.image = [UIImage imageNamed:@"Horsepower Icon.png"];
    if ([spec2 isEqualToString:@"0-60"])
        SpecImage2.image = [UIImage imageNamed:@"0-60Home.png"];
    if ([spec2 isEqualToString:@"Top Speed"])
        SpecImage2.image = [UIImage imageNamed:@"TopSpeedIcon.png"];
    if ([spec2 isEqualToString:@"Fuel Economy"])
        SpecImage2.image = [UIImage imageNamed:@"fuelEconomyIcon.png"];
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

- (void)addLinearGradientToView:(UIView *)theView withColor:(UIColor *)theColor transparentToOpaque:(BOOL)transparentToOpaque
{
    gradient = [CAGradientLayer layer];
    
    //the gradient layer must be positioned at the origin of the view
    CGRect gradientFrame = theView.frame;
    gradientFrame.origin.x = 0;
    gradientFrame.origin.y = 0;
    gradient.frame = gradientFrame;
    
    //build the colors array for the gradient
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[[theColor colorWithAlphaComponent:0.05f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.1f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.15f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.2f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.25f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.3f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.35f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.3f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.25f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.2f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.15f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.1f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.05f] CGColor],
                       nil];
    
    //reverse the color array if needed
    if(transparentToOpaque)
    {
        colors = [[colors reverseObjectEnumerator] allObjects];
    }
    
    //apply the colors and the gradient to the view
    gradient.colors = colors;
    
    [theView.layer insertSublayer:gradient atIndex:0];
    gradient.masksToBounds = YES;
}

- (void) COTDSelected:(UITapGestureRecognizer *) tap
{
    //[self addLinearGradientToView:CardView1 withColor:[UIColor blackColor] transparentToOpaque:NO];
    CardView1.backgroundColor = [UIColor grayColor];
    [self performSegueWithIdentifier:@"pushDetailView" sender:self];
}

- (void) ArticleSelected: (UITapGestureRecognizer *) tap
{
    selectedNews = NULL;
    CardView2.backgroundColor = [UIColor grayColor];
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
    selectedNews = NULL;
    CardView3.backgroundColor = [UIColor grayColor];
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
    currentRaceID = NULL;
    CardView4.backgroundColor = [UIColor grayColor];
    HomePageMedia *currentMedia = [racesArray objectAtIndex:pageControl4.currentPage];
    
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (int i = 0; i < appdel.raceListArray.count; i++)
    {
        Race *currentRace = [appdel.raceListArray objectAtIndex:i];
        if([currentRace.RaceName isEqualToString:currentMedia.Description])
            currentRaceID = currentRace;
    }
    
    NSLog(@"currentracid.racetype %@", currentRaceID.RaceType);
    
    if ([currentRaceID.RaceType isEqualToString:@"Formula 1"])
        [self performSegueWithIdentifier:@"pushFormula1" sender:self];
    if ([currentRaceID.RaceType isEqualToString:@"Nascar"])
        [self performSegueWithIdentifier:@"pushNascar" sender:self];
    if ([currentRaceID.RaceType isEqualToString:@"Indy Car"])
        [self performSegueWithIdentifier:@"pushIndyCar" sender:self];
    if ([currentRaceID.RaceType isEqualToString:@"FIA"])
        [self performSegueWithIdentifier:@"pushFIA" sender:self];
    if ([currentRaceID.RaceType isEqualToString:@"WRC"])
        [self performSegueWithIdentifier:@"pushWRC" sender:self];
}

- (void) NewCarSelected: (UITapGestureRecognizer *)tap
{
    CardView5.backgroundColor = [UIColor grayColor];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.navigationController.navigationBar.topItem.title = @"";

    if ([[segue identifier] isEqualToString:@"pushDetailView"])
        [[segue destinationViewController] getCarOfTheDay:currentCarOfTheDay];
    if ([[segue identifier] isEqualToString:@"pushNewCar"])
        [[segue destinationViewController] getCarOfTheDay:currentNewCar];
    if ([[segue identifier] isEqualToString:@"pushArticle"])
        [[segue destinationViewController] getNews:selectedNews];
    if ([[segue identifier] isEqualToString:@"pushVideo"])
        [[segue destinationViewController] getNews:selectedNews];
    if ([[segue identifier] isEqualToString:@"pushFormula1"] || [[segue identifier] isEqualToString:@"pushNascar"] || [[segue identifier] isEqualToString:@"pushIndyCar"] || [[segue identifier] isEqualToString:@"pushFIA"] || [[segue identifier] isEqualToString:@"pushWRC"])
    {
        [[segue destinationViewController] getRaceResults:currentRaceID];
    }
}

@end
