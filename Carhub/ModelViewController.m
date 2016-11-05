//
//  ModelViewController.m
//  Carhub
//
//  Created by Christopher Clark on 8/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "ModelViewController.h"
#import "MakeViewController.h"
#import "Model.h"
#import "CarViewCell.h"
#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "NewMakesViewController.h"
#import <Google/Analytics.h>

@interface ModelViewController ()

@end

@implementation ModelViewController
@synthesize currentMake, ModelArray, appdelmodelArray, currentClass, currentSubclass, cellToSlide, initialCellFrame, sendingIndex, detailCell, initialScrollerFrame, detailImageScroller, detailView, isFromModels, isFromMakes, titleString, pushingObject, currentStyle, searchArray, yCenterModel, yCenter, shouldRefreshImage;

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    shouldRefreshImage = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    //Load Model Data
    [self makeAppDelModelArray];
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

-(void)viewWillAppear:(BOOL)animated
{
    if(![self.searchBar.text isEqualToString:@""])
        self.searchBarActive = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.searchBar resignFirstResponder];
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
    CarViewCell *cell = (CarViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell==nil)
    {
        cell = [[CarViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Model * modelObject;
    
    if(self.searchBarActive)
        modelObject = [self.searchArray objectAtIndex:indexPath.row];
    else
        modelObject = [self.ModelArray objectAtIndex:indexPath.row];
    
    NSURL *imageURL;
    if([modelObject.CarImageURL containsString:@"carno"])
        imageURL = [NSURL URLWithString:modelObject.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
    else
        imageURL = [NSURL URLWithString:modelObject.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];
    
    if(!shouldRefreshImage)
        [cell setUpCarImageWithModel:modelObject andAlpha:1];
    else
        [cell setUpCarImageWithModel:modelObject andAlpha:0];
    
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedImage:)];
    [cell addGestureRecognizer:tapImage];
    
    cell.CarName.text = modelObject.CarModel;
    
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

- (void)getMake:(Make *)makeObject;
{
    currentMake = makeObject;
    [self makeAppDelModelArray];
    [self filterToClassArray];
    self.title = currentMake.MakeName;
    titleString = currentMake.MakeName;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:self.title];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)getClass:(Model *)classObject sender:(id)sender;
{
    currentClass = classObject;
    [self makeAppDelModelArray];
    [self filterToSubClassArray];
    self.title = currentClass.CarModel;
    titleString = currentClass.CarModel;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:self.title];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    if([sender isKindOfClass:[NewMakesViewController class]])
    {
        isFromMakes = YES;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:@selector(returnToMakes)];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    }
    else if([sender isKindOfClass:[ModelViewController class]])
    {
        isFromModels = YES;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:@selector(returnToModel)];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    }
}

- (void)getSubclass:(Model *)subclassObject sender:(id)sender;
{
    currentSubclass = subclassObject;
    [self makeAppDelModelArray];
    [self filterToStyleArray];
    self.title = currentSubclass.CarModel;
    titleString = currentSubclass.CarModel;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:self.title];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    if([sender isKindOfClass:[NewMakesViewController class]])
    {
        isFromMakes = YES;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:@selector(returnToMakes)];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    }
    else if([sender isKindOfClass:[ModelViewController class]])
    {
        isFromModels = YES;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:@selector(returnToModel)];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    }
}

- (void)getStyle:(Model *)styleObject sender:(id)sender;
{
    currentStyle = styleObject;
    [self makeAppDelModelArray];
    [self filterToModelArray];
    self.title = currentStyle.CarModel;
    titleString = currentStyle.CarModel;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:self.title];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    if([sender isKindOfClass:[NewMakesViewController class]])
    {
        isFromMakes = YES;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:@selector(returnToMakes)];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    }
    else if([sender isKindOfClass:[ModelViewController class]])
    {
        isFromModels = YES;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:@selector(returnToModel)];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    }
}

- (void)filterToClassArray
{
    NSPredicate *MakePredicate = [NSPredicate predicateWithFormat:@"CarMake == %@", currentMake.MakeName];
    ModelArray = [appdelmodelArray filteredArrayUsingPredicate:MakePredicate];
    NSPredicate *isClassPredicate = [NSPredicate predicateWithFormat:@"isClass == %@", [NSNumber numberWithInt:1]];
    ModelArray = [ModelArray filteredArrayUsingPredicate:isClassPredicate];
}

