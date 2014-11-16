//
//  CarViewCell.h
//  Carhub
//
//  Created by Christopher Clark on 7/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel * CarName;
@property (strong, nonatomic) IBOutlet UIImageView * CarImage;

@property (strong, nonatomic) IBOutlet UILabel * NewsDescription;

@end
