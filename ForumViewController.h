//
//  ForumViewController.h
//  Carhub
//
//  Created by Christopher Clark on 9/12/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForumViewController : UITableViewController<UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray * appdelpostArray;
@property (nonatomic, strong) NSArray * postArray;
@property (nonatomic, strong) NSArray * searchArray;

- (IBAction)increaseUpCount:(id)sender;
- (IBAction)increaseDownCount:(id)sender;

@end
