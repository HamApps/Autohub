//
//  CompareViewController.m
//  Carhub
//
//  Created by Christopher Clark on 10/17/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "CompareViewController.h"
#import "AppDelegate.h"
#import "ImageViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "SpecsCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface CompareViewController ()

@end

@implementation CompareViewController

@synthesize firstCar, secondCar, SpecsTableView, CarTitleLabel, CarTitleLabel2, activityIndicator, avPlayer, exhaustTimer, exhaustTracker, exhaustDuration, currentTime, upperView, isplaying2, isplaying1, circleProgressBar, hiddenWebView, hiddenImageView, hiddenEvoxTrimmingView, hiddenImageScroller, finalImage, hasCalled1, hasCalled2, hiddenWebView2, hiddenImageView2, hiddenImageScroller2, hiddenEvoxTrimmingView2, activityIndicator1, activityIndicator2, imageScroller1, imageScroller2;

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
    
    [self getcars];
    [self setCarImages];
    [self setUpExhaustProgressWheel];
    
    [upperView sendSubviewToBack:imageScroller1];
    [upperView sendSubviewToBack:imageScroller2];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Model Comparison";
    if(firstCar != NULL)
        CarTitleLabel.text = [[firstCar.CarMake stringByAppendingString:@" "] stringByAppendingString:firstCar.CarModel];
    if(secondCar != NULL)
        CarTitleLabel2.text = [[secondCar.CarMake stringByAppendingString:@" "] stringByAppendingString:secondCar.CarModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    if(firstCar != NULL && !([firstCar.CarExhaust isEqual:@""]))
        [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"ExhaustPlay2.png"] forState:UIControlStateNormal];
    else if(firstCar != NULL)
        [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"ExhaustFade.png"] forState:UIControlStateNormal];
    if(secondCar != NULL && !([secondCar.CarExhaust isEqual:@""]))
        [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"ExhaustPlay2.png"] forState:UIControlStateNormal];
    else if(secondCar != NULL)
        [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"ExhaustFade.png"] forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [avPlayer removeObserver:self forKeyPath:@"status"];
    avPlayer = NULL;
}

