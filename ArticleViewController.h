//
//  ArticleViewController.h
//  Carhub
//
//  Created by Christoper Clark on 6/18/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end
