//
//  TestNewsViewController.m
//  Carhub
//
//  Created by Christopher Clark on 6/2/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "TestNewsViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"

@interface TestNewsViewController ()

@end

@implementation TestNewsViewController

@synthesize isLoadingNews;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.view bringSubviewToFront:self.loadingWheel];
    //self.loadingWheel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LittleWheel3.png"]];
    [self.loadingWheel setImage:[UIImage imageNamed:@"LittleWheel3.png"]];
    
    [self.webView setDelegate:self];
    NSURL *url = [NSURL URLWithString:_currentnews.NewsArticleURL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    isLoadingNews = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    isLoadingNews = NO;
    [self.loadingWheel setAlpha:0];
     
    [self.view bringSubviewToFront:self.webView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [self.webView setAlpha:1];
    [UIView commitAnimations];
    
    NSLog(@"Did it!");
    [self.loadingWheel stopAnimating];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:YES];
}


@end
