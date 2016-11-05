//
//  SearchModelController.h
//  Carhub
//
//  Created by Christopher Clark on 9/8/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "CarViewCell.h"
#import "DetailViewController.h"

@interface SearchModelController : UIViewController<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSArray * ModelArray;
@property (nonatomic, strong) Model * currentModel;

@property (nonatomic, strong) Model * objectToSend;
@property (nonatomic, strong) NSIndexPath *sendingIndex;
@property (nonatomic, strong) CarViewCell *detailCell;
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

- (void)getsearcharray:(id)searcharrayObject;
-(void)revertToSearchModelPage;

@end
