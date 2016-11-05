//
//  FavCell.m
//  Carhub
//
//  Created by Christopher Clark on 8/19/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "FavCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "SDImageCache.h"

@implementation FavCell
@synthesize hiddenWebView, hiddenImageView, hiddenImageScroller, hiddenEvoxTrimmingView, activityIndicator, imageScroller2, hasCalled, isEvox, cellModel, lineView, evoxImageView, normalImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    [self cardSetup];
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self cardSetup];
    [self lineViewSetUp];
    [self sendSubviewToBack:self.contentView];
    hasCalled = NO;
}

-(void)prepareForReuse
{
    NSLog(@"prepareforreuse");
    [normalImageView setAlpha:0];
    [evoxImageView setAlpha:0];
    
    [self.normalImageView sd_cancelCurrentImageLoad];
    [self.activityIndicator stopAnimating];
    [hiddenWebView stopLoading];
    
    for(UIView *view in self.cardView.subviews)
    {
        if([view isMemberOfClass:[UIActivityIndicatorView class]])
            [view removeFromSuperview];
    }
}

-(void)cardSetup
{
    [self.cardView setAlpha:1];
    self.cardView.layer.masksToBounds = NO;
    self.cardView.layer.cornerRadius = 10;
    self.cardView.layer.shadowOffset = CGSizeMake(-.2f, .2f);
    self.cardView.layer.shadowRadius = 1.5;
    self.cardView.layer.shadowOpacity = .5;
    self.backgroundColor = [UIColor whiteColor];
}

-(void)lineViewSetUp
{
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cardView.bounds.origin.y+35, self.cardView.bounds.size.width, 1.5)];
    lineView.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
    lineView.clipsToBounds = YES;
    [self.cardView addSubview:lineView];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if(![cellModel.CarHTML isEqualToString:@""])
        return hiddenWebView;
    else
        return self.normalImageView;
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

-(void)setUpCarImageWithModel:(Model *)currentCar
{
    cellModel = currentCar;
    
    if(![cellModel.CarHTML isEqualToString:@""])
    {
        isEvox = YES;
        evoxImageView.contentMode = UIViewContentModeScaleAspectFill;
        if([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cellModel.CarHTML] != NULL)
        {
            if(evoxImageView.alpha == 0)
                [evoxImageView setAlpha:1.0];
            [evoxImageView setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cellModel.CarHTML]];
            return;
        }
        
        //Load Evox Image
        [normalImageView setAlpha:0.0];
        [self startLoadingWheelWithCenter:self.imageScroller2.center];
        
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
            [hiddenWebView loadHTMLString:cellModel.CarHTML baseURL:nil];
    }
    else
    {
        isEvox = NO;
        //Load Normal Image
        
        NSURL *imageURL;
        if([cellModel.CarImageURL containsString:@"carno"])
            imageURL = [NSURL URLWithString:cellModel.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
        else
            imageURL = [NSURL URLWithString:cellModel.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];
        
        imageScroller2.delegate = self;
        normalImageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageScroller2 setScrollEnabled:NO];
        
        [self startLoadingWheelWithCenter:self.imageScroller2.center];
        
        if(isEvox == NO)
            [normalImageView sd_setImageWithURL:imageURL
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                      [self.activityIndicator stopAnimating];
                                      if(![[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[imageURL absoluteString]])
                                          [normalImageView setAlpha:0.0];
                                      else
                                          [normalImageView setAlpha:1];
                                      [UIImageView animateWithDuration:.5 animations:^{
                                          if(isEvox == NO)
                                              [normalImageView setAlpha:1.0];
                                      }];
                                  }];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(hasCalled == YES || isEvox == NO)
        return;
    
    hasCalled = YES;
    
    hiddenImageScroller.maximumZoomScale = 1.1;
    hiddenImageScroller.minimumZoomScale = 1.1;
    hiddenImageScroller.zoomScale = 1.1;
    [hiddenImageScroller setContentOffset:CGPointMake(60, 20)];
    
    [self.hiddenWebView setAlpha:1.0];
    //allow time for webview to load and then trim and convert the html file to the imageview
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
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
        
        UIImage *finalImage;
        int height = [UIScreen mainScreen].bounds.size.height;
        if (height == 736)
        {
            CGRect rect = CGRectMake(55, 200, 850, 374);
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
            finalImage = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            
            CGSize newSize = evoxImageView.frame.size;
            UIGraphicsBeginImageContextWithOptions(newSize, YES, [UIScreen mainScreen].scale);
            [finalImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            finalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        else
        {
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
            rect = CGRectMake(size.width / 8, size.height / 1.2 ,
                              (size.width / .51), (size.height / .585));
            
            imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
            img = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            
            [hiddenImageView setFrame:CGRectMake(0, 0, 300, 132)];
            [hiddenImageView setImage:img];
            
            hiddenImageView.layer.borderWidth = 1.0;
            hiddenImageView.layer.borderColor = [UIColor whiteColor].CGColor;
            
            if(isEvox == NO)
                return;
            
            //Create Final Evox ImageView
            CGSize newSize = evoxImageView.bounds.size;
            UIGraphicsBeginImageContextWithOptions(newSize, YES, [UIScreen mainScreen].scale);
            [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            finalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        [activityIndicator stopAnimating];
        
        finalImage = [self changeWhiteColorTransparent:finalImage];
        if([cellModel.ShouldFlipEvox isEqualToString:@"1"])
            finalImage = [UIImage imageWithCGImage:finalImage.CGImage scale:finalImage.scale orientation:UIImageOrientationUpMirrored];
        [[SDImageCache sharedImageCache] storeImage:finalImage forKey:cellModel.CarHTML];
        
        [evoxImageView setImage:finalImage];
        [evoxImageView setAlpha:0.0];
        [UIImageView animateWithDuration:.5 animations:^{
            [evoxImageView setAlpha:1.0];
        }];
    });
    
    return image;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
