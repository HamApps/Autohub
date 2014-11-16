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

@interface SearchModelController : UITableViewController
@property (nonatomic, strong) NSMutableArray * jsonArray;
@property (nonatomic, strong) NSMutableArray * carArray;
@property (nonatomic, retain) NSArray * ModelArray;
@property (nonatomic, strong) NSMutableDictionary *cachedImages;

- (void)getfirstModel:(id)firstcarObject2;
- (void)getsecondModel:(id)secondcarObject2;
- (void)getsearcharray:(id)searcharrayObject;

@property (nonatomic, strong) Model * currentModel;

@property(nonatomic, strong) Model * firstCar2;
@property(nonatomic, strong) Model * secondCar2;

#pragma mark-
#pragma mark Class Methods

@end
