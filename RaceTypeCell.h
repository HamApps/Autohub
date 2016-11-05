//
//  RaceTypeCell.h
//  Carhub
//
//  Created by Christoper Clark on 8/23/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPageControl.h"
#import "RaceType.h"
#import "RaceSeason.h"
#import "RaceViewController.h"
#import "iCarousel.h"
#import "Race.h"

@interface RaceTypeCell : UITableViewCell<iCarouselDelegate, iCarouselDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet iCarousel *carousel;

@property (strong, nonatomic) IBOutlet UIView *cardView;
@property (strong, nonatomic) IBOutlet UILabel *seasonLabel;

@property (nonatomic, assign) RaceViewController *controller;

@property (strong, nonatomic) UIView *lineView;
@property (nonatomic, strong) IBOutlet UIView * scrollerView;
@property (nonatomic, strong) IBOutlet UIImageView *circleScroller;

@property (nonatomic, strong) NSMutableArray * raceArray;
@property (nonatomic, strong) RaceSeason *currentRaceSeason;
@property (nonatomic, strong) Race *currentRace;

@property CGFloat initialCircleScrollerX;
@property BOOL shouldAnimateScroller;

@end
