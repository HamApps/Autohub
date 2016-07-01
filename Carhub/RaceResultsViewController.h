//
//  RaceResultsViewController.h
//  Carhub
//
//  Created by Christopher Clark on 10/10/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Race.h"

@interface RaceResultsViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray * currentRaceResultsArray;
@property (nonatomic, strong) Race *currentRace;

-(void)getRaceResults:(id)currentRaceID;

@end