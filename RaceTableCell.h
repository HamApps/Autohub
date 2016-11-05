//
//  RaceTableCell.h
//  Carhub
//
//  Created by Christoper Clark on 8/26/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RaceTableCell : UITableViewCell<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *raceImageView;
@property (weak, nonatomic) IBOutlet UIImageView *raceClassImageView;
@property (weak, nonatomic) IBOutlet UILabel *raceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *raceDateLabel;
@property (weak, nonatomic) IBOutlet UIView *cardView;

@property (strong, nonatomic) IBOutlet UIScrollView *imageScroller;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end
