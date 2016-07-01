//
//  ArticleViewController.m
//  Carhub
//
//  Created by Christoper Clark on 6/18/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "ArticleViewController.h"

@interface ArticleViewController ()

@end

@implementation ArticleViewController

@synthesize webView;

- (void)viewDidLoad {
    [super viewDidLoad];

    [webView setDelegate:self];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://www.pl0x.net/AutohubNews/2016-acura-nsx-spied-testing-on-nurburgring/"]];
    [webView loadRequest:request];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
