//
//  HomepageCell.m
//  Carhub
//
//  Created by Christoper Clark on 1/3/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "HomepageCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "SDImageCache.h"

@implementation HomepageCell

@synthesize hiddenWebView, hiddenImageView, hiddenImageScroller, hiddenEvoxTrimmingView, activityIndicator, imageScroller2, hasCalled, isEvox, cellModel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews
{
    [self cardSetup];
    hasCalled = NO;
}

-(void)removeFromSuperview
{
    NSLog(@"removefromsuperview");
}

-(void)cardSetup
{
    [self.cardView setAlpha:1];
    self.cardView.layer.masksToBounds = NO;
    self.cardView.layer.cornerRadius = 2;
    self.cardView.layer.shadowOffset = CGSizeMake(-.2f, .2f);
    self.cardView.layer.shadowRadius = 1.5;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.cardView.bounds];
    self.cardView.layer.shadowPath = path.CGPath;
    self.cardView.layer.shadowOpacity = .75;
    self.backgroundColor = [UIColor whiteColor];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if(![cellModel.CarHTML isEqualToString:@""])
        return hiddenWebView;
    else
        return self.CellImageView;
}

-(void)setUpCarImageWithModel:(Model *)currentCar
{
    imageScroller2.maximumZoomScale = 1.0;
    imageScroller2.minimumZoomScale = 1.0;
    imageScroller2.zoomScale = 1.0;
    [imageScroller2 setContentOffset:CGPointMake(0, 0)];
    
    cellModel = currentCar;
    if(![currentCar.CarHTML isEqualToString:@""])
    {
        isEvox = YES;
        if([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cellModel.CarFullName] != NULL)
        {
            [self.CellImageView setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cellModel.CarFullName]];
            self.CellImageView.layer.borderWidth = 2.0;
            self.CellImageView.layer.borderColor = [UIColor whiteColor].CGColor;
            return;
        }
        
        //Load Evox Image
        [self.CellImageView setAlpha:0.0];
        [self startLoadingWheelWithCenter:self.CellImageView.center];
        
        //Create Evox Trimmers outside of screen's view
        hiddenImageScroller = [[UIScrollView alloc]initWithFrame:(CGRectMake(-500, 61, 320, 145))];
        hiddenWebView = [[UIWebView alloc]initWithFrame:(CGRectMake(0, 0, 320, 193))];
        hiddenImageScroller.delegate = self;
        hiddenWebView.delegate = self;
        [hiddenImageScroller addSubview:hiddenWebView];
        
        hiddenEvoxTrimmingView = [[UIView alloc]initWithFrame:(CGRectMake(-500, 0, 288, 145))];
        hiddenImageView = [[UIImageView alloc]initWithFrame:(CGRectMake(-41, -25, 370, 195))];
        [hiddenEvoxTrimmingView addSubview:hiddenImageView];
        
        if(isEvox == YES)
            [hiddenWebView loadHTMLString:currentCar.CarHTML baseURL:nil];
    }
    else
    {
        isEvox = NO;
        //Load Normal Image
        [hiddenWebView setAlpha:0];
        [self.CellImageView setAlpha:1];
        
        NSURL *imageURL;
        if([currentCar.CarImageURL containsString:@"carno"])
            imageURL = [NSURL URLWithString:currentCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
        else
            imageURL = [NSURL URLWithString:currentCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];
        
        double zoomScale = [currentCar.ZoomScale doubleValue];
        double offSetX = [currentCar.OffsetX doubleValue];
        double offSetY = [currentCar.OffsetY doubleValue];
        
        imageScroller2.delegate = self;
        
        self.CellImageView.contentMode = UIViewContentModeScaleAspectFit;
        NSLog(@"Model: %@ , zoomscale: %f", currentCar, zoomScale);
        if(zoomScale != 0)
        {
            imageScroller2.maximumZoomScale = zoomScale;
            imageScroller2.minimumZoomScale = zoomScale;
            imageScroller2.zoomScale = zoomScale;
        }
        [imageScroller2 setContentOffset:CGPointMake(offSetX/(320/imageScroller2.frame.size.width), offSetY/(320/imageScroller2.frame.size.width))];
        [imageScroller2 setScrollEnabled:NO];
        
        __weak HomepageCell *self2 = self;
        
        [self.CellImageView setImageWithURL:imageURL
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                 [self2.CellImageView setAlpha:0.0];
                                 [UIImageView animateWithDuration:.5 animations:^{
                                     [self2.CellImageView setAlpha:1.0];
                                 }];
                             }
           usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(hasCalled == YES || isEvox == NO)
        return;
    
    hasCalled = YES;
    
    NSLog(@"Webview finished loading");
    
    hiddenImageScroller.maximumZoomScale = 1.1;
    hiddenImageScroller.minimumZoomScale = 1.1;
    hiddenImageScroller.zoomScale = 1.1;
    [hiddenImageScroller setContentOffset:CGPointMake(60, 20)];
    
    [self.hiddenWebView setAlpha:1.0];
    //allow time for webview to load and then trim and convert the html file to the imageview
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self imageFromWebView:self.hiddenWebView];
    });
}

- (UIImage *) imageFromWebView:(UIWebView *)view
{
    // do image magic
    UIGraphicsBeginImageContextWithOptions(hiddenWebView.bounds.size, NO, 0.0);
    [hiddenWebView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [hiddenImageView setImage:image];
    [hiddenImageView setAlpha:1.0];
    [hiddenWebView setAlpha:0.0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        //First Evox Cut
        CGSize size = hiddenImageView.bounds.size;
        CGRect rect = CGRectMake(size.width / 9, size.height / 1.2 ,
                                 (size.width / .5), (size.height / .6));
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
        UIImage *img = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        [hiddenImageView setFrame:CGRectMake(0, 0, 288, 145)];
        [hiddenImageView setImage:img];
        
        //Second Evox Cut
        size = hiddenImageView.bounds.size;
        rect = CGRectMake(size.width / 9, size.height / 1.2 ,
                          (size.width / .5), (size.height / .6));
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
        img = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        NSLog(@"img: %@", img);
        
        [hiddenImageView setFrame:CGRectMake(0, 0, 288, 145)];
        [hiddenImageView setImage:img];
        
        hiddenImageView.layer.borderWidth = 1.0;
        hiddenImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        if(isEvox == NO)
            return;
        
        //Create Final Evox ImageView
        CGSize newSize = self.CellImageView.bounds.size;
        UIGraphicsBeginImageContextWithOptions(newSize, YES, [UIScreen mainScreen].scale);
        [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [activityIndicator stopAnimating];
        
        [[SDImageCache sharedImageCache] storeImage:newImage forKey:cellModel.CarFullName];
        
        [self.CellImageView setImage:newImage];
        [self.CellImageView setAlpha:0.0];
        [UIImageView animateWithDuration:.5 animations:^{
            [self.CellImageView setAlpha:1.0];
        }];
        self.CellImageView.layer.borderWidth = 2.0;
        self.CellImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    });
    
    return image;
}

-(void)startLoadingWheelWithCenter:(CGPoint)center
{
    activityIndicator = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = center;
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.color = [UIColor blackColor];
    [self.cardView addSubview:activityIndicator];
    [activityIndicator startAnimating];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
