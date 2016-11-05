//
//  CarViewCell.h
//  Carhub
//
//  Created by Christopher Clark on 7/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface CarViewCell : UITableViewCell <UIScrollViewDelegate, UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel * CarName;
@property (strong, nonatomic) IBOutlet UIImageView * normalImageView;
@property (strong, nonatomic) IBOutlet UIImageView * evoxImageView;
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
@property(assign) BOOL shouldFadeImage;
@property (strong, nonatomic) NSString *htmlString;

@property (nonatomic, strong) Model *cellModel;
-(void)setUpCarImageWithModel:(Model *)currentCar andAlpha:(int)alpha;

-(void)lineViewSetUp;

@end
