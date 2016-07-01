//
//  FavCell.m
//  Carhub
//
//  Created by Christopher Clark on 8/19/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "FavCell.h"

@implementation FavCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    [self cardSetup];
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self cardSetup];
    [self sendSubviewToBack:self.contentView];
}

-(void)cardSetup
{
    [self.cardView setAlpha:1];
    self.cardView.layer.masksToBounds = NO;
    self.cardView.layer.cornerRadius = 10;
    self.innerCardView.layer.cornerRadius = 10;
    self.cardView.layer.shadowOffset = CGSizeMake(-.2f, .2f);
    self.cardView.layer.shadowRadius = 1;
    self.cardView.layer.shadowOpacity = .75;
    self.backgroundColor = [UIColor whiteColor];

    //self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cardView.bounds.origin.y+35, CGRectGetWidth(self.cardView.bounds), 1.5)];
    self.lineView.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
    [self.innerCardView addSubview:self.lineView];
    //self.innerCardView.backgroundColor = [UIColor blackColor];
    self.innerCardView.layer.masksToBounds = YES;
}

/*- (void)setEditing:(BOOL)editing
          animated:(BOOL)animated
{

}*/

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
