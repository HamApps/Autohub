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

@interface PageItemController ()

@end

@implementation PageItemController
@synthesize itemIndex, imageName, currentRaceResultsArray, resultsTableView, currentRace, raceImagesCV, currentRaceImagesArray, pageControl1;

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [resultsTableView setDelegate:self];
    [resultsTableView setDataSource:self];
    self.resultsTableView.separatorColor = [UIColor clearColor];
    
    pageControl1.numberOfPages = currentRaceImagesArray.count;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)[self.raceImagesCV collectionViewLayout];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return currentRaceResultsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height = [UIScreen mainScreen].bounds.size.height;
    if (height == 667)
        return 50;
    else if (height == 736)
        return 50;
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RaceCell";
    RaceResultCell *cell = (RaceResultCell *)[self.resultsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[RaceResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if ((indexPath.row % 2) == 0)
        cell.cardView.backgroundColor = [UIColor lightGrayColor];
    else
        cell.cardView.backgroundColor = [UIColor whiteColor];
    
    
    RaceResult * raceResultObject;
    
    raceResultObject = [currentRaceResultsArray objectAtIndex:indexPath.row];
    
    cell.positionLabel.text = raceResultObject.Position;
    cell.driverLabel.text = raceResultObject.Driver;
    cell.teamLabel.text = raceResultObject.Team;
    cell.countryLabel.text = raceResultObject.Country;
    cell.CarLabel.text = raceResultObject.Car;
    cell.timeLabel.text = raceResultObject.Time;
    cell.bestLapTimeLabel.text = raceResultObject.BestLapTime;
    cell.RaceClass.text = raceResultObject.RaceClass;
    
    CALayer * circle = [cell.positionLabel layer];
    [circle setMasksToBounds:YES];
    [circle setCornerRadius:15.0];
    [circle setBorderWidth:2.0];
    [circle setBorderColor:[[UIColor colorWithRed:(214/255.0) green:(38/255.0) blue:(19/255.0) alpha:1] CGColor]];
    
    return cell;
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
                                         }];
                                     }
            usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
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

#pragma mark -
#pragma mark Content

-(void)getRaceResults:(id)currentRaceID
{
    currentRace = currentRaceID;
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    currentRaceResultsArray = [[NSMutableArray alloc]init];
    
    NSLog(@"currentrace: %@", currentRace.RaceName);
    
    for(int i=0; i<appdel.raceResultsArray.count; i++)
    {
        RaceResult *raceResult = [appdel.raceResultsArray objectAtIndex:i];
        
        if([raceResult.RaceID isEqualToString:currentRace.RaceName])
            [currentRaceResultsArray addObject:[appdel.raceResultsArray objectAtIndex:i]];
    }
    
    currentRaceImagesArray = [[NSMutableArray alloc]init];
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