-(void)setCarImages
{
    if(![firstCar.CarHTML isEqualToString:@""])
    {
        //Load Evox Image
        [self startLoadingWheel1WithCenter:firstimageview.center];
        
        //Create Evox Trimmers outside of screen's view
        hiddenImageScroller = [[UIScrollView alloc]initWithFrame:(CGRectMake(-500, 61, 320, 145))];
        hiddenWebView = [[UIWebView alloc]initWithFrame:(CGRectMake(0, 0, 320, 193))];
        hiddenImageScroller.delegate = self;
        hiddenWebView.delegate = self;
        [hiddenImageScroller addSubview:hiddenWebView];
        
        hiddenEvoxTrimmingView = [[UIView alloc]initWithFrame:(CGRectMake(-500, 0, 288, 145))];
        hiddenImageView = [[UIImageView alloc]initWithFrame:(CGRectMake(-41, -25, 370, 195))];
        [hiddenEvoxTrimmingView addSubview:hiddenImageView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [hiddenWebView loadHTMLString:firstCar.CarHTML baseURL:nil];
        });
    }
    else
    {
        [firstimageview setAlpha:1];
        __weak UIImageView *weakFirstImageView = firstimageview;
        
        NSURL *imageURL;
        if([firstCar.CarImageURL containsString:@"carno"])
            imageURL = [NSURL URLWithString:firstCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
        else
            imageURL = [NSURL URLWithString:firstCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];
        
        double zoomScale = [firstCar.ZoomScale doubleValue];
        double offSetX = [firstCar.OffsetX doubleValue];
        double offSetY = [firstCar.OffsetY doubleValue];
        
        imageScroller1.delegate = self;
        firstimageview.backgroundColor = [UIColor blackColor];
        
        firstimageview.contentMode = UIViewContentModeScaleAspectFit;
        if(zoomScale != 0)
        {
            imageScroller1.maximumZoomScale = 1.2;
            imageScroller1.minimumZoomScale = 1.2;
            imageScroller1.zoomScale = 1.2;
        }
        [imageScroller1 setContentOffset:CGPointMake(offSetX/2, offSetY/2)];
        [imageScroller1 setScrollEnabled:NO];
        
        [weakFirstImageView setImageWithURL:imageURL
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                      [weakFirstImageView setAlpha:0.0];
                                      [UIImageView animateWithDuration:.5 animations:^{
                                          [weakFirstImageView setAlpha:1.0];
                                      }];
                                  }
                usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    if(![secondCar.CarHTML isEqualToString:@""])
    {
        //Load Evox Image
        [self startLoadingWheel2WithCenter:secondimageview.center];
        
        //Create Evox Trimmers outside of screen's view
        hiddenImageScroller2 = [[UIScrollView alloc]initWithFrame:(CGRectMake(-500, 61, 320, 145))];
        hiddenWebView2 = [[UIWebView alloc]initWithFrame:(CGRectMake(0, 0, 320, 193))];
        hiddenImageScroller2.delegate = self;
        hiddenWebView2.delegate = self;
        [hiddenImageScroller2 addSubview:hiddenWebView2];
        
        hiddenEvoxTrimmingView2 = [[UIView alloc]initWithFrame:(CGRectMake(-500, 0, 288, 145))];
        hiddenImageView2 = [[UIImageView alloc]initWithFrame:(CGRectMake(-41, -25, 370, 195))];
        [hiddenEvoxTrimmingView2 addSubview:hiddenImageView2];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [hiddenWebView2 loadHTMLString:secondCar.CarHTML baseURL:nil];
        });
    }
    else
    {
        [secondimageview setAlpha:1];
        __weak UIImageView *weakSecondImageView = secondimageview;
        
        NSURL *imageURL;
        if([secondCar.CarImageURL containsString:@"carno"])
            imageURL = [NSURL URLWithString:secondCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
        else
            imageURL = [NSURL URLWithString:secondCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];
        
        double zoomScale = [secondCar.ZoomScale doubleValue];
        double offSetX = [secondCar.OffsetX doubleValue];
        double offSetY = [secondCar.OffsetY doubleValue];
        
        imageScroller2.delegate = self;
        secondimageview.backgroundColor = [UIColor blackColor];
        
        secondimageview.contentMode = UIViewContentModeScaleAspectFit;
        if(zoomScale != 0)
        {
            imageScroller2.maximumZoomScale = zoomScale;
            imageScroller2.minimumZoomScale = zoomScale;
            imageScroller2.zoomScale = zoomScale;
        }
        [imageScroller2 setContentOffset:CGPointMake(offSetX/2, offSetY/2)];
        [imageScroller2 setScrollEnabled:NO];
        
        [weakSecondImageView setImageWithURL:imageURL
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                      [weakSecondImageView setAlpha:0.0];
                                      [UIImageView animateWithDuration:.5 animations:^{
                                          [weakSecondImageView setAlpha:1.0];
                                      }];
                                  }
                usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
}

- (void)setUpExhaustProgressWheel
{
    circleProgressBar.progressBarWidth = 5;
    circleProgressBar.progressBarTrackColor = [UIColor whiteColor];
    circleProgressBar.progressBarProgressColor = [UIColor blackColor];
    circleProgressBar.startAngle = -90;
    circleProgressBar.alpha = 0;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if(scrollView == hiddenImageScroller)
        return hiddenWebView;
    else if (scrollView == hiddenImageScroller2)
        return hiddenWebView2;
    else if (scrollView == imageScroller1)
        return firstimageview;
    else if (scrollView == imageScroller2)
        return secondimageview;
    else
        return hiddenWebView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    UIScrollView *webViewScroller;
    
    if(webView == hiddenWebView)
    {
        if(hasCalled1 == YES)
            return;
        hasCalled1 = YES;
        webViewScroller = hiddenImageScroller;
    }
    
    if(webView == hiddenWebView2)
    {
        if(hasCalled2 == YES)
            return;
        hasCalled2 = YES;
        webViewScroller = hiddenImageScroller2;
    }
    
    webViewScroller.maximumZoomScale = 1.1;
    webViewScroller.minimumZoomScale = 1.1;
    webViewScroller.zoomScale = 1.1;
    [webViewScroller setContentOffset:CGPointMake(60, 20)];
    
    [webView setAlpha:1.0];
    //allow time for webview to load and then trim and convert the html file to the imageview
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self imageFromWebView:webView];
    });

}

