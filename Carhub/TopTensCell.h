//
//  TopTensCell.h
//  Carhub
//
//  Created by Christopher Clark on 2/15/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopTensCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel * CarRank;
@property (strong, nonatomic) IBOutlet UILabel * CarName;
@property (strong, nonatomic) IBOutlet UILabel * CarValue;
@property (strong, nonatomic) IBOutlet UIImageView * CarImage;

@end
