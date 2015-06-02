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


@interface FavoritesViewController : UITableViewController<UISearchDisplayDelegate>

//@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray * ModelArray;
@property (nonatomic, strong) NSArray * searchArray;
@property (nonatomic, strong) UIBarButtonItem *editButton;

- (void)loadSavedCars;

@end
