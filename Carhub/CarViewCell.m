//
//  CarViewCell.m
//  Carhub
//
//  Created by Christopher Clark on 7/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "CarViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "SDImageCache.h"

@implementation CarViewCell

@synthesize hiddenWebView, hiddenImageView, hiddenImageScroller, hiddenEvoxTrimmingView, activityIndicator, imageScroller2, hasCalled, isEvox, cellModel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

-(void)layoutSubviews
{
    [self cardSetup];
    hasCalled = NO;
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
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cardView.bounds.origin.y+35, self.cardView.bounds.size.width, 1.5)];
    lineView.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
    lineView.clipsToBounds = YES;
    [self.cardView addSubview:lineView];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if(![cellModel.CarHTML isEqualToString:@""])
        return hiddenWebView;
    else
        return self.CarImage;
}

-(void)setUpCarImageWithModel:(Model *)currentCar
{
    cellModel = currentCar;
    imageScroller2.maximumZoomScale = 1.0;
    imageScroller2.minimumZoomScale = 1.0;
    imageScroller2.zoomScale = 1.0;
    [imageScroller2 setContentOffset:CGPointMake(0, 0)];
    
    if(![cellModel.CarHTML isEqualToString:@""])
    {
        [self.CarImage setAlpha:0.0];
        isEvox = YES;
        self.CarImage.contentMode = UIViewContentModeScaleAspectFill;
        if([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cellModel.CarFullName] != NULL)
        {
            [self.CarImage setAlpha:1.0];
            [self.CarImage setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cellModel.CarFullName]];
            self.CarImage.layer.borderWidth = 2.0;
            self.CarImage.layer.borderColor = [UIColor whiteColor].CGColor;
            return;
        }
        
        //Load Evox Image
        [self.CarImage setAlpha:0.0];
        [self startLoadingWheelWithCenter:self.CarImage.center];
        
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
        
        double zoomScale = [cellModel.ZoomScale doubleValue];
        double offSetX = [cellModel.OffsetX doubleValue];
        double offSetY = [cellModel.OffsetY doubleValue];
        
        imageScroller2.delegate = self;
        
        self.CarImage.contentMode = UIViewContentModeScaleAspectFit;
        NSLog(@"Model: %@ , zoomscale: %f", currentCar, zoomScale);
        if(zoomScale != 0)
        {
            imageScroller2.maximumZoomScale = zoomScale;
            imageScroller2.minimumZoomScale = zoomScale;
            imageScroller2.zoomScale = zoomScale;
        }
        [imageScroller2 setContentOffset:CGPointMake(offSetX/(320/imageScroller2.frame.size.width), offSetY/(320/imageScroller2.frame.size.width))];
        [imageScroller2 setScrollEnabled:NO];
        
        __weak CarViewCell *self2 = self;
        
        if(isEvox == NO)
            [self2.CarImage setImageWithURL:imageURL
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                              [self2.CarImage setAlpha:0.0];
                              [UIImageView animateWithDuration:.5 animations:^{
                                  if(isEvox == NO)
                                      [self2.CarImage setAlpha:1.0];
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
        CGSize newSize = self.CarImage.bounds.size;
        UIGraphicsBeginImageContextWithOptions(newSize, YES, [UIScreen mainScreen].scale);
        [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [activityIndicator stopAnimating];
        
        [[SDImageCache sharedImageCache] storeImage:newImage forKey:cellModel.CarFullName];
        
        if(isEvox == YES)
        {
            [self.CarImage setImage:newImage];
            [self.CarImage setAlpha:0.0];
            [UIImageView animateWithDuration:.5 animations:^{
                [self.CarImage setAlpha:1.0];
            }];
            self.CarImage.layer.borderWidth = 2.0;
            self.CarImage.layer.borderColor = [UIColor whiteColor].CGColor;
        }
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

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
