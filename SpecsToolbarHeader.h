//
//  SpecsToolbarHeader.h
//  Carhub
//
//  Created by Christoper Clark on 7/28/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface SpecsToolbarHeader : UICollectionReusableView<UIScrollViewDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *compareButton;
@property (weak, nonatomic) IBOutlet UIButton *exhaustButton;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) IBOutlet UIButton *pushDetailImageButton;
@property (strong, nonatomic) IBOutlet UIButton *pushCar1ImageButton;
@property (strong, nonatomic) IBOutlet UIButton *pushCar2ImageButton;

@property (weak, nonatomic) IBOutlet UILabel *compareLabel;
@property (weak, nonatomic) IBOutlet UILabel *exhaustLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;

@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstCarNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondCarNameLabel;

@property (strong, nonatomic) IBOutlet UIScrollView *detailImageScroller;
@property (strong, nonatomic) IBOutlet UIScrollView *firstImageScroller;
@property (strong, nonatomic) IBOutlet UIScrollView *secondImageScroller;

@property (weak, nonatomic) IBOutlet UIImageView *detailNormalImageView;
@property (weak, nonatomic) IBOutlet UIImageView *detailEvoxImageView;
@property (weak, nonatomic) IBOutlet UIImageView *firstNormalImageView;
@property (weak, nonatomic) IBOutlet UIImageView *firstEvoxImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondNormalImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondEvoxImageView;

@property (strong, nonatomic) UIScrollView *hiddenImageScroller;
@property (strong, nonatomic) UIWebView *hiddenWebView;
@property (strong, nonatomic) UIView *hiddenEvoxTrimmingView;
@property (strong, nonatomic) UIImageView *hiddenImageView;
@property (strong, nonatomic) UIScrollView *hiddenImageScroller2;
@property (strong, nonatomic) UIWebView *hiddenWebView2;
@property (strong, nonatomic) UIView *hiddenEvoxTrimmingView2;
@property (strong, nonatomic) UIImageView *hiddenImageView2;
@property (strong, nonatomic) UIScrollView *hiddenImageScroller3;
@property (strong, nonatomic) UIWebView *hiddenWebView3;
@property (strong, nonatomic) UIView *hiddenEvoxTrimmingView3;
@property (strong, nonatomic) UIImageView *hiddenImageView3;


@property (nonatomic) IBOutlet UIActivityIndicatorView *exhaustActivityIndicator1;
@property (nonatomic) IBOutlet UIActivityIndicatorView *exhaustActivityIndicator2;

@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIActivityIndicatorView *activityIndicator1;
@property (nonatomic) UIActivityIndicatorView *activityIndicator2;

@property(assign) BOOL hasCalled1;
@property(assign) BOOL hasCalled2;
@property(assign) BOOL hasCalled3;

@property (nonatomic, strong) Model *currentCar;
@property (nonatomic, strong) Model *firstCar;
@property (nonatomic, strong) Model *secondCar;

-(void)setUpDetailCarImageWithModel:(Model *)currentModel;
-(void)setCompareImagesWithFirstModel:(Model *)firstModel andSecondModel:(Model *)secondModel;
-(void)startExhaustLoadingWheel;
-(void)startExhaustLoadingWheel2;

@end
