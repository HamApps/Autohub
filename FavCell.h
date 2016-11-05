//
//  FavCell.h
//  Carhub
//
//  Created by Christopher Clark on 8/19/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface FavCell : UITableViewCell<UIScrollViewDelegate, UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel * CarName;
@property (strong, nonatomic) IBOutlet UIImageView * normalImageView;
@property (strong, nonatomic) IBOutlet UIImageView * evoxImageView;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIView *innerCardView;
@property (strong, nonatomic) UIView *lineView;

@property (nonatomic) UITableViewCellStateMask cellEditingState;

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
