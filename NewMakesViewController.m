//
//  NewMakesViewController.m
//  Carhub
//
//  Created by Christoper Clark on 1/23/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "NewMakesViewController.h"
#import "AppDelegate.h"
#import "Make.h"
#import "Model.h"
#import "UIImageView+WebCache.h"
#import "CarViewCell.h"
#import "ModelViewController.h"
#import "SWRevealViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "DetailViewController.h"
#import <Google/Analytics.h>

@interface NewMakesViewController ()

@end

@implementation NewMakesViewController
@synthesize makeimageArray, circleScroller, appdelmodelArray, ModelArray, currentMake, currentClass, currentSubclass, searchArray, pushingObject, lineView, upperView, detailView, detailCell, detailImageView, initialCellFrame, cellToSlide, initialCellFrame2, detailImageScroller, initialScrollerFrame, initialCircleScrollerX, letterLabel, shouldAnimateScroller, scrollerView, shouldHaveBackButton, activityIndicator, yCenter, yCenterModel, shouldRefreshImage, initialUpperViewFrame;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:@"Makes Layout Preference"]isEqualToString:@"Grid"])
    {
        [self performSegueWithIdentifier:@"pushTradMakesInstant" sender:self];
    }
    
    if(shouldHaveBackButton == NO)
        [self setUpSlideToolBar];
    
    [self makeAppDelMakeArray];
    [self makeAppDelModelArray];
    
    [self setTitle:@"Makes"];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"New Makes"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [circleScroller setImage:[self resizeImage:[UIImage imageNamed:@"RedBlackScrollDotLarger.png"] reSize:circleScroller.frame.size]];
    
    self.carousel.type = iCarouselTypeRotary;
    [self.carousel reloadData];
    [self.carousel setCurrentItemIndex:0];
    
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    //Add slider line
    lineView = [[UIView alloc] initWithFrame:CGRectMake(18, scrollerView.center.y+.5, self.view.bounds.size.width-36, 1.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.upperView addSubview:lineView];
    [upperView bringSubviewToFront:scrollerView];
    initialUpperViewFrame = upperView.frame;
    
    [scrollerView setUserInteractionEnabled:YES];
    
    UIPanGestureRecognizer * pan1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveObject:)];
    pan1.minimumNumberOfTouches = 1;
    [scrollerView addGestureRecognizer:pan1];
    
    shouldAnimateScroller = YES;
    shouldRefreshImage = YES;
    
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