- (UIImage *) imageFromWebView:(UIWebView *)webView
{
    // do image magic
    
    UIImageView *imageView;
    UIImageView *finalImageView;
    UIActivityIndicatorView *loadingWheel;
    
    if(webView == hiddenWebView)
    {
        imageView = hiddenImageView;
        finalImageView = firstimageview;
        loadingWheel = activityIndicator1;
    }
    else if(webView == hiddenWebView2)
    {
        imageView = hiddenImageView2;
        finalImageView = secondimageview;
        loadingWheel = activityIndicator2;
    }
    
    UIGraphicsBeginImageContextWithOptions(webView.bounds.size, NO, 0.0);
    [webView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageView setImage:image];
    [imageView setAlpha:1.0];
    [webView setAlpha:0.0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        //First Evox Cut
        CGSize size = imageView.bounds.size;
        CGRect rect = CGRectMake(size.width / 9, size.height / 1.2 ,
                                 (size.width / .5), (size.height / .6));
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
        UIImage *img = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        [imageView setFrame:CGRectMake(0, 0, 288, 145)];
        [imageView setImage:img];
        
        //Second Evox Cut
        size = imageView.bounds.size;
        rect = CGRectMake(size.width / 9, size.height / 1.2 ,
                          (size.width / .5), (size.height / .6));
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
        img = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        NSLog(@"img: %@", img);
        
        [imageView setFrame:CGRectMake(0, 0, 288, 145)];
        [imageView setImage:img];
        
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        //Create Final Evox ImageView
        CGSize newSize = finalImageView.bounds.size;
        UIGraphicsBeginImageContextWithOptions(newSize, YES, [UIScreen mainScreen].scale);
        [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        finalImage = newImage;
        [finalImageView setAlpha:0];
        [finalImageView setImage:newImage];
        [loadingWheel stopAnimating];
        [UIImageView animateWithDuration:.5 animations:^{
            [finalImageView setAlpha:1.0];
        }];
        finalImageView.layer.borderWidth = 1.0;
        finalImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    });
    return finalImage;
}


-(void)startLoadingWheel1WithCenter:(CGPoint)center
{
    activityIndicator1 = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator1.center = center;
    activityIndicator1.hidesWhenStopped = YES;
    activityIndicator1.color = [UIColor blackColor];
    [self.upperView addSubview:activityIndicator1];
    [activityIndicator1 startAnimating];
}

-(void)startLoadingWheel2WithCenter:(CGPoint)center
{
    activityIndicator2 = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator2.center = center;
    activityIndicator2.hidesWhenStopped = YES;
    activityIndicator2.color = [UIColor blackColor];
    [self.upperView addSubview:activityIndicator2];
    [activityIndicator2 startAnimating];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"meow");
    static NSString *CellIdentifier = @"SpecsCell";
    SpecsCell *cell = (SpecsCell *)[SpecsTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[SpecsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    if(indexPath.row == 0)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"YearsMade.png"];
        cell.SpecName.text = @"Years Made";
        if(firstCar != NULL)
            cell.CarValue.text = firstCar.CarYearsMade;
        if(secondCar != NULL)
            cell.CarValue2.text = secondCar.CarYearsMade;
    }
    if(indexPath.row == 1)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"Price.png"];
        cell.SpecName.text = @"Price";
        if(firstCar != NULL)
            cell.CarValue.text = [@"$" stringByAppendingString:firstCar.CarPrice];
        if(secondCar != NULL)
            cell.CarValue2.text = [@"$" stringByAppendingString:secondCar.CarPrice];

    }
    if(indexPath.row == 2)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"Engine.png"];
        cell.SpecName.text = @"Engine";
        if(firstCar != NULL)
            cell.CarValue.text = firstCar.CarEngine;
        if(secondCar != NULL)
            cell.CarValue2.text = secondCar.CarEngine;
    }
    if(indexPath.row == 3)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"Transmission.png"];
        cell.SpecName.text = @"Transmission";
        if(firstCar != NULL)
            cell.CarValue.text = firstCar.CarTransmission;
        if(secondCar != NULL)
            cell.CarValue2.text = secondCar.CarTransmission;
    }
    if(indexPath.row == 4)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"DriveType.png"];
        cell.SpecName.text = @"Drive Time";
        if(firstCar != NULL)
            cell.CarValue.text = firstCar.CarDriveType;
        if(secondCar != NULL)
            cell.CarValue2.text = secondCar.CarDriveType;
    }
    if(indexPath.row == 5)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"Horsepower.png"];
        cell.SpecName.text = @"Horsepower";
        if(firstCar != NULL)
            cell.CarValue.text = [firstCar.CarHorsepower stringByAppendingString:@" hp"];
        if(secondCar != NULL)
            cell.CarValue2.text = [secondCar.CarHorsepower stringByAppendingString:@" hp"];
    }
    if(indexPath.row == 6)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"0-60.png"];
        cell.SpecName.text = @"0-60";
        if(firstCar != NULL)
            cell.CarValue.text = firstCar.CarZeroToSixty;
        if(secondCar != NULL)
            cell.CarValue2.text = secondCar.CarZeroToSixty;
    }
    if(indexPath.row == 7)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"TopSpeed.png"];
        cell.SpecName.text = @"Top Speed";
        if(firstCar != NULL)
            cell.CarValue.text = [firstCar.CarTopSpeed stringByAppendingString:@" mph"];
        if(secondCar != NULL)
            cell.CarValue2.text = [secondCar.CarTopSpeed stringByAppendingString:@" mph"];
    }
    if(indexPath.row == 8)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"Weight.png"];
        cell.SpecName.text = @"Weight";
        if(firstCar != NULL)
            cell.CarValue.text = [firstCar.CarWeight stringByAppendingString:@" lbs"];
        if(secondCar != NULL)
            cell.CarValue2.text = [secondCar.CarWeight stringByAppendingString:@" lbs"];
    }
    if(indexPath.row == 9)
    {
        cell.SpecImage.image = [UIImage imageNamed:@"FuelEconomy.png"];
        cell.SpecName.text = @"Fuel Economy";
        if(firstCar != NULL)
            cell.CarValue.text = [firstCar.CarFuelEconomy stringByAppendingString:@" mpg"];
        if(secondCar != NULL)
            cell.CarValue2.text = [secondCar.CarFuelEconomy stringByAppendingString:@" mpg"];
    }
    return cell;
}

