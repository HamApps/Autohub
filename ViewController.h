//
//  ViewController.h
//  Carhub
//
//  Created by Christoper Clark on 2/12/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import "News.h"

@interface ViewController : UIViewController <UIScrollViewDelegate, YTPlayerViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet YTPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIView *playerViewContainer;

@property(strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property CGRect initialImageFrame;
@property (nonatomic, strong) NSURL * image1URL;
@property (nonatomic, strong) NSURL * image2URL;
@property (nonatomic, strong) NSURL * image3URL;
@property (nonatomic, strong) NSURL * image4URL;
@property (nonatomic, strong) NSURL * image5URL;

@property (nonatomic, strong) News * currentnews;

- (void)getNews:(id)newsObject;
-(IBAction)selectVideo:(id)sender;
-(IBAction)selectImage:(id)sender;

@end
