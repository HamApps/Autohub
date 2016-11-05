//
//  ModelViewController.h
//  Carhub
//
//  Created by Christopher Clark on 8/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "Make.h"
#import "MakeViewController.h"
#import "CarViewCell.h"
#import "DetailViewController.h"

@interface ModelViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * appdelmodelArray;
@property (nonatomic, strong) NSArray * ModelArray;
@property (nonatomic, strong) NSArray * AlphabeticalArray;
@property (nonatomic, strong) Make * currentMake;
@property (nonatomic, strong) Model * pushingObject;
@property (nonatomic, strong) Model * currentClass;
@property (nonatomic, strong) Model * currentSubclass;
@property (nonatomic, strong) Model * currentStyle;

@property (nonatomic, strong) NSIndexPath *sendingIndex;
@property (nonatomic, strong) CarViewCell *cellToSlide;
@property (nonatomic, strong) CarViewCell *detailCell;
@property (nonatomic, strong) UIScrollView *detailImageScroller;
@property (nonatomic, assign) DetailViewController *detailView;
@property CGRect initialCellFrame;
@property CGRect initialScrollerFrame;
@property NSString* titleString;

@property (nonatomic) BOOL isFromMakes;
@property (nonatomic) BOOL isFromModels;
@property BOOL shouldRefreshImage;
@property int yCenter;
@property int yCenterModel;

@property (nonatomic, strong) IBOutlet UIView *upperView;
@property (nonatomic, strong) NSArray * searchArray;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic) BOOL searchBarActive;

- (void)getMake:(Make *)makeObject;
- (void)getClass:(Model *)classObject sender:(id)sender;
- (void)getSubclass:(Model *)subclassObject sender:(id)sender;
- (void)getStyle:(Model *)styleObject sender:(id)sender;
- (void)revertToModelsPage;

@end