- (void)filterToSubClassArray
{
    NSPredicate *MakePredicate = [NSPredicate predicateWithFormat:@"CarMake == %@", currentClass.CarMake];
    ModelArray = [appdelmodelArray filteredArrayUsingPredicate:MakePredicate];
    NSPredicate *ClassPredicate = [NSPredicate predicateWithFormat:@"CarClass == %@", currentClass.CarModel];
    ModelArray = [ModelArray filteredArrayUsingPredicate:ClassPredicate];
    NSPredicate *isSubclassPredicate = [NSPredicate predicateWithFormat:@"isSubclass == %@", [NSNumber numberWithInt:1]];
    ModelArray = [ModelArray filteredArrayUsingPredicate:isSubclassPredicate];
}

- (void)filterToStyleArray
{
    NSPredicate *MakePredicate = [NSPredicate predicateWithFormat:@"CarMake == %@", currentSubclass.CarMake];
    ModelArray = [appdelmodelArray filteredArrayUsingPredicate:MakePredicate];
    NSPredicate *ClassPredicate = [NSPredicate predicateWithFormat:@"CarClass == %@", currentSubclass.CarClass];
    ModelArray = [ModelArray filteredArrayUsingPredicate:ClassPredicate];
    NSPredicate *subclassPredicate = [NSPredicate predicateWithFormat:@"CarSubclass == %@", currentSubclass.CarModel];
    ModelArray = [ModelArray filteredArrayUsingPredicate:subclassPredicate];
    NSPredicate *isStylePredicate = [NSPredicate predicateWithFormat:@"isStyle == %@", [NSNumber numberWithInt:1]];
    ModelArray = [ModelArray filteredArrayUsingPredicate:isStylePredicate];
}

- (void)filterToModelArray
{
    NSPredicate *MakePredicate = [NSPredicate predicateWithFormat:@"CarMake == %@", currentStyle.CarMake];
    ModelArray = [appdelmodelArray filteredArrayUsingPredicate:MakePredicate];
    NSPredicate *ClassPredicate = [NSPredicate predicateWithFormat:@"CarClass == %@", currentStyle.CarClass];
    ModelArray = [ModelArray filteredArrayUsingPredicate:ClassPredicate];
    NSPredicate *SubclassPredicate = [NSPredicate predicateWithFormat:@"CarSubclass == %@", currentStyle.CarSubclass];
    ModelArray = [ModelArray filteredArrayUsingPredicate:SubclassPredicate];
    NSPredicate *StylePredicate = [NSPredicate predicateWithFormat:@"CarStyle == %@", currentStyle.CarModel];
    ModelArray = [ModelArray filteredArrayUsingPredicate:StylePredicate];
    NSPredicate *isModelPredicate = [NSPredicate predicateWithFormat:@"isModel == %@", [NSNumber numberWithInt:1]];
    ModelArray = [ModelArray filteredArrayUsingPredicate:isModelPredicate];
}

- (void) makeAppDelModelArray;
{
    appdelmodelArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelmodelArray addObjectsFromArray:appdel.modelArray];
}

