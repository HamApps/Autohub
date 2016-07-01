//
//  ViewController.m
//  Carhub
//
//  Created by Christoper Clark on 2/12/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize scroller, imageView, playerView, textView, currentnews, titleLabel, initialImageFrame, dateLabel, authorLabel, whiteView, playerViewContainer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    if([currentnews.NewsVideoID isEqualToString:@""])
        initialImageFrame = imageView.frame;
    else
        initialImageFrame = playerViewContainer.frame;

    
    [self setUpImageOrVideo];
    [self setUpDateTitleAndAuthor];
    [self setUpTextView];
    [self setUpScrollView];
}
-(void)setUpDateTitleAndAuthor
{
    [self setFonts];
    dateLabel.text = currentnews.NewsDate;
    
    titleLabel.text = currentnews.NewsTitle;
    
    //Resize Label to size of Title
    CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width-10, MAXFLOAT);
    CGSize expectedSize = [titleLabel sizeThatFits:maximumLabelSize];
    [titleLabel setFrame:CGRectMake(5, titleLabel.frame.origin.y, self.view.frame.size.width-10, ceilf(expectedSize.height+12))];
    
    if([currentnews.NewsVideoID isEqualToString:@""])
        [authorLabel setFrame:CGRectMake(5, imageView.frame.size.height + dateLabel.frame.size.height + titleLabel.frame.size.height-1, self.view.frame.size.width-10, authorLabel.frame.size.height)];
    else
        [authorLabel setFrame:CGRectMake(5, playerViewContainer.frame.size.height + dateLabel.frame.size.height + titleLabel.frame.size.height-1, self.view.frame.size.width-10, authorLabel.frame.size.height)];
    [authorLabel setText:currentnews.NewsAuthor];
    [whiteView setFrame:CGRectMake(0, whiteView.frame.origin.y, self.view.frame.size.width, dateLabel.frame.size.height + titleLabel.frame.size.height + authorLabel.frame.size.height)];
}

-(void)setFonts
{
    dateLabel.font = [UIFont fontWithName:@"MavenProRegular" size:14];
    [dateLabel setTextColor:[UIColor grayColor]];
    authorLabel.font = [UIFont fontWithName:@"MavenProRegular" size:15];
    [authorLabel setTextColor:[UIColor grayColor]];
    titleLabel.font = [UIFont fontWithName:@"MavenProBold" size:19];
}

-(void)setUpTextView
{
    textView.text = currentnews.NewsArticle;
    textView.font = [UIFont fontWithName:@"MavenProRegular" size:16];
    
    if(![currentnews.NewsImageURL1  isEqual: @""])
        [self setUpArticleImage:currentnews.NewsImageURL1];
    if(![currentnews.NewsImageURL2  isEqual: @""])
        [self setUpArticleImage:currentnews.NewsImageURL2];
    if(![currentnews.NewsImageURL3  isEqual: @""])
        [self setUpArticleImage:currentnews.NewsImageURL3];
    if(![currentnews.NewsImageURL4  isEqual: @""])
        [self setUpArticleImage:currentnews.NewsImageURL4];
    if(![currentnews.NewsImageURL5  isEqual: @""])
        [self setUpArticleImage:currentnews.NewsImageURL5];
    
    if([currentnews.NewsVideoID isEqualToString:@""])
        [textView setFrame:CGRectMake(0, imageView.frame.size.height + dateLabel.frame.size.height + titleLabel.frame.size.height + authorLabel.frame.size.height-1, self.view.frame.size.width, 0)];
    else
        [textView setFrame:CGRectMake(0, playerViewContainer.frame.size.height + dateLabel.frame.size.height + titleLabel.frame.size.height + authorLabel.frame.size.height-1, self.view.frame.size.width, 0)];
    
    [textView sizeToFit];
    [textView layoutIfNeeded];
}

