//
//  PageItemController.h
//  Carhub
//
//  Created by Christoper Clark on 11/6/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Race.h"
#import "CustomPageControl.h"

@interface PageItemController : UIViewController<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

// Item controller information
@property (nonatomic) NSUInteger itemIndex;
@property (nonatomic, strong) NSString *imageURLString;

@property (nonatomic, strong) Race *currentRace;
@property (nonatomic, strong) NSMutableArray * currentRaceResultsArray;
@property (nonatomic, strong) NSMutableArray * currentRaceImagesArray;

// IBOutlets
@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *raceImagesCV;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl1;
@property (weak, nonatomic) IBOutlet UILabel *raceNameLabel;

@property CGRect initialCVFrame;
@property CGRect initialPageControlFrame;

//Refresh Control Stuff
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIView *refreshLoadingView;
@property (nonatomic, strong) UIView *refreshColorView;
@property (nonatomic, strong) UIImageView *compass_background;
@property (nonatomic, strong) UIImageView *compass_spinner;
@property (assign) BOOL isRefreshIconsOverlap;
@property (assign) BOOL isRefreshAnimating;
@property (assign) BOOL shouldKeepSpinning;

-(void)getRaceResults:(id)currentRaceID;

@end
