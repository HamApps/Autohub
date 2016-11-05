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
#import <Google/Analytics.h>

@interface ImageViewController ()

@end

@implementation ImageViewController
@synthesize scrollView, imageview, webView, currentCar, isNewsImage, imageURL;

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
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Image Zoom View"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:YES];
    
    self.barButton.target = self.revealViewController;
    self.barButton.action = @selector(revealToggle:);

    scrollView.maximumZoomScale = 3.0;
    scrollView.minimumZoomScale = 1.0;
    scrollView.clipsToBounds = YES;
    scrollView.delegate = self;
    
    if(currentCar != nil)
    {
        if([currentCar.CarHTML isEqualToString:@""])
        {
            [webView setAlpha:0];
            [imageview setAlpha:1.0];
            
            if([currentCar.CarImageURL containsString:@"carno"])
                imageURL = [NSURL URLWithString:currentCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
            else
                imageURL = [NSURL URLWithString:currentCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];
            
            [imageview sd_setImageWithURL:imageURL];
        }
        else
        {
            [imageview setAlpha:0];
            [webView setAlpha:1];
            webView.delegate = self;
            [webView.scrollView setScrollEnabled:NO];
            [webView loadHTMLString:currentCar.CarHTML baseURL:nil];
            [webView setUserInteractionEnabled:NO];
        }
    }
    else if(isNewsImage)
    {
        [webView setAlpha:0];
        [imageview setAlpha:1.0];
        [imageview sd_setImageWithURL:imageURL];
    }
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [scrollView addGestureRecognizer:doubleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotated:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel.png"] style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
    backButton.tintColor = [UIColor blackColor];
    [self.navigationItem setLeftBarButtonItem: backButton];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goback)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [imageview addGestureRecognizer:swipe];
    [imageview setUserInteractionEnabled:YES];
    
    [scrollView.panGestureRecognizer requireGestureRecognizerToFail:swipe];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView setAlpha:0];
    [UIWebView animateWithDuration:0.5 animations:^{
        [self.webView setAlpha:1.0];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (void)rotated:(NSNotification *)notification
{
    [self.scrollView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [imageview setCenter:self.view.center];
    [webView setCenter:self.view.center];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if(isNewsImage)
        return imageview;
    
    if(currentCar != nil && [currentCar.CarHTML isEqualToString:@""])
        return imageview;
    else
        return webView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = MAX((self.scrollView.bounds.size.width - self.scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((self.scrollView.bounds.size.height - self.scrollView.contentSize.height) * 0.5, 0.0);
    
    webView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX, self.scrollView.contentSize.height * 0.5 + offsetY);
    imageview.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX, self.scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
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

- (void)getModel:(id)modelObject;
{
    currentCar = modelObject;
}

- (void)getArticleImage:(id)articleImageURL;
{
    isNewsImage = YES;
    
    if([articleImageURL containsString:@"newsno"])
        imageURL = [NSURL URLWithString:articleImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/newsimage.php"]];
    else if([articleImageURL containsString:@"raceno"])
        imageURL = [NSURL URLWithString:articleImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/raceimage.php"]];
    else
        imageURL = [NSURL URLWithString:articleImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
}

- (void)goback
{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController popViewControllerAnimated:NO];
    });
}

@end
