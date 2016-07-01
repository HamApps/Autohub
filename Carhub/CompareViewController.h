//
//  CompareViewController.h
//  Carhub
//
//  Created by Christopher Clark on 7/22/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "CircleProgressBar.h"
#import <AVFoundation/AVFoundation.h>

@interface CompareViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, UIScrollViewDelegate>
{
    IBOutlet UIImageView *firstimageview;
    IBOutlet UIImageView *secondimageview;

    IBOutlet UIButton *exhaustButton1;
    IBOutlet UIButton *exhaustButton2;
}

@property (weak, nonatomic) IBOutlet CircleProgressBar *circleProgressBar;
@property (weak, nonatomic) IBOutlet UIView *upperView;
@property(nonatomic) UIActivityIndicatorView *activityIndicator;
@property(nonatomic) UIActivityIndicatorView *activityIndicator1;
@property(nonatomic) UIActivityIndicatorView *activityIndicator2;

@property(nonatomic) AVPlayer *avPlayer;
@property(nonatomic) double exhaustDuration;
@property(nonatomic) double exhaustTracker;
@property(nonatomic) CMTime currentTime;
@property(nonatomic) NSTimer *exhaustTimer;

@property (strong, nonatomic) IBOutlet UIScrollView *hiddenImageScroller;
@property (strong, nonatomic) IBOutlet UIWebView *hiddenWebView;
@property (strong, nonatomic) IBOutlet UIView *hiddenEvoxTrimmingView;
@property (strong, nonatomic) IBOutlet UIImageView *hiddenImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *hiddenImageScroller2;
@property (strong, nonatomic) IBOutlet UIWebView *hiddenWebView2;
@property (strong, nonatomic) IBOutlet UIView *hiddenEvoxTrimmingView2;
@property (strong, nonatomic) IBOutlet UIImageView *hiddenImageView2;
@property (strong, nonatomic) UIImage * finalImage;

@property (strong, nonatomic) IBOutlet UIScrollView *imageScroller1;
@property (strong, nonatomic) IBOutlet UIScrollView *imageScroller2;


@property(nonatomic, strong) IBOutlet UILabel * CarTitleLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarTitleLabel2;

@property (weak, nonatomic) IBOutlet UITableView * SpecsTableView;

@property(nonatomic, strong) Model * firstCar;
@property(nonatomic, strong) Model * secondCar;

@property(assign) BOOL isplaying1;
@property(assign) BOOL isplaying2;
@property(assign) BOOL hasCalled1;
@property(assign) BOOL hasCalled2;

@end
