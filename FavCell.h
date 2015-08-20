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

@end