#pragma mark Exhaust Methods

-(IBAction)Sound1
{
    if(isplaying2 == YES)
    {
        [avPlayer removeObserver:self forKeyPath:@"status"];
        avPlayer = NULL;
        exhaustTracker = 0;
        [exhaustTimer invalidate];
        exhaustTimer = nil;
        isplaying2 = NO;
        [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"ExhaustPlay2.png"] forState:UIControlStateNormal];
    }
    
    if(!([firstCar.CarExhaust isEqual:@""]))
    {
        if (!((avPlayer.rate != 0) && (avPlayer.error == nil)))
        {
            isplaying1 = YES;
            [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"ExhaustPause2.png"] forState:UIControlStateNormal];
            
            if(avPlayer == NULL)
            {
                [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"ExhaustEmpty.png"] forState:UIControlStateNormal];
                [self startLoadingWheel];
                [self playExhaust1];
            }
            else
            {
                [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"ExhaustPause2.png"] forState:UIControlStateNormal];
                [self playAt:currentTime];
            }
        }else{
            [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"ExhaustPlay2.png"] forState:UIControlStateNormal];
            currentTime = avPlayer.currentTime;
            [avPlayer pause];
            [exhaustTimer invalidate];
            exhaustTimer = nil;
        }
    }
}

-(IBAction)Sound2
{
    if(isplaying1 == YES)
    {
        [avPlayer removeObserver:self forKeyPath:@"status"];
        avPlayer = NULL;
        exhaustTracker = 0;
        [exhaustTimer invalidate];
        exhaustTimer = nil;
        isplaying1 = NO;
        [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"ExhaustPlay2.png"] forState:UIControlStateNormal];
    }
    
    if(!([secondCar.CarExhaust isEqual:@""]))
    {
        if (!((avPlayer.rate != 0) && (avPlayer.error == nil)))
        {
            isplaying2 = YES;
            
            if(avPlayer == NULL)
            {
                [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"ExhaustEmpty.png"] forState:UIControlStateNormal];
                [self startLoadingWheel];
                [self playExhaust2];
            }
            else
            {
                [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"ExhaustPause2.png"] forState:UIControlStateNormal];
                [self playAt:currentTime];
            }
        }else{
            [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"ExhaustPlay2.png"] forState:UIControlStateNormal];
            currentTime = avPlayer.currentTime;
            [avPlayer pause];
            [exhaustTimer invalidate];
            exhaustTimer = nil;
        }
    }
}

-(void)startLoadingWheel
{
    activityIndicator = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    if(isplaying1)
        activityIndicator.center = exhaustButton1.center;
    else
        activityIndicator.center = exhaustButton2.center;
    activityIndicator.transform = CGAffineTransformMakeScale(0.5, 0.5);
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.color = [UIColor blackColor];
    [self.upperView addSubview:activityIndicator];
    [activityIndicator startAnimating];
}

