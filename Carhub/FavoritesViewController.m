//
//  FavoritesViewController.m
//  Carhub
//
//  Created by Christopher Clark on 8/23/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "FavoritesViewController.h"
#import "DetailViewController.h"
#import "FavCell.h"
#import "Model.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Model.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import <Google/Analytics.h>

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

@synthesize searchArray, ModelArray, editButton, objectToSend, sendingIndex, detailImageScroller, detailView, detailCell, initialCellFrame, initialScrollerFrame, titleString, tableView, yCenter, yCenterModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self loadSavedCars];
    
    self.barButton.target = self;
    self.barButton.action = @selector(removeKeyboardAndRevealToggle);
    
    UIBarButtonItem *navBarButtonAppearance = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    [navBarButtonAppearance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName: [UIColor blackColor] }forState:UIControlStateNormal];
    
    editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style: UIBarButtonItemStylePlain target:self action:@selector(enterEditMode:)];
    editButton.tintColor = [UIColor blackColor];
    [self.navigationItem setRightBarButtonItem:editButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewData) name:@"ReloadRootViewControllerTable" object:nil];
    
    self.title = @"Favorite Cars";
    titleString = self.title;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:self.title];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    searchArray = [NSMutableArray new];
    [self addSearchBar];
    
    yCenter = 0;
    yCenterModel = 0;
    int height = [UIScreen mainScreen].bounds.size.height;
    if (height == 480) {
        yCenter = 180;
        yCenterModel = 200;
    } if (height == 568) {
        yCenter = 180;
        yCenterModel = 200;
    } if (height == 667) {
        yCenter = 200;
        yCenterModel = 220;
    } if (height == 736) {
        yCenter = 208;
        yCenterModel = 230;
    }
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

-(void)viewWillDisappear:(BOOL)animated
{
    UIBarButtonItem *navBarButtonAppearance = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    [navBarButtonAppearance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:0.1], NSForegroundColorAttributeName: [UIColor clearColor] }forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
        return self.searchArray.count;
    else
        return self.ModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ModelCell";
    FavCell *cell = (FavCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil)
    {
        cell = [[FavCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Model * modelObject;
    if(self.searchBarActive)
        modelObject = [self.searchArray objectAtIndex:indexPath.row];
    else
        modelObject = [self.ModelArray objectAtIndex:indexPath.row];
    
    [cell setUpCarImageWithModel:modelObject];

    if([self.editButton.title isEqualToString:@"Edit"])
    {
        UITapGestureRecognizer *tappedCell = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedImage:)];
        [cell addGestureRecognizer:tappedCell];
    }
    
    cell.CarName.text = modelObject.CarFullName;
    
    cell.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.cardView.bounds.origin.y+35, CGRectGetWidth(cell.cardView.bounds), 1.5)];
    
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

#pragma mark - search
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultsPredicate = [NSPredicate predicateWithFormat:@"SELF.CarFullName contains [search] %@", searchText];
    self.searchArray = [[self.ModelArray filteredArrayUsingPredicate:resultsPredicate]mutableCopy];
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
        self.searchArray = self.ModelArray;
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

-(void)tappedImage:(UITapGestureRecognizer *)sender
{
    UIView *view = sender.view;
    CGPoint hitPoint = [view convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    [self.tableView selectRowAtIndexPath:hitIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:hitIndex];
}

-(void)loadSavedCars;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ModelArray = [[NSMutableArray alloc]init];
    NSData *retrievedData = [defaults objectForKey:@"savedArray"];
    ModelArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
    [defaults synchronize];
}

-(void) reloadTableViewData
{
    [self loadSavedCars];
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    FavCell *cell = (FavCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    while (cell.gestureRecognizers.count)
        [cell removeGestureRecognizer:[cell.gestureRecognizers objectAtIndex:0]];
    
    return YES;
}

- (IBAction)enterEditMode:(id)sender
{
    if ([self.tableView isEditing])
    {
        [self.tableView setEditing:NO animated:YES];
        [self.editButton setTitle:@"Edit"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    else
    {
        [self.editButton setTitle:@"Done"];
        [self.tableView setEditing:YES animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableView beginUpdates];
        [ModelArray removeObjectAtIndex:indexPath.row];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:ModelArray];
        [defaults setObject:arrayData forKey:@"savedArray"];
        [defaults synchronize];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self loadSavedCars];
        [self.tableView endUpdates];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeStar" object:nil];
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.tableView reloadData];
        });
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    sendingIndex = indexPath;
    [self pushDetailWithIndexPath:indexPath];
}

