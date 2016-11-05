//
//  SearchViewController.h
//  Carhub
//
//  Created by Christoper Clark on 10/2/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (strong, nonatomic) NSIndexPath *expandedIndexPath;

@property (nonatomic, strong) NSMutableArray * fullModelArray;
@property (nonatomic, strong) NSMutableArray * alteredModelArray;
@property (nonatomic, strong) NSMutableArray * alteredModelSpecsArray;
@property (nonatomic, strong) NSMutableArray * makeArray;

@property(nonatomic, strong) NSString * currencySymbol;
@property(nonatomic, strong) NSString * hpUnit;
@property(nonatomic, strong) NSString * torqueUnit;
@property(nonatomic, strong) NSString * speedUnit;
@property(nonatomic, strong) NSString * weightUnit;
@property(nonatomic, strong) NSString * fuelEconomyUnit;

-(void)closeCellTable;

@end
