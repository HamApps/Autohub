//
//  SearchModelController.h
//  Carhub
//
//  Created by Christopher Clark on 9/8/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "SearchViewController.h"

@interface SearchModelController : UITableViewController<UISearchDisplayDelegate>

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSArray * ModelArray;
@property (nonatomic, strong) NSArray * searchArray;

- (void)getsearcharray:(id)searcharrayObject;

@property (nonatomic, strong) Model * currentModel;

@end
