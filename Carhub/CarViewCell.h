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
@property (strong, nonatomic) IBOutlet UIImageView * CarImage;
@property (weak, nonatomic) IBOutlet UIView *cardView;

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

@end
