//
//  NewsCell.h
//  Carhub
//
//  Created by Christopher Clark on 8/18/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *newsImage;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (strong, nonatomic) IBOutlet UILabel * newsDescription;

@end
