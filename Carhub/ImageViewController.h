//
//  ImageViewController.h
//  Carhub
//
//  Created by Christopher Clark on 7/27/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface ImageViewController : UIViewController<UIScrollViewDelegate, UIWebViewDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) IBOutlet UIImageView* imageview;
@property(nonatomic, strong) IBOutlet UIWebView *webView;

@property(nonatomic, strong) Model * currentCar;
@property(nonatomic, strong) NSURL * imageURL;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@property(assign) BOOL isNewsImage;

- (void)getModel:(id)modelObject;
- (void)getArticleImage:(id)articleImageURL;

@end