-(void)viewDidAppear:(BOOL)animated
{
    if(initialCircleScrollerX == 0)
        initialCircleScrollerX = scrollerView.center.x;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

-(void)moveObject:(UIPanGestureRecognizer *)pan;
{
    if(pan.state == UIGestureRecognizerStateEnded)
        shouldAnimateScroller = YES;
    if(pan.state == UIGestureRecognizerStateBegan)
        shouldAnimateScroller = NO;
    
    CGPoint panLocation = [pan locationInView:scrollerView.superview];

    if(panLocation.x >= initialCircleScrollerX && panLocation.x <= self.view.frame.size.width - initialCircleScrollerX + 5)
    {
        scrollerView.center = CGPointMake(panLocation.x, scrollerView.center.y);
        int index = (panLocation.x - 18)*(makeimageArray.count-1)/(self.view.frame.size.width - 36);
        [_carousel scrollToItemAtIndex:index animated:NO];
    }
}

-(void)setUpSlideToolBar
{
    self.navigationItem.leftBarButtonItems = nil;
    self.barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"lines7.png"] style:UIBarButtonItemStyleDone target:self.revealViewController action:@selector(revealToggle:)];
    self.barButton.tintColor = [UIColor blackColor];
    [self.navigationItem setLeftBarButtonItem:self.barButton];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return self.makeimageArray.count;
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    currentMake = [self.makeimageArray objectAtIndex:index];
    
    //create new view if no view is available for recycling
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        view.contentMode = UIViewContentModeCenter;

        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 200.0f, 100.0f)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"MavenProRegular" size:25];
        label.tag = 1;
        [view addSubview:label];
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    
    UIImageView *makeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 90)];
    __weak UIImageView *makeImageView2 = makeImageView;
    
    UIScrollView *makeImageScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, 200, 90)];
    makeImageScroller.delegate = self;
    [makeImageScroller addSubview:makeImageView];
    makeImageView.tag = 1;
    
    UIActivityIndicatorView *activityIndicator1 = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator1.center = makeImageScroller.center;
    activityIndicator1.hidesWhenStopped = YES;
    activityIndicator1.color = [UIColor blackColor];
    [view addSubview:activityIndicator1];
    [activityIndicator1 startAnimating];
    
    [makeImageScroller setScrollEnabled:NO];
    
    UIImageView *flagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(87.5, 25, 30, 30)];
    [flagImageView setCenter:CGPointMake(view.center.x, flagImageView.center.y)];
    makeImageView.contentMode = UIViewContentModeScaleAspectFit;
    flagImageView.contentMode = UIViewContentModeScaleAspectFit;

    [view addSubview:makeImageScroller];
    [view addSubview:flagImageView];
    
    NSURL *imageURL;
    if([currentMake.MakeImageURL containsString:@"carno"])
        imageURL = [NSURL URLWithString:currentMake.MakeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image2.php"]];
    else
        imageURL = [NSURL URLWithString:currentMake.MakeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];

    [makeImageView sd_setImageWithURL:imageURL
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                      [activityIndicator1 stopAnimating];
                                      [makeImageView2 setAlpha:0.0];
                                      [UIImageView animateWithDuration:0.5 animations:^{
                                          [makeImageView2 setAlpha:1.0];
                                      }];
                                  }];

    if ([currentMake.MakeCountry isEqualToString:@"America"])
        [flagImageView setImage:[UIImage imageNamed:@"united-states.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Czech"])
        [flagImageView setImage:[UIImage imageNamed:@"czech-republic.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Britain"])
        [flagImageView setImage:[UIImage imageNamed:@"united-kingdom.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Japan"])
        [flagImageView setImage:[UIImage imageNamed:@"japan.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Australia"])
        [flagImageView setImage:[UIImage imageNamed:@"australia.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Denmark"])
        [flagImageView setImage:[UIImage imageNamed:@"denmark.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"France"])
        [flagImageView setImage:[UIImage imageNamed:@"france.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Germany"])
        [flagImageView setImage:[UIImage imageNamed:@"germany.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Italy"])
        [flagImageView setImage:[UIImage imageNamed:@"italy.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Korea"])
        [flagImageView setImage:[UIImage imageNamed:@"south-korea.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Netherlands"])
        [flagImageView setImage:[UIImage imageNamed:@"netherlands.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Spain"])
        [flagImageView setImage:[UIImage imageNamed:@"spain.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Sweden"])
        [flagImageView setImage:[UIImage imageNamed:@"sweden.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"UAE"])
        [flagImageView setImage:[UIImage imageNamed:@"united-arab-emirates.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Russia"])
        [flagImageView setImage:[UIImage imageNamed:@"russia.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Austria"])
        [flagImageView setImage:[UIImage imageNamed:@"austria.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Romania"])
        [flagImageView setImage:[UIImage imageNamed:@"romania.png"]];
    
    label.text = currentMake.MakeName;
    
    return view;
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.tableView)
    {
        CGPoint currentPosition = scrollView.contentOffset;
        [upperView setFrame:CGRectMake(0, initialUpperViewFrame.origin.y - currentPosition.y - self.tableView.contentInset.top, initialUpperViewFrame.size.width, initialUpperViewFrame.size.height)];
    }
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 0;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 200.0f, 150.0f)];
        //2((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
        view.contentMode = UIViewContentModeCenter;
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:25.0f];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = (index == 0)? @"[": @"]";
    
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.carousel.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    /*switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * .95f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.2;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }*/
    
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.1f;
        }
        case iCarouselOptionShowBackfaces:
            return 0;
        case iCarouselOptionFadeMin:
            return -0.1;
        case iCarouselOptionFadeMax:
            return 0.1;
        case iCarouselOptionFadeRange:
            return 1.5;
        default:
            return value;
    }

}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel;
{
    if(shouldAnimateScroller)
    {
        double xCoordinate = 18 + (self.view.frame.size.width-36)*(carousel.currentItemIndex)/(makeimageArray.count-1);
        
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [scrollerView setCenter:CGPointMake(xCoordinate, scrollerView.center.y)];
                         }
                         completion:^(BOOL finished){
                            
                         }];
    }
    
    if (carousel.currentItemIndex >= 0)
        currentMake = [makeimageArray objectAtIndex:carousel.currentItemIndex];
    
    if(![letterLabel.text isEqualToString:[currentMake.MakeName substringToIndex:1]])
        [self updateLetterLabel];
    
    [self switchCurrentMake];
}

