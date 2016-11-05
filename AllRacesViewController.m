//
//  AllRacesViewController.m
//  Carhub
//
//  Created by Christoper Clark on 8/26/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "AllRacesViewController.h"
#import "AppDelegate.h"
#import "RaceTableCell.h"
#import "Race.h"
#import "RaceType.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "PageItemController.h"
#import <Google/Analytics.h>

@interface AllRacesViewController ()

@end

@implementation AllRacesViewController
@synthesize RacesArray, searchBar, searchArray, searchBarActive, upperView, selectedCell, raceToSend;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.title = @"All Races";
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:self.title];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    searchArray = [NSMutableArray new];
    [self addSearchBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    if(![self.searchBar.text isEqualToString:@""])
        self.searchBarActive = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.searchBar resignFirstResponder];
    [selectedCell.raceImageView setAlpha:1];
    [selectedCell.raceClassImageView setAlpha:1];
    [selectedCell.raceDateLabel setAlpha:1];
    [selectedCell.raceNameLabel setAlpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.searchBarActive && searchArray.count == 0)
    {
        UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
        noDataLabel.text = @"No Results";
        noDataLabel.textColor = [UIColor blackColor];
        noDataLabel.font = [UIFont fontWithName:@"MavenProRegular" size:18];
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        self.tableView.backgroundView = noDataLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
        self.tableView.backgroundView = nil;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.searchBarActive)
        return searchArray.count;
    else
        return RacesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RaceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RaceTableCell" forIndexPath:indexPath];
    Race *raceObject;
    
    if(self.searchBarActive)
        raceObject = [self.searchArray objectAtIndex:indexPath.row];
    else
        raceObject = [RacesArray objectAtIndex:indexPath.row];
    
    NSURL *imageURL;
    if([raceObject.RaceImageURL containsString:@"raceno"])
        imageURL = [NSURL URLWithString:raceObject.RaceImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/raceimage.php"]];
    else
        imageURL = [NSURL URLWithString:raceObject.RaceImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.color = [UIColor blackColor];
    activityIndicator.center = cell.imageScroller.center;
    [cell.cardView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [cell.raceImageView sd_setImageWithURL:imageURL
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                  [activityIndicator stopAnimating];
                                  [cell.raceImageView setAlpha:0.0];
                                  [UIImageView animateWithDuration:0.5 animations:^{
                                      [cell.raceImageView setAlpha:1.0];
                                  }];
                              }];
    
    RaceType *raceTypeObject = [self findRaceTypeFromRaceObject:raceObject];
    
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
    
    cell.raceNameLabel.text = raceObject.RaceName;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy"];
    cell.raceDateLabel.text = [formatter stringFromDate:raceObject.RaceDate];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
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

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:1];
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    dispatch_async(dispatch_get_main_queue(), ^{

    CGFloat top = 0, left = 0;
    if (scrollView.contentSize.width < scrollView.bounds.size.width) {
        left = (scrollView.bounds.size.width-scrollView.contentSize.width) * 0.5f;
    }
    if (scrollView.contentSize.height < scrollView.bounds.size.height) {
        top = (scrollView.bounds.size.height-scrollView.contentSize.height) * 0.5f;
    }
    scrollView.contentInset = UIEdgeInsetsMake(top, left, top, left);
    });
}

-(RaceType *)findRaceTypeFromRaceObject:(Race *)raceObject
{
    NSString *raceTypeString = raceObject.RaceType;
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *raceTypeArray = [[NSArray alloc]initWithArray:appdel.raceTypeArray];
    
    RaceType *currentType;
    
    for(int i=0; i<raceTypeArray.count; i++)
    {
        RaceType *type = [raceTypeArray objectAtIndex:i];
        if([type.RaceTypeString isEqualToString:raceTypeString])
            currentType = type;
    }
    return currentType;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.tableView)
    {
        BOOL shouldRetainActiveSearchBar = NO;
        
        if(self.searchBarActive)
        shouldRetainActiveSearchBar = YES;
        
        [self.view endEditing:NO];
        
        if(shouldRetainActiveSearchBar)
        self.searchBarActive = YES;
    }
}

