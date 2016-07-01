//
//  VideoViewController.m
//  Carhub
//
//  Created by Christoper Clark on 6/23/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController
@synthesize currentnews, playerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [playerView loadWithVideoId:@"4c5TXVvJYZI"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)getNews:(id)newsObject;
{
    currentnews = newsObject;
}

@end
