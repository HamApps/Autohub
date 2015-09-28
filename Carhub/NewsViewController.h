//
//  NewsViewController.h
//  Carhub
//
//  Created by Christopher Clark on 8/22/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface NewsViewController : UITableViewController<UIWebViewDelegate>

@property (nonatomic, strong) NSMutableArray * newsArray;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@end
