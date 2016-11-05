//
//  RaceCVCell.h
//  Carhub
//
//  Created by Christoper Clark on 8/25/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RaceCVCell : UICollectionViewCell<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *raceImageView;
@property (weak, nonatomic) IBOutlet UIImageView *raceClassImageView;
@property (weak, nonatomic) IBOutlet UILabel *raceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *raceDateLabel;
@property (weak, nonatomic) IBOutlet UIView *cardView;

@property (strong, nonatomic) IBOutlet UIScrollView *imageScroller;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end
