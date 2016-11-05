//
//  SpecsToolbarHeader.m
//  Carhub
//
//  Created by Christoper Clark on 7/28/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "SpecsToolbarHeader.h"
#import "Model.h"
#import "UIImageView+WebCache.h"

@implementation SpecsToolbarHeader
@synthesize hiddenImageView, hiddenImageView2, hiddenImageView3, firstImageScroller, detailImageScroller, hiddenImageScroller, secondImageScroller, hiddenImageScroller2, hiddenImageScroller3, hiddenEvoxTrimmingView, hiddenEvoxTrimmingView2, hiddenEvoxTrimmingView3, firstCarNameLabel, hiddenWebView, hiddenWebView2, hiddenWebView3, activityIndicator, activityIndicator1, activityIndicator2, hasCalled1, hasCalled2, hasCalled3, currentCar, firstCar, secondCar, exhaustActivityIndicator1, exhaustButton, exhaustLabel, exhaustActivityIndicator2, saveButton, firstEvoxImageView, detailEvoxImageView, secondEvoxImageView, firstNormalImageView, detailNormalImageView, secondNormalImageView;

-(void)layoutSubviews
{
    hasCalled1 = NO;
    hasCalled2 = NO;
    hasCalled3 = NO;
    
    exhaustActivityIndicator1.transform = CGAffineTransformMakeScale(0.75, 0.75);
    exhaustActivityIndicator2.transform = CGAffineTransformMakeScale(0.75, 0.75);
    
    exhaustActivityIndicator1.hidesWhenStopped = YES;
    exhaustActivityIndicator2.hidesWhenStopped = YES;
}

-(void)startExhaustLoadingWheel
{
    exhaustActivityIndicator1.color = [UIColor blackColor];
    [exhaustActivityIndicator1 startAnimating];
}

-(void)startExhaustLoadingWheel2
{
    exhaustActivityIndicator2.color = [UIColor blackColor];
    [exhaustActivityIndicator2 startAnimating];
}

#pragma Image Loading Methods

-(void)setUpDetailCarImageWithModel:(Model *)currentModel
{
    currentCar = currentModel;
    if(![currentCar.CarHTML isEqualToString:@""])
    {
        [self setDetailCarEvoxImage];
    }
    else
    {
        [self setDetailCarNormalImage];
    }
}

-(void)setCompareImagesWithFirstModel:(Model *)firstModel andSecondModel:(Model *)secondModel
 {
     firstCar = firstModel;
     secondCar = secondModel;
     
     if(![firstCar.CarHTML isEqualToString:@""])
         [self setFirstCarEvoxImage];
     else
         [self setFirstCarNormalImage];
 
     if(![secondCar.CarHTML isEqualToString:@""])
         [self setSecondCarEvoxImage];
     else
         [self setSecondCarNormalImage];
 }

-(void)setDetailCarEvoxImage
{
    if([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:currentCar.CarHTML] != NULL)
    {
        [detailEvoxImageView setAlpha:1.0];
        [detailEvoxImageView setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:currentCar.CarHTML]];
        
        return;
    }
    
    [self startLoadingWheel1WithCenter:detailImageScroller.center];
    
    //Create Evox Trimmers outside of screen's view
    hiddenImageScroller3 = [[UIScrollView alloc]initWithFrame:(CGRectMake(-500, 61, 320, 145))];
    hiddenWebView3 = [[UIWebView alloc]initWithFrame:(CGRectMake(0, 0, 320, 193))];
    hiddenImageScroller3.delegate = self;
    hiddenWebView3.delegate = self;
    [hiddenImageScroller3 addSubview:hiddenWebView3];
    
    hiddenEvoxTrimmingView3 = [[UIView alloc]initWithFrame:(CGRectMake(-500, 0, 288, 145))];
    hiddenImageView3 = [[UIImageView alloc]initWithFrame:(CGRectMake(-41, -25, 370, 195))];
    [hiddenEvoxTrimmingView3 addSubview:hiddenImageView3];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [hiddenWebView3 loadHTMLString:currentCar.CarHTML baseURL:nil];
    });
}

