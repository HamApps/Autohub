//
//  RaceTypeViewController.h
//  Carhub
//
//  Created by Christopher Clark on 9/21/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RaceType.h"
#import "CustomPageControl.h"
#import "Race.h"

@interface RaceTypeViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray * raceTypeArray;
@property (nonatomic, strong) NSMutableArray * recentRacesArray;
@property (nonatomic, strong) NSMutableArray * raceListArray;
@property (strong, nonatomic) RaceType *raceTypeID;
@property (strong, nonatomic) Race *recentRace;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (weak, nonatomic) IBOutlet UIView *CardView1;
@property (weak, nonatomic) IBOutlet UIView *CardView2;
@property (weak, nonatomic) IBOutlet UIView *CardView3;
@property (weak, nonatomic) IBOutlet UICollectionView *RecentRacesCV;
@property (weak, nonatomic) IBOutlet UICollectionView *RaceClassCV;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl1;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl2;
@property (nonatomic, strong) IBOutlet UIImageView *raceResultsCircleImage;

//Refresh Control Stuff
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIView *refreshLoadingView;
@property (nonatomic, strong) UIView *refreshColorView;
@property (nonatomic, strong) UIImageView *compass_background;
@property (nonatomic, strong) UIImageView *compass_spinner;
@property (assign) BOOL isRefreshIconsOverlap;
@property (assign) BOOL isRefreshAnimating;
@property (assign) BOOL shouldKeepSpinning;

@end