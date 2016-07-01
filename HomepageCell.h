//
//  HomepageCell.h
//  Carhub
//
//  Created by Christoper Clark on 1/3/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface HomepageCell : UICollectionViewCell <UIScrollViewDelegate, UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *CellImageView;
@property (weak, nonatomic) IBOutlet UILabel *DescriptionLabel;
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
