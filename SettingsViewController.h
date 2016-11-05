//
//  SettingsViewController.h
//  Carhub
//
//  Created by Christoper Clark on 6/23/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (strong, nonatomic) NSIndexPath *expandedIndexPath;

-(void)closeCellTable;

@end
