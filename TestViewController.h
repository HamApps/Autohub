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

@interface TestViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@property (nonatomic, strong) NSMutableArray * newsArray;
@property (nonatomic, strong) NSMutableArray * mediaArray;
@property (nonatomic, strong) NSMutableArray * carOfTheDayArray;
@property (nonatomic, strong) NSMutableArray * latestArticlesArray;
@property (nonatomic, strong) NSMutableArray * latestVideosArray;
@property (nonatomic, strong) NSMutableArray * racesArray;
@property (nonatomic, strong) NSMutableArray * addedCarsArray;

@property (nonatomic, strong) Model * currentCarOfTheDay;
@property (nonatomic, strong) Model * currentNewCar;
@property (nonatomic, strong) News * selectedNews;
@property (nonatomic, strong) Race * currentRaceID;

@property (nonatomic, strong) NSString * COTDSpec1;
@property (nonatomic, strong) NSString * COTDSpec2;
@property (weak, nonatomic) IBOutlet UIImageView *SpecImage1;
@property (weak, nonatomic) IBOutlet UIImageView *SpecImage2;

@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl1;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl2;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl3;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl4;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl5;
@property (weak, nonatomic) IBOutlet UILabel *CarOfTheDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *Spec1Label;
@property (weak, nonatomic) IBOutlet UILabel *Spec2Label;
@property (weak, nonatomic) IBOutlet UILabel *circleLabel;

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
@property (nonatomic, strong) UIView *refreshColorView;
@property (nonatomic, strong) UIImageView *compass_background;
@property (nonatomic, strong) UIImageView *compass_spinner;
@property (assign) BOOL isRefreshIconsOverlap;
@property (assign) BOOL isRefreshAnimating;
@property (assign) BOOL shouldKeepSpinning;

@end
