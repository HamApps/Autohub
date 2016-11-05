//
//  MakeViewController.h
//  Carhub
//
//  Created by Christopher Clark on 8/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Make.h"
#import "Model.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "MakeCell.h"

@interface MakeViewController : UICollectionViewController<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@property (nonatomic, strong) NSMutableArray * makeimageArray;
@property (nonatomic, strong) NSMutableArray * searchmakeimageArray;
@property (nonatomic, strong) NSMutableArray * modelArray;
@property (nonatomic, strong) Make * currentMake;

@property (nonatomic, strong) MakeCell *selectedCell;

@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic) BOOL searchBarActive;
@property (nonatomic) float searchBarBoundsY;

@property BOOL shouldHaveBackButton;

@end