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
    //[self.view bringSubviewToFront:self.loadingWheel];
    self.loadingWheel.animationImages = [NSArray arrayWithObjects: [UIImage imageNamed:@"LoadingWheel.png"],[UIImage imageNamed:@"LoadingWheel1.png"], [UIImage imageNamed:@"LoadingWheel2.png"], [UIImage imageNamed:@"LoadingWheel3.png"], [UIImage imageNamed:@"LoadingWheel4.png"], [UIImage imageNamed:@"LoadingWheel5.png"], [UIImage imageNamed:@"LoadingWheel6.png"], [UIImage imageNamed:@"LoadingWheel7.png"], [UIImage imageNamed:@"LoadingWheel8.png"], [UIImage imageNamed:@"LoadingWheel9.png"], [UIImage imageNamed:@"LoadingWheel10.png"], [UIImage imageNamed:@"LoadingWheel11.png"], [UIImage imageNamed:@"LoadingWheel12.png"], [UIImage imageNamed:@"LoadingWheel13.png"], [UIImage imageNamed:@"LoadingWheel13l"], [UIImage imageNamed:@"LoadingWheel14.png"], [UIImage imageNamed:@"LoadingWheel15.png"], [UIImage imageNamed:@"LoadingWheel16.png"],  nil];
    self.loadingWheel.animationDuration = 0.65f;
    self.loadingWheel.animationRepeatCount = 0;
    [self.loadingWheel startAnimating];
    
    [self.webView setDelegate:self];
    //NSURL *url = [NSURL URLWithString:_currentnews.NewsArticleURL];
    NSURL *url = [NSURL URLWithString:@"http://www.pl0x.net/AutohubNews/?p=32"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"LoadingWheelBackground5.png"]];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[self.loadingWheel stopAnimating];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [self.webView setAlpha:1];
    [UIView commitAnimations];
    [self.loadingWheel stopAnimating];
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
