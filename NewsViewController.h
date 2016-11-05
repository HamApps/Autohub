//
//  NewsViewController.h
//  Carhub
//
//  Created by Christoper Clark on 12/30/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "NewsCell.h"
#import "HeadlineCell.h"

@interface NewsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray * newsArray;

@property (weak, nonatomic) IBOutlet UITableView *TableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@property (nonatomic, strong) News *selectedNews;
@property (nonatomic, strong) NewsCell *selectedCell;
@property (nonatomic, strong) HeadlineCell *selectedHeadlineCell;
@property (nonatomic, strong) HeadlineCell *headlineCell;

//Refresh Control Stuff
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIView *refreshLoadingView;
@property (nonatomic, strong) UIView *refreshColorView;
@property (nonatomic, strong) UIImageView *compass_background;
@property (nonatomic, strong) UIImageView *compass_spinner;
@property (assign) BOOL isRefreshIconsOverlap;
@property (assign) BOOL isRefreshAnimating;
@property (assign) BOOL shouldKeepSpinning;
@property CGRect initialHeadlineFrame;

@end
