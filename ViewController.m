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
#import "ImageViewController.h"
#import <Google/Analytics.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize scroller, imageView, playerView, textView, currentnews, titleLabel, initialImageFrame, dateLabel, authorLabel, whiteView, playerViewContainer, image1URL, image2URL, image3URL, image4URL, image5URL, activityIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    playerView.delegate = self;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    if([currentnews.NewsVideoID isEqualToString:@""])
    {
        initialImageFrame = imageView.frame;
        self.title = @"Article";
    }
    else
    {
        initialImageFrame = playerViewContainer.frame;
        self.title = @"Video";
        
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.hidesWhenStopped = YES;
        activityIndicator.color = [UIColor blackColor];
        activityIndicator.center = playerViewContainer.center;
        [self.scroller addSubview:activityIndicator];
        [activityIndicator startAnimating];
    }
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:currentnews.NewsTitle];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [self setUpImageOrVideo];
    [self setUpDateTitleAndAuthor];
    [self setUpTextView];
    [self setUpScrollView];
    [textView becomeFirstResponder];
    [textView resignFirstResponder];
}

-(void)setUpDateTitleAndAuthor
{
    [self setFonts];
    dateLabel.text = currentnews.NewsDate;
    
    titleLabel.text = currentnews.NewsTitle;
    
    //Resize Label to size of Title
    CGSize maximumLabelSize = CGSizeMake(titleLabel.frame.size.width, MAXFLOAT);
    CGSize expectedSize = [titleLabel sizeThatFits:maximumLabelSize];
    [titleLabel setFrame:CGRectMake(10, titleLabel.frame.origin.y, titleLabel.frame.size.width, ceilf(expectedSize.height))];
    
    [authorLabel setFrame:CGRectMake(10, dateLabel.frame.size.height + titleLabel.frame.size.height+7, authorLabel.frame.size.width, authorLabel.frame.size.height)];
    [authorLabel setText:currentnews.NewsAuthor];
    [whiteView setFrame:CGRectMake(0, whiteView.frame.origin.y, self.view.frame.size.width, dateLabel.frame.size.height + titleLabel.frame.size.height + authorLabel.frame.size.height + 10)];
}

-(void)setFonts
{
    [dateLabel setTextColor:[UIColor grayColor]];
    [authorLabel setTextColor:[UIColor grayColor]];
}

-(void)setUpTextView
{
    textView.text = currentnews.NewsArticle;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:self.textView.text];
    NSArray *tagArray = [[NSArray alloc]initWithObjects:@"<img1>", @"<img2>", @"<img3>", @"<img4>", @"<img5>", nil];
    for(int i=0; i<tagArray.count; i++)
    {
        NSString *string = [tagArray objectAtIndex:i];
        NSRange range = [self.textView.text rangeOfString:string];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1] range:range];
        [self.textView setAttributedText:text];
    }

    textView.font = [UIFont fontWithName:@"MavenProRegular" size:15];
    
    image1URL = [NSURL URLWithString:[@"http://pl0x.net/OtherPictures/" stringByAppendingString:currentnews.NewsImageURL1]];
    image2URL = [NSURL URLWithString:[@"http://pl0x.net/OtherPictures/" stringByAppendingString:currentnews.NewsImageURL2]];
    image3URL = [NSURL URLWithString:[@"http://pl0x.net/OtherPictures/" stringByAppendingString:currentnews.NewsImageURL3]];
    image4URL = [NSURL URLWithString:[@"http://pl0x.net/OtherPictures/" stringByAppendingString:currentnews.NewsImageURL4]];
    image5URL = [NSURL URLWithString:[@"http://pl0x.net/OtherPictures/" stringByAppendingString:currentnews.NewsImageURL5]];
    
    if([currentnews.NewsVideoID isEqualToString:@""])
        [textView setFrame:CGRectMake(textView.frame.origin.x, imageView.frame.size.height + whiteView.frame.size.height-1, textView.frame.size.width, 0)];
    else
        [textView setFrame:CGRectMake(textView.frame.origin.x, playerViewContainer.frame.size.height + whiteView.frame.size.height-1, textView.frame.size.width, 0)];
    
    [textView sizeToFit];
    [textView layoutIfNeeded];
    [textView setBackgroundColor:[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1]];
    [self.view setBackgroundColor:[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1]];
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0, .5, self.view.frame.size.width, 0.5f);
    topBorder.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
    [textView.layer addSublayer:topBorder];
    textView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        [self setUpArticleImage:image1URL];
    });
}

