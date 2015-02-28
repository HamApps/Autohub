//
//  SearchTabViewController.h
//  Carhub
//
//  Created by Christopher Clark on 2/27/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface SearchTabViewController : UITableViewController<UISearchDisplayDelegate>

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray * appdelmodelArray;
@property (nonatomic, strong) NSMutableArray * ModelArray;
@property (nonatomic, strong) NSArray * searchArray;

@end
