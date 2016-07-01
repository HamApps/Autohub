//
//  RaceViewController.h
//  Carhub
//
//  Created by Christopher Clark on 10/9/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RaceType.h"
#import "Race.h"

@interface RaceViewController : UITableViewController

@property (nonatomic, strong) RaceType *currentRaceType;
@property (nonatomic, strong) NSMutableArray * currentRaceTypeArray;
@property (strong, nonatomic) Race *currentRaceID;

-(void)getRaceTypeID:(id)RaceTypeID;

@end