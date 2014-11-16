//
//  NewsDetailViewController.h
//  Carhub
//
//  Created by Christopher Clark on 8/23/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsViewController.h"
#import "News.h"

@interface NewsDetailViewController : UIViewController{
    IBOutlet UIImageView *imageview;
    IBOutlet UIScrollView * scroller;
}

@property(nonatomic, strong) IBOutlet UILabel * NewsTitleLabel;
@property(nonatomic, strong) IBOutlet UITextView * NewsArticleLabel;

@property(nonatomic, strong) News * currentnews;

- (void)getNews:(id)newsObject;
- (void)setLabels;

@end
