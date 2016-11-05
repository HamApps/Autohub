//
//  RaceTypeCell.m
//  Carhub
//
//  Created by Christoper Clark on 8/23/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "RaceTypeCell.h"
#import "AppDelegate.h"
#import "HomepageCell.h"
#import "Race.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "SWRevealViewController.h"

@implementation RaceTypeCell
@synthesize lineView, cardView, seasonLabel, raceArray, currentRaceSeason, controller, carousel, currentRace, scrollerView, circleScroller, shouldAnimateScroller, initialCircleScrollerX;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)layoutSubviews
{
    [self cardSetup];
    [self lineViewSetUp];
    [self setUpRaceArray];
    
    self.carousel.type = iCarouselTypeRotary;
    [self.carousel reloadData];
    [self.carousel setCurrentItemIndex:0];
    initialCircleScrollerX = 18;
}

-(void)cardSetup
{
    [self.cardView setAlpha:1];
    self.cardView.layer.masksToBounds = NO;
    self.cardView.layer.cornerRadius = 10;
    self.cardView.layer.shadowOffset = CGSizeMake(-.2f, .2f);
    self.cardView.layer.shadowRadius = 1.5;
    self.cardView.layer.shadowOpacity = .5;
    self.backgroundColor = [UIColor whiteColor];
}

-(void)lineViewSetUp
{
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cardView.bounds.origin.y+35, self.cardView.bounds.size.width, 1.5)];
    lineView.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
    lineView.clipsToBounds = YES;
    [self.cardView addSubview:lineView];
    
    //Add slider line
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(18, scrollerView.center.y+.5, self.cardView.bounds.size.width-36, 1.5)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [self.cardView addSubview:lineView2];
    [self.cardView bringSubviewToFront:scrollerView];
    
    [scrollerView setUserInteractionEnabled:YES];
    
    UIPanGestureRecognizer * pan1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveObject:)];
    pan1.minimumNumberOfTouches = 1;
    [scrollerView addGestureRecognizer:pan1];
    
    shouldAnimateScroller = YES;
}

-(void)moveObject:(UIPanGestureRecognizer *)pan;
{
    if(pan.state == UIGestureRecognizerStateEnded)
        shouldAnimateScroller = YES;
    if(pan.state == UIGestureRecognizerStateBegan)
        shouldAnimateScroller = NO;
    
    CGPoint panLocation = [pan locationInView:scrollerView.superview];
    
    NSLog(@"out here");
    
    if(panLocation.x >= initialCircleScrollerX -1 && panLocation.x <= self.cardView.frame.size.width - initialCircleScrollerX + 5)
    {
        NSLog(@"in here");
        scrollerView.center = CGPointMake(panLocation.x, scrollerView.center.y);
        int index = (panLocation.x - 18)*(raceArray.count-1)/(cardView.frame.size.width-36);
        [self.carousel scrollToItemAtIndex:index animated:NO];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return raceArray.count;
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if([self numberOfItemsInCarousel:self.carousel] == 1)
        self.carousel.scrollEnabled = NO;
    else
        self.carousel.scrollEnabled = YES;
    
    self.carousel.bounces = NO;
    
    UILabel *label = nil;
    currentRace = [raceArray objectAtIndex:index];
    
    //create new view if no view is available for recycling
    view = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, self.carousel.frame.size.width-60, self.carousel.frame.size.height)];
    view.contentMode = UIViewContentModeCenter;
    view.backgroundColor = [UIColor whiteColor];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 145, view.frame.size.width, 40)];
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"MavenProRegular" size:17];
    label.adjustsFontSizeToFitWidth = YES;
    label.tag = 1;
    [view addSubview:label];
    
    UIImageView *makeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 142)];
    __weak UIImageView *makeImageView2 = makeImageView;
    
    UIScrollView *makeImageScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 142)];
    makeImageScroller.delegate = self;
    [makeImageScroller addSubview:makeImageView];
    makeImageView.tag = 1;
    
    [makeImageScroller setScrollEnabled:NO];
    makeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:makeImageScroller];
    
    NSURL *imageURL;
    if([currentRace.RaceImageURL containsString:@"raceno"])
        imageURL = [NSURL URLWithString:currentRace.RaceImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/raceimage.php"]];
    else
        imageURL = [NSURL URLWithString:currentRace.RaceImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
    
    [makeImageView setImageWithURL:imageURL
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                             [makeImageView2 setAlpha:0.0];
                             [UIImageView animateWithDuration:0.5 animations:^{
                                 [makeImageView2 setAlpha:1.0];
                             }];
                         }
       usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    label.text = currentRace.SeasonRaceName;
    
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

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 0;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
    }
    else
    {
        //get a reference to the label in the recycled view
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    
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
            return value * 1.15f;
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
    if (self.carousel.currentItemIndex >= 0)
        currentRace = [raceArray objectAtIndex:self.carousel.currentItemIndex];
    
    if(raceArray.count <= 1)
        return;
    
    if(shouldAnimateScroller)
    {
        double xCoordinate = 18 + (cardView.frame.size.width-36)*(self.carousel.currentItemIndex)/(raceArray.count-1);
        
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [scrollerView setCenter:CGPointMake(xCoordinate, scrollerView.center.y)];
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    UIView *selectedView = [self.carousel itemViewAtIndex:index];
    
    for (UIView *subview in selectedView.subviews)
    {
        [subview setAlpha:.3];
    }
    
    Race *raceToShow = [raceArray objectAtIndex:index];
    [controller pushRaceWithRaceObject:raceToShow];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        for (UIView *subview in selectedView.subviews)
        {
            [subview setAlpha:1];
        }
    });
}

-(void)setUpRaceArray
{
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSPredicate *classPredicate = [NSPredicate predicateWithFormat:@"SELF.RaceType contains %@", currentRaceSeason.SeasonClass];
    NSPredicate *seasonPredicate = [NSPredicate predicateWithFormat:@"SELF.RaceSeason contains %@", currentRaceSeason.SeasonName];
    
    raceArray = [[appdel.raceListArray filteredArrayUsingPredicate:classPredicate]mutableCopy];
    raceArray = [[raceArray filteredArrayUsingPredicate:seasonPredicate]mutableCopy];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"RaceDate" ascending:NO];
    [raceArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

@end
