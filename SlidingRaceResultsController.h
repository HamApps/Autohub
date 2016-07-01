//
//  SlidingRaceResultsController.h
//  Carhub
//
//  Created by Christoper Clark on 11/6/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Race.h"

@interface SlidingRaceResultsController : UIViewController

@property (nonatomic, strong) NSArray *contentImageArray;
@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, strong) NSMutableArray * currentRaceResultsArray;
@property (nonatomic, strong) Race *currentRace;

-(void)getRaceResults:(id)currentRaceID;

@end