-(void)pushDetailWithIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    FavCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    detailCell = selectedCell;
    
    Model *pushingObject;
    if(self.searchBarActive)
        pushingObject = [self.searchArray objectAtIndex:indexPath.row];
    else
        pushingObject = [self.ModelArray objectAtIndex:indexPath.row];
    
    [self.searchBar resignFirstResponder];
    
    objectToSend = pushingObject;
    
    [detailCell.imageScroller2 setAlpha:.5];
    [detailCell.CarName setAlpha:.5];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [detailCell.imageScroller2 setAlpha:1];
        [detailCell.CarName setAlpha:1];
    });
    
    CGRect newFrame = [self.view convertRect:selectedCell.frame fromView:selectedCell.superview];
    initialCellFrame = newFrame;
    initialScrollerFrame = selectedCell.imageScroller2.frame;
    CGRect newFrame2 = [self.view convertRect:selectedCell.imageScroller2.frame fromView:selectedCell.imageScroller2.superview];
    detailImageScroller = selectedCell.imageScroller2;
    [self.view addSubview:selectedCell];
    [self.view addSubview:detailImageScroller];
    [selectedCell setFrame:newFrame];
    [detailImageScroller setFrame:newFrame2];
    
    [UIView animateWithDuration:.5 animations:^{
        [self.tableView setAlpha:0.0];
        [selectedCell setAlpha:0.0];
        [selectedCell setCenter:CGPointMake(self.view.frame.size.width/2, yCenter)];
        [detailImageScroller setCenter:CGPointMake(self.view.frame.size.width/2, yCenter)];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [self setTitleLabelWithString:pushingObject.CarMake];
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit46.png"] style:UIBarButtonItemStyleDone target:self action:@selector(pushSpecsDispute)];
        item.tintColor = [UIColor blackColor];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:NULL];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
        [self.navigationItem setRightBarButtonItem:item];
        
        detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        detailView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        detailView.view.alpha = 0.0;
        
        [detailView getCarToLoad:pushingObject sender:self];
        
        [UIView animateWithDuration:1 animations:^{
            [self addChildViewController:detailView];
            [self.view addSubview:detailView.view];
            [self.view sendSubviewToBack:detailView.view];
            [detailView didMoveToParentViewController:self];
            detailView.view.alpha = 1.0;
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            CGRect newFrame = [detailView.specsCollectionView convertRect:detailImageScroller.frame fromView:self.view];
            [detailView.specsCollectionView addSubview:detailImageScroller];
            [detailImageScroller setFrame:newFrame];
            [backButton setAction:@selector(revertToFavoritesPage)];
            
            UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedDown:)];
            downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
            [detailImageScroller addGestureRecognizer:downSwipe];
            [detailView.specsCollectionView.panGestureRecognizer requireGestureRecognizerToFail:downSwipe];
            
            UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:detailView action:@selector(tappedImage:)];
            [detailImageScroller addGestureRecognizer:tapImage];
        });
    });
}

-(void)removeDownSwipe
{
    for (UIGestureRecognizer *recognizer in detailImageScroller.gestureRecognizers)
    {
        [detailImageScroller removeGestureRecognizer:recognizer];
    }
}

-(void)swipedDown:(UISwipeGestureRecognizer *)sender
{
    [self revertToFavoritesPage];
}

-(void)revertToFavoritesPage
{
    [UIView animateWithDuration:0.5 animations:^{
        [detailCell setFrame:initialCellFrame];
    }];
    
    [self viewWillAppear:YES];
    CGRect frameInView = [self.view convertRect:detailImageScroller.frame fromView:detailView.view];
    [self.view addSubview:detailImageScroller];
    [detailImageScroller setFrame:frameInView];
    [detailImageScroller setFrame:initialScrollerFrame];
    [detailCell.cardView addSubview:detailImageScroller];
    [self removeDownSwipe];
    [detailCell lineViewSetUp];
    [detailCell setAlpha:1.0];
    [detailView.view setAlpha:0.0];
    [self.tableView setAlpha:1.0];
    
    [self setTitleLabelWithString:titleString];
    
    [self.navigationItem setLeftBarButtonItems:nil];
    self.barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"lines7.png"] style:UIBarButtonItemStylePlain target:self action:@selector(removeKeyboardAndRevealToggle)];
    [self.barButton setTintColor:[UIColor blackColor]];
    [self.navigationItem setLeftBarButtonItem: self.barButton];
    
    editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style: UIBarButtonItemStylePlain target:self action:@selector(enterEditMode:)];
    editButton.tintColor = [UIColor blackColor];
    [self.navigationItem setRightBarButtonItem:editButton];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        CGRect cellFrameInTable = [self.tableView convertRect:detailCell.frame fromView:self.view];
        [detailCell setFrame:cellFrameInTable];
        [self.tableView addSubview:detailCell];
        
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        //});
        
        [detailView didMoveToParentViewController:nil];
        [detailView.view removeFromSuperview];
        [detailView removeFromParentViewController];
    });
}

-(void)setTitleLabelWithString:(NSString *)title
{
    [self setTitle:title];
}

-(void)pushSpecsDispute
{
    [self performSegueWithIdentifier:@"pushSpecsDispute" sender:self];
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)unwindToFavorites:(UIStoryboardSegue *)segue
{
    [self revertToFavoritesPage];
}

@end
