//
//  RaceTableCell.m
//  Carhub
//
//  Created by Christoper Clark on 8/26/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "RaceTableCell.h"

@implementation RaceTableCell
@synthesize cardView;

-(void)layoutSubviews
{
    [self cardSetup];
}

-(void)prepareForReuse
{
    for(UIView *view in self.cardView.subviews)
    {
        if([view isMemberOfClass:[UIActivityIndicatorView class]])
            [view removeFromSuperview];
    }
}

-(void)cardSetup
{
    [cardView setAlpha:1];
    cardView.layer.masksToBounds = NO;
    cardView.layer.cornerRadius = 10;
    cardView.layer.shadowOffset = CGSizeMake(-.2f, .2f);
    cardView.layer.shadowRadius = 1.5;
    cardView.layer.shadowOpacity = .5;
    cardView.backgroundColor = [UIColor whiteColor];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
