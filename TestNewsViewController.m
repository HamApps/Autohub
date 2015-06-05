//
//  TestNewsViewController.m
//  Carhub
//
//  Created by Christopher Clark on 6/2/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "TestNewsViewController.h"

@interface TestNewsViewController ()

@end

@implementation TestNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:_currentnews.NewsArticleURL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
