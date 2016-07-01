//
//  SlidingRaceResultsController.m
//  Carhub
//
//  Created by Christoper Clark on 11/6/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import "SlidingRaceResultsController.h"
#import "PageItemController.h"
#import "AppDelegate.h"
#import "RaceResult.h"
#import "RaceResultCell.h"

@interface SlidingRaceResultsController () <UIPageViewControllerDataSource>

@end

@implementation SlidingRaceResultsController
@synthesize currentRaceResultsArray, currentRace, contentImageArray;

#pragma mark -
#pragma mark View Lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    NSString *race = @"Russian Grand Prix";
    [self getRaceResults:race];
    [self createPageViewController];
    [self setupPageControl];
}

- (void) createPageViewController
{
    contentImageArray = @[@"http://pl0x.net/image.php/?carno=1224",
                      @"http://pl0x.net/image.php/?carno=800",
                      @"http://pl0x.net/image.php/?carno=850",
                      @"http://pl0x.net/image.php/?carno=950"];
    
    UIPageViewController *pageController = [self.storyboard instantiateViewControllerWithIdentifier: @"PageController"];
    pageController.dataSource = self;
    
    if([contentImageArray count])
    {
        NSArray *startingViewControllers = @[[self itemControllerForIndex: 0]];
        [pageController setViewControllers: startingViewControllers
                                 direction: UIPageViewControllerNavigationDirectionForward
                                  animated: NO
                                completion: nil];
    }
    
    self.pageViewController = pageController;
    [self addChildViewController: self.pageViewController];
    [self.view addSubview: self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController: self];
}

- (void) setupPageControl
{
    [[UIPageControl appearance] setPageIndicatorTintColor: [UIColor grayColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor: [UIColor whiteColor]];
    [[UIPageControl appearance] setBackgroundColor: [UIColor darkGrayColor]];
}

#pragma mark -
#pragma mark UIPageViewControllerDataSource

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerBeforeViewController:(UIViewController *) viewController
{
    PageItemController *itemController = (PageItemController *) viewController;
    
    if (itemController.itemIndex > 0)
    {
        return [self itemControllerForIndex: itemController.itemIndex-1];
    }
    
    return nil;
}

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerAfterViewController:(UIViewController *) viewController
{
    PageItemController *itemController = (PageItemController *) viewController;
    
    if (itemController.itemIndex+1 < [contentImageArray count])
    {
        return [self itemControllerForIndex: itemController.itemIndex+1];
    }
    
    return nil;
}

- (PageItemController *) itemControllerForIndex: (NSUInteger) itemIndex
{
    if (itemIndex < [contentImageArray count])
    {
        PageItemController *pageItemController = [self.storyboard instantiateViewControllerWithIdentifier: @"ItemController"];
        pageItemController.itemIndex = itemIndex;
        pageItemController.imageName = contentImageArray[itemIndex];
        pageItemController.currentRaceResultsArray = currentRaceResultsArray;

        return pageItemController;
    }
    return nil;
}

#pragma mark -
#pragma mark Page Indicator

- (NSInteger) presentationCountForPageViewController: (UIPageViewController *) pageViewController
{
    return [contentImageArray count];
}

- (NSInteger) presentationIndexForPageViewController: (UIPageViewController *) pageViewController
{
    return 0;
}

-(void)getRaceResults:(id)currentRaceID
{
    currentRaceResultsArray = [[NSMutableArray alloc]init];
    
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"appdel.raceresultsarray.count %lu", (unsigned long)appdel.raceResultsArray.count);

    for(int i=0; i<appdel.raceResultsArray.count; i++)
    {
        RaceResult *raceResult = [appdel.raceResultsArray objectAtIndex:i];
        NSString *race = @"Russian Grand Prix";

        if([raceResult.RaceID isEqualToString:race])
            [currentRaceResultsArray addObject:[appdel.raceResultsArray objectAtIndex:i]];
    }
    NSLog(@"currentRaceResultsArray: %@", currentRaceResultsArray);
}

@end