-(void)setUpArticleImage:(NSURL *)imageURL
{
    if([[imageURL absoluteString] isEqualToString:@"http://pl0x.net/OtherPictures/"])
        return;
    UIImageView *imageView1 = [[UIImageView alloc]init];
    
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:[imageURL absoluteString]]
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSString *imageCaption;
                        double yPosition = 0;
                        NSRange textRange;
                        NSRange searchRange = NSMakeRange(0, [textView.text length]);
                        NSURL *nextURL;
                        
                        [imageView1 setUserInteractionEnabled:YES];
                        
                        if(imageURL == image1URL)
                        {
                            imageCaption = currentnews.NewsImage1Caption;
                            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tappedImage1:)];
                            [imageView1 addGestureRecognizer: tap];
                            textRange = [textView.text rangeOfString:@"<img1>" options:NSCaseInsensitiveSearch range:searchRange];
                            yPosition = [self frameOfTextRange:textRange inTextView:textView].origin.y;
                            nextURL = image2URL;
                        }
                        if(imageURL == image2URL)
                        {
                            imageCaption = currentnews.NewsImage2Caption;
                            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tappedImage2:)];
                            [imageView1 addGestureRecognizer: tap];
                            textRange = [textView.text rangeOfString:@"<img2>" options:NSCaseInsensitiveSearch range:searchRange];
                            yPosition = [self frameOfTextRange:textRange inTextView:textView].origin.y;
                            nextURL = image3URL;
                        }
                        if(imageURL == image3URL)
                        {
                            imageCaption = currentnews.NewsImage3Caption;
                            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tappedImage3:)];
                            [imageView1 addGestureRecognizer: tap];
                            textRange = [textView.text rangeOfString:@"<img3>" options:NSCaseInsensitiveSearch range:searchRange];
                            yPosition = [self frameOfTextRange:textRange inTextView:textView].origin.y;
                            nextURL = image4URL;
                        }
                        if(imageURL == image4URL)
                        {
                            imageCaption = currentnews.NewsImage4Caption;
                            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tappedImage4:)];
                            [imageView1 addGestureRecognizer: tap];
                            textRange = [textView.text rangeOfString:@"<img4>" options:NSCaseInsensitiveSearch range:searchRange];
                            yPosition = [self frameOfTextRange:textRange inTextView:textView].origin.y;
                            nextURL = image5URL;
                        }
                        if(imageURL == image5URL)
                        {
                            imageCaption = currentnews.NewsImage5Caption;
                            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tappedImage5:)];
                            [imageView1 addGestureRecognizer: tap];
                            textRange = [textView.text rangeOfString:@"<img5>" options:NSCaseInsensitiveSearch range:searchRange];
                            yPosition = [self frameOfTextRange:textRange inTextView:textView].origin.y;
                        }
                        
                        
                        UITextPosition *beginning = textView.beginningOfDocument;
                        UITextPosition *start = [textView positionFromPosition:beginning offset:textRange.location];
                        UITextPosition *end = [textView positionFromPosition:start offset:textRange.length];
                        UITextRange *textRange2 = [textView textRangeFromPosition:start toPosition:end];
                        
                        int height = image.size.height/(image.size.width/textView.frame.size.width);
                        
                        UILabel *captionLabel = [[UILabel alloc]init];
                        captionLabel.text = imageCaption;
                        captionLabel.font = [UIFont fontWithName:@"MavenProRegular" size:14];
                        captionLabel.textColor = [UIColor grayColor];
                        captionLabel.numberOfLines = 0;
                        
                        CGSize maximumLabelSize = CGSizeMake(textView.frame.size.width-20, MAXFLOAT);
                        CGSize expectedSize = [captionLabel sizeThatFits:maximumLabelSize];
                        [captionLabel setFrame:CGRectMake(10, height + yPosition, textView.frame.size.width-20, ceilf(expectedSize.height))];
                        
                        [textView replaceRange:textRange2 withText:@""];
                        imageView1.frame = CGRectMake(10, yPosition-5, textView.frame.size.width-20, height);
                        
                        [textView addSubview:imageView1];
                        [textView addSubview:captionLabel];
                        CGRect paddedRect = CGRectMake(imageView1.frame.origin.x, imageView1.frame.origin.y, imageView1.frame.size.width, imageView1.frame.size.height + captionLabel.frame.size.height - 45);
                        UIBezierPath *imgRect = [UIBezierPath bezierPathWithRect:paddedRect];
                        
                        [imageView1 setImage:[self resizeImage:imageView1.image newSize:imageView1.frame.size]];
                        [imageView1 setAlpha:0.0];
                        [UIImageView animateWithDuration:1.0 animations:^{
                            [imageView1 setAlpha:1.0];
                        }];
                        
                        NSMutableArray *exclusionPaths = [[NSMutableArray alloc]initWithArray:self.textView.textContainer.exclusionPaths];
                        [exclusionPaths addObject:imgRect];
                        self.textView.textContainer.exclusionPaths = exclusionPaths;
                        [textView sizeToFit];
                        [textView layoutIfNeeded];
                        [self setUpScrollView];
                        if(nextURL != NULL)
                            [self setUpArticleImage:nextURL];
                });
            }];
}

