//
//  MakeViewController.m
//  Carhub
//
//  Created by Christopher Clark on 8/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "AppDelegate.h"
#import "MakeViewController.h"
#import "MakeCell.h"
#import "BackgroundLayer.h"
#import "Make.h"
#import "Model.h"
#import "ModelViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import <Google/Analytics.h>

@interface MakeViewController ()

@end

@implementation MakeViewController
@synthesize makeimageArray, currentMake, modelArray, searchmakeimageArray, selectedCell, shouldHaveBackButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    searchmakeimageArray = [NSMutableArray new];
    [self addSearchBar];
    
    if(shouldHaveBackButton == NO)
    {
        self.barButton.target = self;
        self.barButton.action = @selector(removeKeyboardAndRevealToggle);
    }
    
    [self makeAppDelMakeArray];
    self.title = @"Makes";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.collectionView setAlwaysBounceVertical:YES];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Traditional Makes"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

-(void)removeKeyboardAndRevealToggle
{
    [self.searchBar resignFirstResponder];
    [self.revealViewController performSelectorOnMainThread:@selector(revealToggle:) withObject:nil waitUntilDone:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    if(![self.searchBar.text isEqualToString:@""])
        self.searchBarActive = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    if(selectedCell != nil)
    {
        [selectedCell.MakeImageView setAlpha:1];
        [selectedCell.MakeNameLabel setAlpha:1];
    }
}

-(void)dealloc
{
    // remove Our KVO observer
    [self removeObservers];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(self.searchBarActive && searchmakeimageArray.count == 0)
    {
        UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height)];
        noDataLabel.text = @"No Results";
        noDataLabel.textColor = [UIColor blackColor];
        noDataLabel.font = [UIFont fontWithName:@"MavenProRegular" size:18];
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        self.collectionView.backgroundView = noDataLabel;
    }
    else
        self.collectionView.backgroundView = nil;
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(self.searchBarActive)
        return searchmakeimageArray.count;
    return makeimageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MakeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MakeReuseID" forIndexPath:indexPath];
    Make * makeObject;
    if(self.searchBarActive)
        makeObject = [searchmakeimageArray objectAtIndex:indexPath.item];
    else
        makeObject = [makeimageArray objectAtIndex:indexPath.item];
    
    cell.layer.borderColor=[UIColor clearColor].CGColor;
    
    NSURL *imageURL;
    if([makeObject.MakeImageURL containsString:@"carno"])
        imageURL = [NSURL URLWithString:makeObject.MakeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image2.php"]];
    else
        imageURL = [NSURL URLWithString:makeObject.MakeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.color = [UIColor blackColor];
    activityIndicator.center = cell.MakeImageView.center;
    [cell.cardView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [cell.MakeImageView sd_setImageWithURL:imageURL
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                 [activityIndicator stopAnimating];
                                 [cell.MakeImageView setAlpha:0.0];
                                 
                                 [cell.MakeImageView setImage:[self scaleImage:image toSize:cell.MakeImageView.frame.size]];
                                 
                                 [UIImageView animateWithDuration:0.5 animations:^{
                                     [cell.MakeImageView setAlpha:1.0];
                                 }];
                             }];
    
    cell.MakeNameLabel.text=makeObject.MakeName;
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BOOL shouldRetainActiveSearchBar = NO;
    
    if(self.searchBarActive)
        shouldRetainActiveSearchBar = YES;
    
    [self.view endEditing:NO];
    
    if(shouldRetainActiveSearchBar)
        self.searchBarActive = YES;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(self.searchBar.frame.size.height, 0, 0, 0);
}

#pragma mark - search
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate    = [NSPredicate predicateWithFormat:@"SELF.MakeName contains[c] %@", searchText];
    self.searchmakeimageArray  = [[self.makeimageArray filteredArrayUsingPredicate:resultPredicate]mutableCopy];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // user did type something, check our datasource for text that looks the same
    if (searchText.length>0)
    {
        // search and reload data source
        self.searchBarActive = YES;
        [self filterContentForSearchText:searchText scope:[[self.searchBar scopeButtonTitles] objectAtIndex:[self.searchBar selectedScopeButtonIndex]]];
        [self.collectionView reloadData];
    }else{
        // if text lenght == 0
        // we will consider the searchbar is not active
        self.searchmakeimageArray = self.makeimageArray;
        [self.collectionView reloadData];
        self.searchBarActive = NO;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self cancelSearching];
    [self.collectionView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchBarActive = YES;
    [self.view endEditing:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // we used here to set self.searchBarActive = YES
    // but we'll not do that any more... it made problems
    // it's better to set self.searchBarActive = YES when user typed something
    [self.searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // this method is being called when search btn in the keyboard tapped
    // we set searchBarActive = NO
    // but no need to reloadCollectionView
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
        self.searchBarBoundsY = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,self.searchBarBoundsY, [UIScreen mainScreen].bounds.size.width, 44)];
        self.searchBar.searchBarStyle       = UISearchBarStyleMinimal;
        self.searchBar.tintColor            = [UIColor grayColor];
        self.searchBar.barTintColor         = [UIColor grayColor];
        self.searchBar.delegate             = self;
        self.searchBar.placeholder          = @"Search";
        
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor blackColor]];
        
        // add KVO observer.. so we will be informed when user scroll colllectionView
        [self addObservers];
    }
    
    if (![self.searchBar isDescendantOfView:self.view])
        [self.view addSubview:self.searchBar];
}

#pragma mark - observer
- (void)addObservers
{
    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
- (void)removeObservers
{
    [self.collectionView removeObserver:self forKeyPath:@"contentOffset" context:Nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UICollectionView *)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"] && object == self.collectionView )
    {
        self.searchBar.frame = CGRectMake(self.searchBar.frame.origin.x, self.searchBarBoundsY + ((-1* object.contentOffset.y)-self.searchBarBoundsY), self.searchBar.frame.size.width, self.searchBar.frame.size.height);
    }
}

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize
{
    float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    //indent in case of width or height difference
    float offset = (width - height) / 2;
    if (offset > 0) {
        rect.origin.y = offset;
    }
    else {
        rect.origin.x = -offset;
    }
    
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
}

#pragma mark - Navigation

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedCell = (MakeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [selectedCell.MakeImageView setAlpha:.5];
    [selectedCell.MakeNameLabel setAlpha:.5];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushNewMakes"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"Horizontal Scroll" forKey:@"Makes Layout Preference"];
    }
    if ([[segue identifier] isEqualToString:@"pushModelView"])
    {
        NSIndexPath * indexPath = [self.collectionView indexPathForCell:sender];
        Make * makeobject;
        if(self.searchBarActive)
            makeobject = [searchmakeimageArray objectAtIndex:indexPath.row];
        else
            makeobject = [makeimageArray objectAtIndex:indexPath.row];
        [[segue destinationViewController] getMake:makeobject];
    }
}

-(void)setUpUnwindToCompare
{
    shouldHaveBackButton = YES;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:@selector(unwindToCompare)];
    backButton.tintColor = [UIColor blackColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -9;
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
}

-(void)unwindToCompare
{
    [self performSegueWithIdentifier:@"unwindToCompareVC" sender:self];
}

- (void) makeAppDelMakeArray;
{
    makeimageArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [makeimageArray addObjectsFromArray:appdel.makeimageArray2];
}

@end
