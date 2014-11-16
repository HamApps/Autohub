//
//  NewsDetailViewController.m
//  Carhub
//
//  Created by Christopher Clark on 8/23/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "NewsDetailViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController

@synthesize NewsArticleLabel, NewsTitleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 1000)];
    
    if (imageview.image ==nil) {
        
        dispatch_async(kBgQueue, ^{
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_currentnews.NewsImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/newsimage.php"]]];
            if (imgData) {
                UIImage *image = [UIImage imageWithData:imgData];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageview.image = image;
                        [UIImageView beginAnimations:nil context:NULL];
                        [UIImageView setAnimationDuration:.75];
                        [imageview setAlpha:1.0];
                        [UIImageView commitAnimations];
                    });
                }
            }
        });
    }
    
    self.title = _currentnews.NewsTitle;
    
    [self setLabels];
    
    NSLog(@"%@", _currentnews);
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getNews:(id)newsObject;
{
    _currentnews = newsObject;
}

- (void)setLabels
{
    NewsTitleLabel.text = _currentnews.NewsTitle;
    NewsArticleLabel.text = _currentnews.NewsArticle;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
