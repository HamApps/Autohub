//
//  ModelViewController.h
//  Carhub
//
//  Created by Christopher Clark on 8/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "MakeViewController.h"

@interface ModelViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray * jsonArray;
@property (nonatomic, strong) NSMutableArray * carArray;
@property (nonatomic, strong) NSMutableArray * appdelmodelArray;
@property (nonatomic, retain) NSArray * ModelArray;
@property (nonatomic, strong) NSMutableDictionary *cachedImages;
@property (nonatomic, strong) NSArray * AlphabeticalArray;

- (void)getfirstModel:(id)firstcarObject2;
- (void)getsecondModel:(id)secondcarObject2;
- (void)getmodelarray:(id)modelArray;

@property (nonatomic, strong) Model * currentModel;
@property (nonatomic, strong) Make * currentMake;

@property(nonatomic, strong) Model * firstCar2;
@property(nonatomic, strong) Model * secondCar2;

#pragma mark-
#pragma mark Class Methods
- (void) getMake:(id)makeObject;
- (void) retrieveData;
@end
