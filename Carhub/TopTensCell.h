//
//  TopTensCell.h
//  Carhub
//
//  Created by Christopher Clark on 2/15/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface TopTensCell : UITableViewCell<UIScrollViewDelegate, UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel * CarRank;
@property (strong, nonatomic) IBOutlet UILabel * CarName;
@property (strong, nonatomic) IBOutlet UILabel * CarValue;
@property (strong, nonatomic) IBOutlet UIImageView * normalImageView;
@property (strong, nonatomic) IBOutlet UIImageView * evoxImageView;
@property (strong, nonatomic) IBOutlet UIImageView * RankImageView;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) IBOutlet UIScrollView *imageScroller2;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIScrollView *hiddenImageScroller;
@property (strong, nonatomic) UIWebView *hiddenWebView;
@property (strong, nonatomic) UIView *hiddenEvoxTrimmingView;
@property (strong, nonatomic) UIImageView *hiddenImageView;

@property(assign) BOOL hasCalled;
@property(assign) BOOL isEvox;

@property (nonatomic, strong) Model *cellModel;
-(void)setUpCarImageWithModel:(Model *)currentCar;

-(void)lineViewSetUp;

@end
