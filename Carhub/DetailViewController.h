//
//  DetailViewController.h
//  Carhub
//
//  Created by Christopher Clark on 7/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import <AVFoundation/AVFoundation.h>
#import "Currency.h"
#import "FXBlurView.h"
#import "SpecsToolbarHeader.h"

@interface DetailViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UIWebViewDelegate, AVAudioPlayerDelegate>

@property(strong, nonatomic) IBOutlet UIView *borderView;
@property CGRect initialBorderFrame;
@property (strong, nonatomic) IBOutlet UIImageView *makeImageView;
@property (strong, nonatomic) IBOutlet UIImageView *makeImageView1;
@property (strong, nonatomic) IBOutlet UIImageView *makeImageView2;
@property(strong, nonatomic) IBOutlet FXBlurView *blurView;
@property(strong, nonatomic) IBOutlet UIView *makeImageContainer;

@property (strong, nonatomic) SpecsToolbarHeader *specsHeaderView;
@property (weak, nonatomic) IBOutlet UICollectionView * specsCollectionView;
@property (nonatomic, strong) NSMutableArray * savedArray;
@property (nonatomic, strong) UIScrollView *detailImageScroller;

@property (nonatomic, strong) UIButton *exhaustButton1;
@property (nonatomic, strong) UIButton *exhaustButton2;

@property(nonatomic, strong) Model * currentCar;
@property(nonatomic, strong) Model * firstCar;
@property(nonatomic, strong) Model * secondCar;
@property(nonatomic, strong) NSString * currencySymbol;
@property(nonatomic, strong) NSString * hpUnit;
@property(nonatomic, strong) NSString * torqueUnit;
@property(nonatomic, strong) NSString * speedUnit;
@property(nonatomic, strong) NSString * weightUnit;
@property(nonatomic, strong) NSString * fuelEconomyUnit;

@property(strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property(strong, nonatomic) UIActivityIndicatorView *activityIndicator1;
@property(strong, nonatomic) UIActivityIndicatorView *activityIndicator2;
@property(nonatomic) AVAudioPlayer *avAudioPlayer;
@property(nonatomic) AVAudioPlayer *avAudioPlayer1;
@property(nonatomic) AVAudioPlayer *avAudioPlayer2;

@property(assign) BOOL isPlaying;
@property(assign) BOOL isplaying1;
@property(assign) BOOL isplaying2;
@property(assign) BOOL hasLoaded;
@property(assign) BOOL hasLoaded1;
@property(assign) BOOL hasLoaded2;
@property(assign) BOOL hasCalled;
@property(assign) BOOL shouldBeCompare;
@property(assign) BOOL shouldBeDetail;
@property(nonatomic) double cellWidth;
@property(assign) BOOL shouldLoadImage;
@property(assign) BOOL shouldAnimateCell;
@property(assign) BOOL shouldRevertToDetail;
@property(assign) BOOL cameFromMakes;
@property(assign) BOOL cameFromTopTens;
@property(assign) BOOL cameFromFavorites;
@property(assign) BOOL cameFromModel;
@property(assign) BOOL cameFromHome;
@property(assign) BOOL cameFromSearchModel;
@property(assign) BOOL cameFromSearchTab;
@property(assign) BOOL shouldFadeMakeImage;
@property CGPoint specImageDetailCenter;

#pragma mark -
#pragma mark Methods

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

- (bool)isSaved:(Model *)currentModel;

- (void)getModel:(id)modelObject;
- (void)getCarToLoad:(id)modelObject sender:(id)sender;

-(IBAction)Website;

@end
