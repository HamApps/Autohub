//
//  ImageViewController.m
//  Carhub
//
//  Created by Christopher Clark on 7/27/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "ImageViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

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
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
    
    self.barButton.target = self.revealViewController;
    self.barButton.action = @selector(revealToggle:);

    scrollView.maximumZoomScale = 3.0;
    scrollView.minimumZoomScale = 1.0;
    scrollView.clipsToBounds = YES;
    scrollView.delegate = self;
    [scrollView addSubview:imageview];
    
    [imageview setAlpha:1.0];
    [imageview sd_setImageWithURL:[NSURL URLWithString:_currentCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [scrollView addGestureRecognizer:doubleTap];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageview;
}


- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    if(scrollView.zoomScale == scrollView.maximumZoomScale)
        [scrollView setZoomScale:scrollView.minimumZoomScale animated:YES];
    else
        [scrollView setZoomScale:scrollView.maximumZoomScale animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getfirstModel:(id)firstcarObject;
{
    _currentCar = firstcarObject;
}
- (void)getsecondModel:(id)secondcarObject;
{
    _currentCar = secondcarObject;
}

/*
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    No Navigation on this page right now.
}
*/

@end