- (CGRect)frameOfTextRange:(NSRange)range inTextView:(UITextView *)textView
{
    UITextPosition *beginning = self.textView.beginningOfDocument;
    UITextPosition *start = [self.textView positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [self.textView positionFromPosition:start offset:range.length];
    UITextRange *textRange = [self.textView textRangeFromPosition:start toPosition:end];
    CGRect rect = [self.textView firstRectForRange:textRange];
    return [self.textView convertRect:rect fromView:self.textView.textInputView];
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize
{
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
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

- (UIImage*)resizeImage:(UIImage*)aImage reSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [aImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)setUpScrollView
{
    [scroller setDelegate:self];
    [scroller setScrollEnabled:YES];
    if([currentnews.NewsVideoID isEqualToString:@""])
        [scroller setContentSize:CGSizeMake(self.view.frame.size.width, dateLabel.frame.size.height + authorLabel.frame.size.height + textView.frame.size.height + titleLabel.frame.size.height + imageView.frame.size.height + 10)];
    else
        [scroller setContentSize:CGSizeMake(self.view.frame.size.width, dateLabel.frame.size.height + authorLabel.frame.size.height + textView.frame.size.height + titleLabel.frame.size.height + playerViewContainer.frame.size.height + 10)];
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

-(void)playerViewDidBecomeReady:(YTPlayerView *)playerView
{
    NSLog(@"playerready");
    [activityIndicator stopAnimating];
}

-(IBAction)selectVideo:(id)sender
{
    [self.playerView playVideo];
}

-(IBAction)selectImage:(id)sender
{
    [self performSegueWithIdentifier:@"pushArticleImage" sender:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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

-(void)tappedImage1:(UITapGestureRecognizer *) tap
{
    [self performSegueWithIdentifier:@"pushArticleTextImage1" sender:self];
}

-(void)tappedImage2:(UITapGestureRecognizer *) tap
{
    [self performSegueWithIdentifier:@"pushArticleTextImage2" sender:self];
}

-(void)tappedImage3:(UITapGestureRecognizer *) tap
{
    [self performSegueWithIdentifier:@"pushArticleTextImage3" sender:self];
}

-(void)tappedImage4:(UITapGestureRecognizer *) tap
{
    [self performSegueWithIdentifier:@"pushArticleTextImage4" sender:self];
}

-(void)tappedImage5:(UITapGestureRecognizer *) tap
{
    [self performSegueWithIdentifier:@"pushArticleTextImage5" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pushArticleImage"])
    {
        [[segue destinationViewController]getArticleImage:currentnews.NewsImageURL];
    }
    if([segue.identifier isEqualToString:@"pushArticleTextImage1"])
    {
        [[segue destinationViewController]getArticleImage:currentnews.NewsImageURL1];
    }
    if([segue.identifier isEqualToString:@"pushArticleTextImage2"])
    {
        [[segue destinationViewController]getArticleImage:currentnews.NewsImageURL2];
    }
    if([segue.identifier isEqualToString:@"pushArticleTextImage3"])
    {
        [[segue destinationViewController]getArticleImage:currentnews.NewsImageURL3];
    }
    if([segue.identifier isEqualToString:@"pushArticleTextImage4"])
    {
        [[segue destinationViewController]getArticleImage:currentnews.NewsImageURL4];
    }
    if([segue.identifier isEqualToString:@"pushArticleTextImage5"])
    {
        [[segue destinationViewController]getArticleImage:currentnews.NewsImageURL5];
    }
}

- (void)getNews:(id)newsObject;
{
    currentnews = newsObject;
}

@end
