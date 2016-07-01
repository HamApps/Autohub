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

@interface RaceTypeViewController ()

@end

@implementation RaceTypeViewController
@synthesize raceTypeArray, recentRacesArray, raceTypeID, TableView, RecentRacesCV, RaceClassCV, CardView1, CardView2, pageControl1, pageControl2, recentRace;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self SetUpCardViews];
    [self SetScrollDirections];
    [self makeAppDelRaceTypeArray];
    [self makeAppDelRecentRacesArray];
    [self setUpNavigationGestures];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
    
    self.barButton.target = self.revealViewController;
    self.barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.view.backgroundColor = [UIColor whiteColor];
    self.TableView.separatorColor = [UIColor clearColor];
    self.title = @"Race Results";
    
    pageControl1.numberOfPages =  recentRacesArray.count;
    pageControl2.numberOfPages =  raceTypeArray.count;
}

-(void)viewDidDisappear:(BOOL)animated
{
    CardView1.backgroundColor = [UIColor whiteColor];
    CardView2.backgroundColor = [UIColor whiteColor];
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
    HomepageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
    
    if (collectionView == RaceClassCV)
    {
        RaceType * raceTypeObject = [self.raceTypeArray objectAtIndex:indexPath.row];
    
        NSURL *imageURL;
        if([raceTypeObject.TypeImageURL containsString:@"carno"])
            imageURL = [NSURL URLWithString:raceTypeObject.TypeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
        else
            imageURL = [NSURL URLWithString:raceTypeObject.TypeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
        
        [cell.CellImageView setImageWithURL:imageURL
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                     [cell.CellImageView setAlpha:0.0];
                                     [UIImageView animateWithDuration:0.5 animations:^{
                                         [cell.CellImageView setAlpha:1.0];
                                     }];
                                 }
                usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    cell.DescriptionLabel.text = raceTypeObject.RaceTypeString;
    cell.backgroundColor = [UIColor whiteColor];
    }
    
    if (collectionView == RecentRacesCV)
    {
        HomePageMedia * raceObject = [self.recentRacesArray objectAtIndex:indexPath.row];
        
        NSURL *imageURL;
        if([raceObject.ImageURL containsString:@"raceno"])
            imageURL = [NSURL URLWithString:raceObject.ImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/raceimage.php"]];
        else
            imageURL = [NSURL URLWithString:raceObject.ImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
        
        //Load and fade image
        [cell.CellImageView setImageWithURL:imageURL
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                         [cell.CellImageView setAlpha:0.0];
                                         [UIImageView animateWithDuration:0.5 animations:^{
                                             [cell.CellImageView setAlpha:1.0];
                                         }];
                                     }
                usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        cell.DescriptionLabel.text = raceObject.Description;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
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
}

-(void)SetUpCard:(UIView *)CardView
{
    [CardView setAlpha:1];
    CardView.layer.masksToBounds = NO;
    CardView.layer.cornerRadius = 10;
    CardView.layer.shadowOffset = CGSizeMake(-.2f, .2f);
    CardView.layer.shadowRadius = 1;
    CardView.layer.shadowOpacity = .75;
    CardView.backgroundColor = [UIColor whiteColor];
    
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
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [raceTypeArray addObjectsFromArray:appdel.raceTypeArray];
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
    
    NSLog(@"recentracescount: %@",recentRacesArray);
}


#pragma mark - Navigation

-(void)setUpNavigationGestures
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(RecentRaceSelected:)];
    [CardView1 addGestureRecognizer: tap];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(RaceTypeSelected:)];
    [CardView2 addGestureRecognizer: tap2];
}

- (void) RecentRaceSelected: (UITapGestureRecognizer *) tap
{
    recentRace = NULL;
    CardView1.backgroundColor = [UIColor grayColor];
    HomePageMedia * selectedMedia = [recentRacesArray objectAtIndex:pageControl1.currentPage];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (int i = 0; i<appdel.raceListArray.count; i++)
    {
        Race *currentRace = [appdel.raceListArray objectAtIndex:i];
        if ([currentRace.RaceName isEqualToString:selectedMedia.Description])
            recentRace = currentRace;
    }

    [self performSegueWithIdentifier:@"pushResults" sender:self];
}

- (void) RaceTypeSelected: (UITapGestureRecognizer *) tap
{
    CardView2.backgroundColor = [UIColor grayColor];
    [self performSegueWithIdentifier:@"pushRaceType" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    raceTypeID = [raceTypeArray objectAtIndex:pageControl2.currentPage];
    
    if ([[segue identifier] isEqualToString:@"pushRaceType"])
    {
        [[segue destinationViewController] getRaceTypeID:raceTypeID];
    }
    if ([[segue identifier] isEqualToString:@"pushResults"])
    {
        [[segue destinationViewController] getRaceResults:recentRace];
    }
}

@end
