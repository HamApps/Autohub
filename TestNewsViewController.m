//
//  TestNewsViewController.m
//  Carhub
//
//  Created by Christopher Clark on 6/2/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "TestNewsViewController.h"
#import "SWRevealViewController.h"

@interface TestNewsViewController ()

@end

@implementation TestNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:self.loadingWheel];
    self.loadingWheel.animationImages = [NSArray arrayWithObjects: [UIImage imageNamed:@"LoadingWheelBackground1.png"], [UIImage imageNamed:@"LoadingWheelBackground2.png"], [UIImage imageNamed:@"LoadingWheelBackground3.png"], [UIImage imageNamed:@"LoadingWheelBackground4.png"], [UIImage imageNamed:@"LoadingWheelBackgroundS.png"], [UIImage imageNamed:@"LoadingWheelBackground6.png"], [UIImage imageNamed:@"LoadingWheelBackground7.png"], [UIImage imageNamed:@"LoadingWheelBackground8.png"], [UIImage imageNamed:@"LoadingWheelBackground9.png"], [UIImage imageNamed:@"LoadingWheelBackground10.png"], [UIImage imageNamed:@"LoadingWheelBackground11.png"], [UIImage imageNamed:@"LoadingWheelBackground12.png"], [UIImage imageNamed:@"LoadingWheelBackground13.png"], [UIImage imageNamed:@"LoadingWheelBackground14.png"], [UIImage imageNamed:@"LoadingWheelBackground15.png"], [UIImage imageNamed:@"LoadingWheelBackground16.png"], [UIImage imageNamed:@"LoadingWheelBackground17.png"], [UIImage imageNamed:@"LoadingWheelBackground18.png"], nil];
    self.loadingWheel.animationDuration = 0.65f;
    self.loadingWheel.animationRepeatCount = 0;
    [self.loadingWheel startAnimating];
    
    [self.webView setDelegate:self];
    NSURL *url = [NSURL URLWithString:_currentnews.NewsArticleURL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"meow");
    [self.loadingWheel stopAnimating];
    if (self.webView.alpha ==0)
    {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [self.webView setAlpha:1];
    [UIView commitAnimations];
    }
}

- (void)getNews:(id)newsObject;
{
    _currentnews = newsObject;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
