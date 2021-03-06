//
//  SpecsCell.m
//  Carhub
//
//  Created by Christopher Clark on 6/5/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "SpecsCell.h"

@implementation SpecsCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [self cardSetup];
}

-(void)cardSetup
{
    [self.cardView setAlpha:1];
    self.cardView.layer.masksToBounds = NO;
    self.cardView.layer.cornerRadius = 2;
    self.cardView.layer.shadowOffset = CGSizeMake(-.2f, .2f);
    self.cardView.layer.shadowRadius = 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.cardView.bounds];
    self.cardView.layer.shadowPath = path.CGPath;
    self.cardView.layer.shadowOpacity = .75;
    self.backgroundColor = [UIColor whiteColor];
}

@end
