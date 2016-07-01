//
//  HomeViewController.h
//  Carhub
//
//  Created by Christopher Clark on 10/17/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Race.h"
#import "Model.h"
#import "News.h"
#import "CustomPageControl.h"

@interface HomeViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) NSMutableArray * newsArray;
@property (nonatomic, strong) NSMutableArray * mediaArray;
@property (nonatomic, strong) NSMutableArray * carOfTheDayArray;
@property (nonatomic, strong) NSMutableArray * latestArticlesArray;
@property (nonatomic, strong) NSMutableArray * latestVideosArray;
@property (nonatomic, strong) NSMutableArray * racesArray;
@property (nonatomic, strong) NSMutableArray * addedCarsArray;

@property (nonatomic, strong) Model * currentCarOfTheDay;
@property (nonatomic, strong) NSString * COTDSpec1;
@property (nonatomic, strong) NSString * COTDSpec2;
@property (nonatomic, strong) Race * currentRaceID;
@property (nonatomic, strong) News * selectedNews;

@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl1;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl2;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl3;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl4;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl5;
@property (weak, nonatomic) IBOutlet UILabel *CarOfTheDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *Spec1Label;
@property (weak, nonatomic) IBOutlet UILabel *Spec2Label;

@property (weak, nonatomic) IBOutlet UIView *CardView;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (weak, nonatomic) IBOutlet UICollectionView *CarOfTheDayCV;
@property (weak, nonatomic) IBOutlet UICollectionView *LatestArticlesCV;
@property (weak, nonatomic) IBOutlet UICollectionView *LatestVideosCV;
@property (weak, nonatomic) IBOutlet UICollectionView *RacesCV;
@property (weak, nonatomic) IBOutlet UICollectionView *AddedCarsCV;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

//Refresh Control Stuff
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIView *refreshLoadingView;
@property (nonatomic, strong) UIView *refreshColorView;
@property (nonatomic, strong) UIImageView *compass_background;
@property (nonatomic, strong) UIImageView *compass_spinner;
@property (assign) BOOL isRefreshIconsOverlap;
@property (assign) BOOL isRefreshAnimating;

@end