-(void)updateLetterLabel
{
    if(shouldAnimateScroller)
    {
        CATransition *animation = [CATransition animation];
        animation.duration = 0.15;
        animation.type = kCATransitionPush;
        
        unichar newChar = [currentMake.MakeName characterAtIndex:0];
        unichar currentChar = [letterLabel.text characterAtIndex:0];
        
        if (newChar >= currentChar)
            animation.subtype = kCATransitionFromRight;
        else
            animation.subtype = kCATransitionFromLeft;
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [letterLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
    }
    
    char firstChar = [currentMake.MakeName characterAtIndex:0];
    
    if(firstChar>='0' && firstChar<='9')
        [letterLabel setText:@"#"];
    else
        [letterLabel setText:[currentMake.MakeName substringToIndex:1]];
}

#pragma mark -
#pragma mark TableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ModelCell";
    CarViewCell *cell = (CarViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[CarViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Model * modelObject = [self.ModelArray objectAtIndex:indexPath.row];
    
    [cell.normalImageView sd_cancelCurrentImageLoad];
    [cell.activityIndicator stopAnimating];
    [cell.hiddenWebView stopLoading];
    
    if(!shouldRefreshImage)
        [cell setUpCarImageWithModel:modelObject andAlpha:1];
    else
        [cell setUpCarImageWithModel:modelObject andAlpha:0];
    
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedImage:)];
    [cell addGestureRecognizer:tapImage];
    
    cell.CarName.text = modelObject.CarModel;
    
    return cell;
}

- (void)switchCurrentMake;
{
    ModelArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<appdelmodelArray.count; i++)
    {
        Model *currentModel = [appdelmodelArray objectAtIndex:i];
        if (([currentModel.CarMake isEqualToString:currentMake.MakeName] && [currentModel.isClass isEqualToNumber:[NSNumber numberWithInt:1]]))
            [ModelArray addObject:currentModel];
    }
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:NULL waitUntilDone:YES];
}

#pragma mark -
#pragma mark Loading methods

- (void) makeAppDelMakeArray;
{
    makeimageArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [makeimageArray addObjectsFromArray:appdel.makeimageArray2];
}
- (void) makeAppDelModelArray;
{
    appdelmodelArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelmodelArray addObjectsFromArray:appdel.modelArray];
}

#pragma mark -
#pragma mark Navigation methods