-(void)tappedImage:(UITapGestureRecognizer *)sender
{
    UIView *view = sender.view;
    CGPoint hitPoint = [view convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    [self.tableView selectRowAtIndexPath:hitIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:hitIndex];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    sendingIndex = indexPath;
    
    if(self.searchBarActive)
        pushingObject = [self.searchArray objectAtIndex:indexPath.row];
    else
        pushingObject = [self.ModelArray objectAtIndex:indexPath.row];
    
    if([pushingObject.isModel isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        [self pushDetailWithIndexPath:indexPath];
    }
    else if([pushingObject.isClass isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        currentClass = pushingObject;
        cellToSlide = [tableView cellForRowAtIndexPath:indexPath];
        detailImageScroller = cellToSlide.imageScroller2;
        
        CGRect newFrame = [self.view convertRect:cellToSlide.frame fromView:cellToSlide.superview];
        initialCellFrame = newFrame;
        
        [cellToSlide setFrame:[self.view convertRect:cellToSlide.frame fromView:cellToSlide.superview]];
        [self.view addSubview:cellToSlide];
        
        [cellToSlide.imageScroller2 setAlpha:.5];
        [cellToSlide.CarName setAlpha:.5];
        
        [UIView animateWithDuration:.5 animations:^{
            [cellToSlide setCenter:CGPointMake(self.view.frame.size.width/2, yCenterModel)];
            [self.tableView setAlpha:0];
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"pushSubclasses" sender:self];
            [cellToSlide.imageScroller2 setAlpha:1];
            [cellToSlide.CarName setAlpha:1];
        });
    }
    else if([pushingObject.isSubclass isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        currentSubclass = pushingObject;
        cellToSlide = [tableView cellForRowAtIndexPath:indexPath];
        detailImageScroller = cellToSlide.imageScroller2;
        
        CGRect newFrame = [self.view convertRect:cellToSlide.frame fromView:cellToSlide.superview];
        initialCellFrame = newFrame;
        
        [cellToSlide setFrame:[self.view convertRect:cellToSlide.frame fromView:cellToSlide.superview]];
        [self.view addSubview:cellToSlide];
        
        [cellToSlide.imageScroller2 setAlpha:.5];
        [cellToSlide.CarName setAlpha:.5];
        
        [UIView animateWithDuration:.5 animations:^{
            [cellToSlide setCenter:CGPointMake(self.view.frame.size.width/2, yCenterModel)];
            [self.tableView setAlpha:0];
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"pushStyles" sender:self];
            [cellToSlide.imageScroller2 setAlpha:1];
            [cellToSlide.CarName setAlpha:1];
        });
    }
    else if([pushingObject.isStyle isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        currentStyle = pushingObject;
        cellToSlide = [tableView cellForRowAtIndexPath:indexPath];
        detailImageScroller = cellToSlide.imageScroller2;
        
        CGRect newFrame = [self.view convertRect:cellToSlide.frame fromView:cellToSlide.superview];
        initialCellFrame = newFrame;
        
        [cellToSlide setFrame:[self.view convertRect:cellToSlide.frame fromView:cellToSlide.superview]];
        [self.view addSubview:cellToSlide];
        
        [cellToSlide.imageScroller2 setAlpha:.5];
        [cellToSlide.CarName setAlpha:.5];
        
        [UIView animateWithDuration:.5 animations:^{
            [cellToSlide setCenter:CGPointMake(self.view.frame.size.width/2, yCenterModel)];
            [self.tableView setAlpha:0];
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"pushModels" sender:self];
            [cellToSlide.imageScroller2 setAlpha:1];
            [cellToSlide.CarName setAlpha:1];
        });
    }
}

-(void)pushDetailWithIndexPath:(NSIndexPath *)indexPath
{
    CarViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    detailCell = selectedCell;
    
    if(self.searchBarActive)
        pushingObject = [self.searchArray objectAtIndex:indexPath.row];
    else
        pushingObject = [self.ModelArray objectAtIndex:indexPath.row];
    
    [self.searchBar resignFirstResponder];
    
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
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:NULL];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit46.png"] style:UIBarButtonItemStyleDone target:self action:@selector(pushSpecsDispute)];
        item.tintColor = [UIColor blackColor];
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
            [backButton setAction:@selector(revertToModelsPage)];
            
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
    [self revertToModelsPage];
}

-(void)revertToModelsPage
{
    [UIView animateWithDuration:0.5 animations:^{
        [detailCell setFrame:initialCellFrame];
    }];
    
    [detailView viewWillDisappear:NO];
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
    [self.navigationItem setRightBarButtonItem:nil];
    
    if(isFromMakes)
    {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:@selector(returnToMakes)];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    }
    else if(isFromModels)
    {
        isFromModels = YES;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:@selector(returnToModel)];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        CGRect cellFrameInTable = [self.tableView convertRect:detailCell.frame fromView:self.view];
        [detailCell setFrame:cellFrameInTable];
        [self.tableView addSubview:detailCell];
        
        [detailView didMoveToParentViewController:nil];
        [detailView.view removeFromSuperview];
        [detailView removeFromParentViewController];
    });
}

-(void)setTitleLabelWithString:(NSString *)title
{
    [self setTitle:title];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:self.title];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

-(void)revertModelCell
{
    [UIView animateWithDuration:.5 animations:^{
        [cellToSlide setFrame:initialCellFrame];
        [self.tableView setAlpha:1.0];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        CGRect cellFrameInTable = [self.tableView convertRect:cellToSlide.frame fromView:self.view];
        [cellToSlide setFrame:cellFrameInTable];
        [self.tableView addSubview:cellToSlide];
        shouldRefreshImage = NO;
        [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:cellToSlide]] withRowAnimation:UITableViewRowAnimationNone];
        shouldRefreshImage = YES;
    });
}

-(void)returnToMakes
{
    [self performSegueWithIdentifier:@"unwindToMakesVC" sender:self];
}

-(void)returnToModel
{
    [self performSegueWithIdentifier:@"unwindToModelVC" sender:self];
}

-(void)pushSpecsDispute
{
    [self performSegueWithIdentifier:@"pushSpecsDispute" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"pushSubclasses"])
    {
        [[segue destinationViewController] getClass: currentClass sender:self];
    }
    if([[segue identifier] isEqualToString:@"pushStyles"])
    {
        [[segue destinationViewController] getSubclass: currentSubclass sender:self];
    }
    if([[segue identifier] isEqualToString:@"pushModels"])
    {
        [[segue destinationViewController] getStyle: currentStyle sender:self];
    }
}

- (IBAction)unwindToModelVC:(UIStoryboardSegue *)segue
{
    [self revertModelCell];
}

@end
