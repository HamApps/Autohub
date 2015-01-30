//
//  NewsDetailViewControllerwAds.h
//  Carhub
//
//  Created by Christopher Clark on 1/28/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsViewController.h"
#import "News.h"

@interface NewsDetailViewControllerwAds : UIViewController{
    IBOutlet UIImageView *imageview;
    IBOutlet UIScrollView * scroller;
}

@property(nonatomic, strong) IBOutlet UILabel * NewsTitleLabel;
@property(nonatomic, strong) IBOutlet UITextView * NewsArticleLabel;
@property(nonatomic, strong) IBOutlet UILabel * NewsDateLabel;

@property(nonatomic, strong) News * currentnews;

- (void)getNews:(id)newsObject;
- (void)setLabels;

@end
