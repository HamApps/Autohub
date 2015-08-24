//
//  NewsCell.m
//  Carhub
//
//  Created by Christopher Clark on 8/18/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
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
    self.cardView.layer.shadowOpacity = 0.75;
    self.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
    
    self.newsDescription.dataDetectorTypes = UIDataDetectorTypeAll;
    self.newsDescription.userInteractionEnabled = YES;
    self.newsDescription.selectable = NO;
    self.newsDescription.editable = YES;
    
    int height = [UIScreen mainScreen].bounds.size.height;
    if (height == 480 || height == 568)
        [self.newsDescription setFont:[UIFont fontWithName:@"Eurostile" size:16.0f]];
    if (height == 667)
        [self.newsDescription setFont:[UIFont fontWithName:@"Eurostile" size:16.0f]];
    if (height == 736)
        [self.newsDescription setFont:[UIFont fontWithName:@"Eurostile" size:18.0f]];
    self.newsDescription.editable = NO;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
