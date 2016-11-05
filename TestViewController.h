//
//  TestViewController.h
//  Carhub
//
//  Created by Christoper Clark on 1/11/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Race.h"
#import "Model.h"
#import "News.h"
#import "CustomPageControl.h"
#import "HomePageMedia.h"
#import "SearchViewController.h"
#import "YTPlayerView.h"

@interface TestViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, YTPlayerViewDelegate>

@property (nonatomic, strong) YTPlayerView *playerView;

@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@property (nonatomic, strong) NSMutableArray * newsArray;
@property (nonatomic, strong) NSMutableArray * mediaArray;
@property (nonatomic, strong) NSMutableArray * carOfTheDayArray;
@property (nonatomic, strong) NSMutableArray * latestArticlesArray;
@property (nonatomic, strong) NSMutableArray * latestVideosArray;
@property (nonatomic, strong) NSMutableArray * racesArray;
@property (nonatomic, strong) NSMutableArray * addedCarsArray;
@property (nonatomic, strong) HomePageMedia * COTDMediaObject;

@property (nonatomic, strong) Model * currentCarOfTheDay;
@property (nonatomic, strong) Model * currentNewCar;
@property (nonatomic, strong) News * selectedNews;
@property (nonatomic, strong) Race * currentRaceID;

@property (nonatomic, strong) NSString * COTDSpec1;
@property (nonatomic, strong) NSString * COTDSpec2;
@property (weak, nonatomic) IBOutlet UIImageView *SpecImage1;
@property (weak, nonatomic) IBOutlet UIImageView *SpecImage2;

@property (strong, nonatomic) UIImageView *refreshImage;
@property (strong, nonatomic) UILabel *noDataLabel;

@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl1;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl2;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl3;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl4;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl5;
@property (weak, nonatomic) IBOutlet UILabel *CarOfTheDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestArticlesLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestVideosLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentRacesLabel;
@property (weak, nonatomic) IBOutlet UILabel *newlyAddedCarsLabel;
@property (weak, nonatomic) IBOutlet UILabel *Spec1Label;
@property (weak, nonatomic) IBOutlet UILabel *Spec2Label;
@property (weak, nonatomic) IBOutlet UILabel *fullSpecsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fullSpecsArrow;

@property (weak, nonatomic) IBOutlet UIView *CardView1;
@property (nonatomic, strong) CAGradientLayer *gradient;
@property (weak, nonatomic) IBOutlet UIView *CardView2;
@property (weak, nonatomic) IBOutlet UIView *CardView3;
@property (weak, nonatomic) IBOutlet UIView *CardView4;
@property (weak, nonatomic) IBOutlet UIView *CardView5;
@property (weak, nonatomic) IBOutlet UICollectionView *CarOfTheDayCV;
@property (weak, nonatomic) IBOutlet UICollectionView *LatestArticlesCV;
@property (weak, nonatomic) IBOutlet UICollectionView *LatestVideosCV;
@property (weak, nonatomic) IBOutlet UICollectionView *RacesCV;
@property (weak, nonatomic) IBOutlet UICollectionView *AddedCarsCV;

//Refresh Control Stuff
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIView *refreshLoadingView;
@property (nonatomic, strong) UIImageView *compass_background;
@property (nonatomic, strong) UIImageView *compass_spinner;
@property (assign) BOOL isRefreshIconsOverlap;
@property (assign) BOOL isRefreshAnimating;
@property (assign) BOOL shouldKeepSpinning;
@property (assign) BOOL shouldDoInitialLoad;

@property (assign) BOOL shouldPushToModel;
@property (assign) BOOL shouldPushToArticle;
@property (assign) BOOL shouldPushToVideo;
@property (assign) BOOL shouldPushToRace;
@property (nonatomic, strong) NSNotification *savedNotification;

@end
