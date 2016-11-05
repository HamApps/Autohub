//
//  SpecsCollectionCell.h
//  Carhub
//
//  Created by Christoper Clark on 7/27/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecsCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *specImage;
@property (strong, nonatomic) IBOutlet UIImageView *comparespecImage;
@property (strong, nonatomic) IBOutlet UILabel *specLabel;
@property (strong, nonatomic) IBOutlet UILabel *compareSpecLabel;
@property (strong, nonatomic) IBOutlet UILabel *specValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *specValueLabel2;

@property (strong, nonatomic) IBOutlet UIImageView *leftCellDivider;
@property (strong, nonatomic) IBOutlet UIImageView *rightCellDivider;
@property (strong, nonatomic) IBOutlet UIImageView *middleCellDivider;

@property(assign) BOOL hasConvertedToCompare;
@property CGRect initialSpecImageFrame;
@property CGRect initialSpecLabelFrame;
@property CGRect initialRightDividerFrame;

@end