-(void)setUpArticleImage:(NSString *)imageURL
{
    double finalImageWidth = 0;
    NSString *imagePositionString = 0;
    double imageYPosition = 0;
    
    if(imageURL == currentnews.NewsImageURL1)
    {
        finalImageWidth = [currentnews.NewsImage1Width doubleValue];
        imagePositionString = currentnews.NewsImage1Position;
        imageYPosition = [currentnews.NewsImage1YPosition doubleValue];
    }
    if(imageURL == currentnews.NewsImageURL2)
    {
        finalImageWidth = [currentnews.NewsImage2Width doubleValue];
        imagePositionString = currentnews.NewsImage2Position;
        imageYPosition = [currentnews.NewsImage2YPosition doubleValue];
    }
    if(imageURL == currentnews.NewsImageURL3)
    {
        finalImageWidth = [currentnews.NewsImage3Width doubleValue];
        imagePositionString = currentnews.NewsImage3Position;
        imageYPosition = [currentnews.NewsImage3YPosition doubleValue];
    }
    if(imageURL == currentnews.NewsImageURL4)
    {
        finalImageWidth = [currentnews.NewsImage4Width doubleValue];
        imagePositionString = currentnews.NewsImage4Position;
        imageYPosition = [currentnews.NewsImage4YPosition doubleValue];
    }
    if(imageURL == currentnews.NewsImageURL5)
    {
        finalImageWidth = [currentnews.NewsImage5Width doubleValue];
        imagePositionString = currentnews.NewsImage5Position;
        imageYPosition = [currentnews.NewsImage5YPosition doubleValue];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imagedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:[@"http://pl0x.net/OtherPictures/" stringByAppendingString:imageURL]]];
        UIImage *image = [[UIImage alloc]initWithData:imagedata scale:1.0];
        NSLog(@"image: %@", image);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            int height = image.size.height/(image.size.width/finalImageWidth);
            
            //set location
            UIImageView *imageView1 = [[UIImageView alloc]init];
            
            double xOrigin = 0;
            if([imagePositionString isEqualToString:@"right"])
                xOrigin = 0;
            if([imagePositionString isEqualToString:@"left"])
                xOrigin = self.view.frame.size.width - finalImageWidth;
            if([imagePositionString isEqualToString:@"center"])
                xOrigin = (self.view.frame.size.width - finalImageWidth)/2;
            
            imageView1.frame = CGRectMake(xOrigin, imageYPosition, finalImageWidth, height);
            
            [imageView1 setImage:[self resizeImage:image newSize:CGSizeMake(finalImageWidth, height)]];
            [imageView1 setAlpha:0.0];
            [UIImageView animateWithDuration:1.0 animations:^{
                [imageView1 setAlpha:1.0];
            }];
            
            [textView addSubview:imageView1];
            CGRect paddedRect = CGRectMake(imageView1.frame.origin.x, imageView1.frame.origin.y - 10, imageView1.frame.size.width, imageView1.frame.size.height + 20);
            UIBezierPath *imgRect = [UIBezierPath bezierPathWithRect:paddedRect];

            NSMutableArray *exclusionPaths = [[NSMutableArray alloc]initWithArray:self.textView.textContainer.exclusionPaths];
            [exclusionPaths addObject:imgRect];
            NSLog(@"exclusionpaths: %@", exclusionPaths);
            self.textView.textContainer.exclusionPaths = exclusionPaths;
            [textView sizeToFit];
            [textView layoutIfNeeded];
            [self setUpScrollView];
        });
    });
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)setUpScrollView
{
    [scroller setDelegate:self];
    [scroller setScrollEnabled:YES];
    if([currentnews.NewsVideoID isEqualToString:@""])
        [scroller setContentSize:CGSizeMake(self.view.frame.size.width, dateLabel.frame.size.height + authorLabel.frame.size.height + textView.frame.size.height + titleLabel.frame.size.height + imageView.frame.size.height)];
    else
        [scroller setContentSize:CGSizeMake(self.view.frame.size.width, dateLabel.frame.size.height + authorLabel.frame.size.height + textView.frame.size.height + titleLabel.frame.size.height + playerViewContainer.frame.size.height)];
}

-(void)setUpImageOrVideo
{
    NSURL *imageURL;
    if([currentnews.NewsImageURL containsString:@"newsno"])
        imageURL = [NSURL URLWithString:currentnews.NewsImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/newsimage.php"]];
    else
        imageURL = [NSURL URLWithString:currentnews.NewsImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
    
    [imageView setImageWithURL:imageURL
                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                         [imageView setAlpha:0.0];
                         [UIImageView animateWithDuration:0.5 animations:^{
                             [imageView setAlpha:1.0];
                         }];
                     }
   usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [self.playerView loadWithVideoId:currentnews.NewsVideoID];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"didscroll");
    CGPoint currentPosition = scrollView.contentOffset;
    if(currentPosition.y <= 0)
    {
        if([currentnews.NewsVideoID isEqualToString:@""])
            [imageView setFrame:CGRectMake(0, initialImageFrame.origin.y - currentPosition.y, initialImageFrame.size.width, initialImageFrame.size.height)];
        else
            [playerViewContainer setFrame:CGRectMake(0, initialImageFrame.origin.y - currentPosition.y, initialImageFrame.size.width, initialImageFrame.size.height)];
    }
    if(currentPosition.y > 0)
    {
        if([currentnews.NewsVideoID isEqualToString:@""])
            [imageView setFrame:CGRectMake(0, initialImageFrame.origin.y - currentPosition.y/2, initialImageFrame.size.width, initialImageFrame.size.height)];
        else
            [playerViewContainer setFrame:CGRectMake(0, initialImageFrame.origin.y - currentPosition.y/2, initialImageFrame.size.width, initialImageFrame.size.height)];
    }
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
