//
//  FavCell.h
//  Carhub
//
//  Created by Christopher Clark on 8/19/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel * CarName;
@property (strong, nonatomic) IBOutlet UIImageView * CarImage;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIView *innerCardView;
@property (strong, nonatomic) UIView *lineView;

@property (nonatomic) UITableViewCellStateMask cellEditingState;

@end
