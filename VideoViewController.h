//
//  VideoViewController.h
//  Carhub
//
//  Created by Christoper Clark on 6/23/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import "News.h"

@interface VideoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;

@property CGRect initialImageFrame;

@property (nonatomic, strong) News * currentnews;

- (void)getNews:(id)newsObject;

@end
