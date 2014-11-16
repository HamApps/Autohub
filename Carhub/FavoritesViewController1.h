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
#import "FavoritesClass.h"

@interface FavoritesViewController1 : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel * TestLabel;
@property(nonatomic, strong) Model * FavoriteCar;
@property(nonatomic, strong) NSMutableArray * favoritesarray;
@property(nonatomic, strong) NSMutableArray * defaultsarray;

- (void)loadcars;

@end