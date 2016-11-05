//
//  SpecsCollectionCell.m
//  Carhub
//
//  Created by Christoper Clark on 7/27/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "SpecsCollectionCell.h"

@implementation SpecsCollectionCell
@synthesize leftCellDivider, rightCellDivider, middleCellDivider, specImage, specLabel, specValueLabel, initialSpecImageFrame, initialSpecLabelFrame, initialRightDividerFrame;

-(void)layoutSubviews
{
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    initialSpecImageFrame = specImage.frame;
    initialSpecLabelFrame = specLabel.frame;
    initialRightDividerFrame = rightCellDivider.frame;
}

@end