#pragma mark - search
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultsPredicate = [NSPredicate predicateWithFormat:@"(SELF.RaceName contains [search] %@) OR (SELF.RaceType contains [search] %@)", searchText, searchText];
    self.searchArray = [[self.RacesArray filteredArrayUsingPredicate:resultsPredicate]mutableCopy];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // user did type something, check our datasource for text that looks the same
    if (searchText.length>0)
    {
        // search and reload data source
        self.searchBarActive = YES;
        [self filterContentForSearchText:searchText scope:[[self.searchBar scopeButtonTitles] objectAtIndex:[self.searchBar selectedScopeButtonIndex]]];
        [self.tableView reloadData];
    }else{
        // if text lenght == 0
        // we will consider the searchbar is not active
        self.searchArray = self.RacesArray;
        [self.tableView reloadData];
        self.searchBarActive = NO;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self cancelSearching];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchBarActive = YES;
    [self.view endEditing:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.searchBarActive = NO;
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

-(void)cancelSearching
{
    self.searchBarActive = NO;
    [self.searchBar resignFirstResponder];
    self.searchBar.text  = @"";
}

-(void)addSearchBar
{
    if (!self.searchBar)
    {
        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        self.searchBar.searchBarStyle       = UISearchBarStyleMinimal;
        self.searchBar.tintColor            = [UIColor grayColor];
        self.searchBar.barTintColor         = [UIColor grayColor];
        self.searchBar.delegate             = self;
        self.searchBar.placeholder          = @"Search";
        
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor blackColor]];
    }
    
    if (![self.searchBar isDescendantOfView:self.view])
        [self.upperView addSubview:self.searchBar];
}

-(void)setUpAllRacesArray
{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RacesArray = [[NSMutableArray alloc]initWithArray:appdel.raceListArray];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"RaceDate" ascending:NO];
    [RacesArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.searchBarActive)
        raceToSend = [searchArray objectAtIndex:indexPath.row];
    else
        raceToSend = [RacesArray objectAtIndex:indexPath.row];
    
    selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    [selectedCell.raceImageView setAlpha:.3];
    [selectedCell.raceClassImageView setAlpha:.3];
    [selectedCell.raceDateLabel setAlpha:.3];
    [selectedCell.raceNameLabel setAlpha:.3];
    
    if([raceToSend.RaceType isEqualToString:@"Formula 1"] || [raceToSend.RaceType isEqualToString:@"Supercars Championship"])
        [self performSegueWithIdentifier:@"pushResults1" sender:self];
    if([raceToSend.RaceType isEqualToString:@"NASCAR"])
        [self performSegueWithIdentifier:@"pushResults2" sender:self];
    if([raceToSend.RaceType isEqualToString:@"FIA World Endurance Championship"])
        [self performSegueWithIdentifier:@"pushResults3" sender:self];
    if([raceToSend.RaceType isEqualToString:@"IndyCar"])
        [self performSegueWithIdentifier:@"pushResults4" sender:self];
    if([raceToSend.RaceType isEqualToString:@"DTM"])
        [self performSegueWithIdentifier:@"pushResults5" sender:self];
    if([raceToSend.RaceType isEqualToString:@"WRC"] || [raceToSend.RaceType isEqualToString:@"Formula E"])
        [self performSegueWithIdentifier:@"pushResults6" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushResults1"] || [[segue identifier] isEqualToString:@"pushResults2"] || [[segue identifier] isEqualToString:@"pushResults3"] || [[segue identifier] isEqualToString:@"pushResults4"] || [[segue identifier] isEqualToString:@"pushResults5"] || [[segue identifier] isEqualToString:@"pushResults6"])
    {
        [[segue destinationViewController] getRaceResults:raceToSend];
    }
}

@end
