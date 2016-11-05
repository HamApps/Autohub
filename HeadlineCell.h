//
//  HeadlineCell.h
//  Carhub
//
//  Created by Christoper Clark on 7/5/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadlineCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *newsImage;
@property (strong, nonatomic) IBOutlet UILabel * newsDescription;

@end
