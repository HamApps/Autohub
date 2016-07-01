//
//  SpecsCell.h
//  Carhub
//
//  Created by Christopher Clark on 6/5/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecsCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel * SpecName;
@property (strong, nonatomic) IBOutlet UILabel * CarValue;
@property (strong, nonatomic) IBOutlet UILabel * CarValue2;
@property (strong, nonatomic) IBOutlet UIImageView * SpecImage;
@property (weak, nonatomic) IBOutlet UIView *cardView;

@property(assign) BOOL hasConvertedToCompare;
@property(assign) BOOL hasRevertedToDetail;

@end