-(void)playExhaust1
{
    NSString * soundurl = [@"http://www.pl0x.net/CarSounds/" stringByAppendingString:firstCar.CarExhaust];
    avPlayer = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:soundurl]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[avPlayer currentItem]];
    [avPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
}

-(void)playExhaust2
{
    NSString * soundurl = [@"http://www.pl0x.net/CarSounds/" stringByAppendingString:secondCar.CarExhaust];
    avPlayer = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:soundurl]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[avPlayer currentItem]];
    [avPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
}

- (void)updateProgress
{
    exhaustTracker += .05;
    [circleProgressBar setProgress:exhaustTracker/exhaustDuration animated:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == avPlayer && [keyPath isEqualToString:@"status"]) {
        if (avPlayer.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
            
        } else if (avPlayer.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            [avPlayer play];
            
            exhaustTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:exhaustTimer forMode:NSRunLoopCommonModes];
            exhaustDuration = CMTimeGetSeconds(avPlayer.currentItem.asset.duration);
            [circleProgressBar setProgress:1 animated:YES duration:exhaustDuration];
            circleProgressBar.alpha = 1;
            [activityIndicator stopAnimating];
            if(isplaying1)
                [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"ExhaustPause2.png"] forState:UIControlStateNormal];
            else
                [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"ExhaustPause2.png"] forState:UIControlStateNormal];


            
        } else if (avPlayer.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
        }
    }
}

-(void)playAt: (CMTime)time {
    if(avPlayer.status == AVPlayerStatusReadyToPlay && avPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        [avPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            [avPlayer play];
            exhaustTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        }];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self playAt:time];
        });
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    circleProgressBar.alpha = 0;
    [avPlayer removeObserver:self forKeyPath:@"status"];
    [circleProgressBar setProgress:0 animated:NO];
    [exhaustButton1 setBackgroundImage:[UIImage imageNamed:@"ExhaustPlay2.png"] forState:UIControlStateNormal];
    [exhaustButton2 setBackgroundImage:[UIImage imageNamed:@"ExhaustPlay2.png"] forState:UIControlStateNormal];
    avPlayer = NULL;
    [exhaustTimer invalidate];
    exhaustTimer = nil;
    
    NSLog(@"exhaustTracker: %f", exhaustTracker);
    exhaustTracker = 0.0;
}

#pragma mark -
#pragma mark Methods

-(void)getCars
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *firstCarData = [defaults objectForKey:@"firstcar"];
    firstCar = [NSKeyedUnarchiver unarchiveObjectWithData:firstCarData];
    NSData *secondCarData = [defaults objectForKey:@"secondcar"];
    secondCar = [NSKeyedUnarchiver unarchiveObjectWithData:secondCarData];
}

-(void)getcars
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *savedFirstCarData = [defaults objectForKey:@"firstcar"];
    NSData *savedSecondCarData = [defaults objectForKey:@"secondcar"];

    if(savedFirstCarData != NULL)
    {
        firstCar = [NSKeyedUnarchiver unarchiveObjectWithData:savedFirstCarData];
        
        NSData *secondCarData = [defaults objectForKey:@"savedcar"];
        secondCar = [NSKeyedUnarchiver unarchiveObjectWithData:secondCarData];
        
        [defaults setObject:secondCarData forKey:@"secondcar"];
    }
    else if(savedSecondCarData != NULL)
    {
        secondCar = [NSKeyedUnarchiver unarchiveObjectWithData:savedSecondCarData];
        
        NSData *firstCarData = [defaults objectForKey:@"savedcar"];
        firstCar = [NSKeyedUnarchiver unarchiveObjectWithData:firstCarData];
        
        [defaults setObject:firstCarData forKey:@"firstcar"];
    }
    else
    {
        NSData *firstCarData = [defaults objectForKey:@"savedcar"];
        firstCar = [NSKeyedUnarchiver unarchiveObjectWithData:firstCarData];
        
        [defaults setObject:firstCarData forKey:@"firstcar"];
        secondCar = NULL;
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"compareimage1"])
    {
        //Get the object for the selected row
        [[segue destinationViewController] getfirstModel:firstCar];
    }
    if ([[segue identifier] isEqualToString:@"compareimage2"])
    {
        //Get the object for the selected row
        [[segue destinationViewController] getsecondModel:secondCar];
    }
    if ([[segue identifier] isEqualToString:@"changeCar1"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"firstcar"];
    }
    if ([[segue identifier] isEqualToString:@"changeCar2"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"secondcar"];
    }
}

@end