-(void)tappedImage:(UITapGestureRecognizer *)sender
{
    UIView *view = sender.view;
    CGPoint hitPoint = [view convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    [self.tableView selectRowAtIndexPath:hitIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:hitIndex];
    NSLog(@"tapped image index: %@", hitIndex);
}

- (UIImage*)resizeImage:(UIImage*)aImage reSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [aImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //returns if view is in detailview state
    if(self.tableView.alpha == 0)
        return;
    
    pushingObject = [ModelArray objectAtIndex:indexPath.row];
    
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
            [self.tableView setAlpha:0.0];
            [cellToSlide.imageScroller2 setAlpha:0];
            [cellToSlide.CarName setAlpha:0];
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
        [self performSegueWithIdentifier:@"pushModels" sender:self];
    }
}

-(void)revertFromSubClasses
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

-(void)pushDetailWithIndexPath:(NSIndexPath *)indexPath
{
    CarViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    detailCell = selectedCell;
    pushingObject = [ModelArray objectAtIndex:indexPath.row];
    
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
    
    [iCarousel animateWithDuration:.5 animations:^{
        _carousel.alpha = 0.0;
        lineView.alpha = 0.0;
        circleScroller.alpha = 0.0;
        upperView.alpha = 0.0;
        [self.tableView setAlpha:0.0];
        [selectedCell setAlpha:0.0];
        
        [selectedCell setCenter:CGPointMake(self.view.frame.size.width/2, yCenter)];
        [detailImageScroller setCenter:CGPointMake(self.view.frame.size.width/2, yCenter)];
    }];
    
    [self setTitle:pushingObject.CarMake];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
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
            [backButton setAction:@selector(revertToMakesPage)];
            
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
    [self revertToMakesPage];
}

-(void)revertToMakesPage
{
    [UIView animateWithDuration:0.5 animations:^{
        [detailCell setFrame:initialCellFrame];
    }];
    
    [detailView viewWillDisappear:NO];
    upperView.alpha = 1.0;
    CGRect frameInView = [self.view convertRect:detailImageScroller.frame fromView:detailView.view];
    [self.view addSubview:detailImageScroller];
    [detailImageScroller setFrame:frameInView];
    [detailImageScroller setFrame:initialScrollerFrame];
    [detailCell.cardView addSubview:detailImageScroller];
    [self removeDownSwipe];
    [detailCell lineViewSetUp];
    [detailCell setAlpha:1.0];
    
    [self setTitle:@"Makes"];
    
    if(shouldHaveBackButton)
        [self setUpUnwindToCompare];
    else
        [self setUpSlideToolBar];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Makes Switch.png"] style:UIBarButtonItemStyleDone target:self action:@selector(pushTraditionalMakes)];
    item.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = item;
    
    [detailView.view setAlpha:0.0];
    _carousel.alpha = 1.0;
    lineView.alpha = 1.0;
    circleScroller.alpha = 1.0;
    [self.tableView setAlpha:1.0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        CGRect cellFrameInTable = [self.tableView convertRect:detailCell.frame fromView:self.view];
        [detailCell setFrame:cellFrameInTable];
        [_tableView addSubview:detailCell];
        
        [detailView didMoveToParentViewController:nil];
        [detailView.view removeFromSuperview];
        [detailView removeFromParentViewController];
    });
}

-(void)pushSpecsDispute
{
    [self performSegueWithIdentifier:@"pushSpecsDispute" sender:self];
}

-(void)pushTraditionalMakes
{
    [self performSegueWithIdentifier:@"pushTradMakes" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushTradMakesInstant"])
    {
        [segue destinationViewController];
    }
    if ([[segue identifier] isEqualToString:@"pushTradMakes"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"Grid" forKey:@"Makes Layout Preference"];
        [segue destinationViewController];
    }
    if([[segue identifier] isEqualToString:@"pushSubclasses"])
    {
        [[segue destinationViewController] getClass: currentClass sender:self];
    }
    
    if([[segue identifier] isEqualToString:@"pushModels"])
    {
        [[segue destinationViewController] getSubclass: currentSubclass sender:self];
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

- (IBAction)unwindToMakesVC:(UIStoryboardSegue *)segue
{
    [self revertFromSubClasses];
}

@end
