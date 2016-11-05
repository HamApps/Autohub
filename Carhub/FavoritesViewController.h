//
//  FavoritesViewController.h
//  Carhub
//
//  Created by Christopher Clark on 8/23/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "DetailViewController.h"
#import "FavCell.h"

@interface FavoritesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * ModelArray;

@property (nonatomic, strong) Model * objectToSend;
@property (nonatomic, strong) NSIndexPath *sendingIndex;
@property (nonatomic, strong) FavCell *detailCell;
@property (nonatomic, strong) UIScrollView *detailImageScroller;
@property (nonatomic, assign) DetailViewController *detailView;
@property CGRect initialCellFrame;
@property CGRect initialScrollerFrame;
@property NSString* titleString;
@property int yCenter;
@property int yCenterModel;

@property (nonatomic, strong) IBOutlet UIView *upperView;
@property (nonatomic, strong) NSArray * searchArray;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic) BOOL searchBarActive;

- (void)loadSavedCars;

@end
