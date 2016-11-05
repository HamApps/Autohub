//
//  AllRacesViewController.h
//  Carhub
//
//  Created by Christoper Clark on 8/26/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RaceTableCell.h"
#import "Race.h"

@interface AllRacesViewController : UITableViewController<UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray * RacesArray;

@property (nonatomic, strong) IBOutlet UIView *upperView;
@property (nonatomic, strong) NSArray * searchArray;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic) BOOL searchBarActive;

@property (nonatomic, strong) RaceTableCell *selectedCell;
@property (nonatomic, strong) Race *raceToSend;

- (void)setUpAllRacesArray;

@end
