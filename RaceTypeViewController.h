//
//  RaceTypeViewController.h
//  Carhub
//
//  Created by Christopher Clark on 9/21/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RaceType.h"

@interface RaceTypeViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray * raceTypeArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (strong, nonatomic) RaceType *raceTypeID;


@end