-(void)setDetailCarNormalImage
{
    __weak UIImageView *weakDetailImageView = detailNormalImageView;
    
    NSURL *imageURL;
    if([currentCar.CarImageURL containsString:@"carno"])
        imageURL = [NSURL URLWithString:currentCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
    else
        imageURL = [NSURL URLWithString:currentCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];
    
    detailImageScroller.delegate = self;
    
    detailNormalImageView.contentMode = UIViewContentModeScaleAspectFit;
    [detailImageScroller setScrollEnabled:NO];
    
    if(![[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[imageURL absoluteString]])
        [weakDetailImageView setAlpha:0.0];
    else
        [weakDetailImageView setAlpha:1];
    
    [weakDetailImageView sd_setImageWithURL:imageURL
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                   [UIImageView animateWithDuration:.5 animations:^{
                                       [weakDetailImageView setAlpha:1.0];
                                   }];
                               }];
}

-(void)setFirstCarEvoxImage
{
    if([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:firstCar.CarHTML] != NULL)
    {
        [firstEvoxImageView setAlpha:1.0];
        [firstEvoxImageView setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:firstCar.CarHTML]];
        return;
    }
    
    [self startLoadingWheel1WithCenter:firstImageScroller.center];
    
    //Create Evox Trimmers outside of screen's view
    hiddenImageScroller = [[UIScrollView alloc]initWithFrame:(CGRectMake(-500, 61, 320, 145))];
    hiddenWebView = [[UIWebView alloc]initWithFrame:(CGRectMake(0, 0, 320, 193))];
    hiddenImageScroller.delegate = self;
    hiddenWebView.delegate = self;
    [hiddenImageScroller addSubview:hiddenWebView];
    
    hiddenEvoxTrimmingView = [[UIView alloc]initWithFrame:(CGRectMake(-500, 0, 288, 145))];
    hiddenImageView = [[UIImageView alloc]initWithFrame:(CGRectMake(-41, -25, 370, 195))];
    [hiddenEvoxTrimmingView addSubview:hiddenImageView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [hiddenWebView loadHTMLString:firstCar.CarHTML baseURL:nil];
    });
}

-(void)setFirstCarNormalImage
{
    __weak UIImageView *weakFirstImageView = firstNormalImageView;
    
    NSURL *imageURL;
    if([firstCar.CarImageURL containsString:@"carno"])
        imageURL = [NSURL URLWithString:firstCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
    else
        imageURL = [NSURL URLWithString:firstCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];
    
    firstImageScroller.delegate = self;
    
    firstNormalImageView.contentMode = UIViewContentModeScaleAspectFit;
    [firstImageScroller setScrollEnabled:NO];
    
    [weakFirstImageView sd_setImageWithURL:imageURL
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                      [weakFirstImageView setAlpha:0];
                                      [UIImageView animateWithDuration:.5 animations:^{
                                          [weakFirstImageView setAlpha:1.0];
                                      }];
                                  }];
}

-(void)setSecondCarEvoxImage
{
    if([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:secondCar.CarHTML] != NULL)
    {
        [secondEvoxImageView setAlpha:1.0];
        [secondEvoxImageView setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:secondCar.CarHTML]];
        return;
    }
    
    [self startLoadingWheel2WithCenter:secondImageScroller.center];
    
    //Create Evox Trimmers outside of screen's view
    hiddenImageScroller2 = [[UIScrollView alloc]initWithFrame:(CGRectMake(-500, 61, 320, 145))];
    hiddenWebView2 = [[UIWebView alloc]initWithFrame:(CGRectMake(0, 0, 320, 193))];
    hiddenImageScroller2.delegate = self;
    hiddenWebView2.delegate = self;
    [hiddenImageScroller2 addSubview:hiddenWebView2];
    
    hiddenEvoxTrimmingView2 = [[UIView alloc]initWithFrame:(CGRectMake(-500, 0, 288, 145))];
    hiddenImageView2 = [[UIImageView alloc]initWithFrame:(CGRectMake(-41, -25, 370, 195))];
    [hiddenEvoxTrimmingView2 addSubview:hiddenImageView2];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [hiddenWebView2 loadHTMLString:secondCar.CarHTML baseURL:nil];
    });
}

