//
//  DetailViewController.h
//  Carhub
//
//  Created by Christopher Clark on 7/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "CircleProgressBar.h"
#import <AVFoundation/AVFoundation.h>
#import "Currency.h"

@interface DetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *compareButton;
@property (weak, nonatomic) IBOutlet UIButton *exhaustButton;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UIButton *changeCar1Button;
@property (weak, nonatomic) IBOutlet UIButton *exhaustButton1;
@property (weak, nonatomic) IBOutlet UIButton *exhaustButton2;
@property (weak, nonatomic) IBOutlet UIButton *changeCar2Button;

@property (weak, nonatomic) IBOutlet UILabel *compareLabel;
@property (weak, nonatomic) IBOutlet UILabel *exhaustLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstCarNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondCarNameLabel;
@property (strong, nonatomic) IBOutlet UITableView * SpecsTableView;
@property (nonatomic, strong) NSMutableArray * savedArray;
@property (weak, nonatomic) IBOutlet UIImageView *toolBarBackground;
@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet CircleProgressBar *circleProgressBar;

@property(nonatomic, strong) Model * currentCar;
@property(nonatomic, strong) Model * firstCar;
@property(nonatomic, strong) Model * secondCar;
@property(nonatomic, strong) NSString * currencySymbol;
@property(nonatomic, strong) NSString * hpUnit;
@property(nonatomic, strong) NSString * speedUnit;
@property(nonatomic, strong) NSString * weightUnit;
@property(nonatomic, strong) NSString * fuelEconomyUnit;

@property(nonatomic) UIActivityIndicatorView *activityIndicator;
@property(nonatomic) UIActivityIndicatorView *activityIndicator1;
@property(nonatomic) UIActivityIndicatorView *activityIndicator2;
@property(nonatomic) AVPlayer *avPlayer;
@property(nonatomic) double exhaustDuration;
@property(nonatomic) double exhaustTracker;
@property(nonatomic) CMTime currentTime;
@property(nonatomic) NSTimer *exhaustTimer;

@property(assign) BOOL isPlaying;
@property(assign) BOOL isplaying1;
@property(assign) BOOL isplaying2;
@property(assign) BOOL hasCalled;
@property(assign) BOOL hasCalled1;
@property(assign) BOOL hasCalled2;
@property(assign) BOOL shouldLoadImage;
@property(assign) BOOL shouldHaveSpecName;
@property(assign) BOOL shouldRevertToDetail;
@property CGPoint specImageDetailCenter;

@property (strong, nonatomic) UIScrollView *hiddenImageScroller;
@property (strong, nonatomic) UIWebView *hiddenWebView;
@property (strong, nonatomic) UIView *hiddenEvoxTrimmingView;
@property (strong, nonatomic) UIImageView *hiddenImageView;
@property (strong, nonatomic) UIScrollView *hiddenImageScroller2;
@property (strong, nonatomic) UIWebView *hiddenWebView2;
@property (strong, nonatomic) UIView *hiddenEvoxTrimmingView2;
@property (strong, nonatomic) UIImageView *hiddenImageView2;
@property (strong, nonatomic) UIImage * finalImage;

@property (strong, nonatomic) IBOutlet UIScrollView *firstImageScroller;
@property (strong, nonatomic) IBOutlet UIScrollView *secondImageScroller;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;


#pragma mark -
#pragma mark Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (bool)isSaved:(Model *)currentModel;
- (void)checkStar;

- (void)getModel:(id)modelObject;
- (void)getCarOfTheDay:(id)modelObject;

-(IBAction)Website;
-(IBAction)Compare;

@end