-(void)setSecondCarNormalImage
{
    __weak UIImageView *weakSecondImageView = secondNormalImageView;
    
    NSURL *imageURL;
    if([secondCar.CarImageURL containsString:@"carno"])
        imageURL = [NSURL URLWithString:secondCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
    else
        imageURL = [NSURL URLWithString:secondCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];
    
    secondImageScroller.delegate = self;
    
    secondNormalImageView.contentMode = UIViewContentModeScaleAspectFit;
    [secondImageScroller setScrollEnabled:NO];
    
    [weakSecondImageView sd_setImageWithURL:imageURL
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                   [weakSecondImageView setAlpha:0];
                                   [UIImageView animateWithDuration:.5 animations:^{
                                       [weakSecondImageView setAlpha:1.0];
                                   }];
                               }];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if(scrollView == hiddenImageScroller)
        return hiddenWebView;
    else if (scrollView == hiddenImageScroller2)
        return hiddenWebView2;
    else if (scrollView == hiddenImageScroller3)
        return hiddenWebView3;
    else if (scrollView == firstImageScroller)
        return firstNormalImageView;
    else if (scrollView == secondImageScroller)
        return secondNormalImageView;
    else if (scrollView == detailImageScroller)
        return detailNormalImageView;
    else
        return hiddenWebView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat top = 0, left = 0;
    if (scrollView.contentSize.width < scrollView.bounds.size.width) {
        left = (scrollView.bounds.size.width-scrollView.contentSize.width) * 0.5f;
    }
    if (scrollView.contentSize.height < scrollView.bounds.size.height) {
        top = (scrollView.bounds.size.height-scrollView.contentSize.height) * 0.5f;
    }
    scrollView.contentInset = UIEdgeInsetsMake(top, left, top, left);
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
    
    if(webView == hiddenWebView3)
    {
        if(hasCalled3 == YES)
            return;
        hasCalled3 = YES;
        webViewScroller = hiddenImageScroller3;
    }
    
    webViewScroller.maximumZoomScale = 1.1;
    webViewScroller.minimumZoomScale = 1.1;
    webViewScroller.zoomScale = 1.1;
    [webViewScroller setContentOffset:CGPointMake(60, 20)];
    
    [webView setAlpha:1.0];
    //allow time for webview to load and then trim and convert the html file to the imageview
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
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
        finalImageView = firstEvoxImageView;
        loadingWheel = activityIndicator1;
    }
    else if(webView == hiddenWebView2)
    {
        imageView = hiddenImageView2;
        finalImageView = secondEvoxImageView;
        loadingWheel = activityIndicator2;
    }
    else if(webView == hiddenWebView3)
    {
        imageView = hiddenImageView3;
        finalImageView = detailEvoxImageView;
        loadingWheel = activityIndicator1;
    }
    
    UIGraphicsBeginImageContextWithOptions(webView.bounds.size, NO, 0.0);
    [webView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageView setImage:image];
    [imageView setAlpha:1.0];
    [webView setAlpha:0.0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIImage *finalImage;
        int height = [UIScreen mainScreen].bounds.size.height;
        if (height == 736)
        {
            CGRect rect = CGRectMake(55, 200, 850, 374);
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
            finalImage = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            
            CGSize newSize = finalImageView.frame.size;
            UIGraphicsBeginImageContextWithOptions(newSize, YES, [UIScreen mainScreen].scale);
            [finalImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            finalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        else
        {
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
            rect = CGRectMake(size.width / 8, size.height / 1.2 ,
                              (size.width / .51), (size.height / .585));
            
            imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
            img = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            
            [imageView setFrame:CGRectMake(0, 0, 300, 132)];
            [imageView setImage:img];
            
            imageView.layer.borderWidth = 1.0;
            imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            
            //Create Final Evox ImageView
            CGSize newSize = imageView.bounds.size;
            UIGraphicsBeginImageContextWithOptions(newSize, YES, [UIScreen mainScreen].scale);
            [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            finalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
            
            Model *modelToSave;
            if(finalImageView == firstEvoxImageView)
                modelToSave = firstCar;
            if(finalImageView == secondEvoxImageView)
                modelToSave = secondCar;
            if(finalImageView == detailEvoxImageView)
                modelToSave = currentCar;
        
            finalImage = [self changeWhiteColorTransparent:finalImage];
            if([modelToSave.ShouldFlipEvox isEqualToString:@"1"])
                finalImage = [UIImage imageWithCGImage:finalImage.CGImage scale:finalImage.scale orientation:UIImageOrientationUpMirrored];
            [[SDImageCache sharedImageCache] storeImage:finalImage forKey:modelToSave.CarHTML];
                    
            [finalImageView setAlpha:0];
            [finalImageView setImage: finalImage];
            [loadingWheel stopAnimating];
            [UIImageView animateWithDuration:.5 animations:^{
                [finalImageView setAlpha:1.0];
            }];
        
    });
    return image;
}

-(void)startLoadingWheel1WithCenter:(CGPoint)center
{
    activityIndicator1 = [[UIActivityIndicatorView alloc]
                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator1.center = center;
    activityIndicator1.hidesWhenStopped = YES;
    activityIndicator1.color = [UIColor blackColor];
    [self addSubview:activityIndicator1];
    [activityIndicator1 startAnimating];
}

-(void)startLoadingWheel2WithCenter:(CGPoint)center
{
    activityIndicator2 = [[UIActivityIndicatorView alloc]
                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator2.center = center;
    activityIndicator2.hidesWhenStopped = YES;
    activityIndicator2.color = [UIColor blackColor];
    [self addSubview:activityIndicator2];
    [activityIndicator2 startAnimating];
}

- (UIImage*)resizeImage:(UIImage*)aImage reSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [aImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)startLoadingWheelWithCenter:(CGPoint)center
{
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = center;
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.color = [UIColor blackColor];
    [self addSubview:activityIndicator];
    [activityIndicator startAnimating];
}

-(UIImage *)changeWhiteColorTransparent: (UIImage *)image
{
    CGImageRef rawImageRef=image.CGImage;
    
    const CGFloat colorMasking[6] = {222, 255, 222, 255, 222, 255};
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    CGImageRef maskedImageRef=CGImageCreateWithMaskingColors(rawImageRef, colorMasking);
    {
        //if in iphone
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0, image.size.height);
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    }
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height), maskedImageRef);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(maskedImageRef);
    UIGraphicsEndImageContext();
    return result;
}

@end
