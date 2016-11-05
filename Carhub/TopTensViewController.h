//
//  TopTensViewController.h
//  Carhub
//
//  Created by Ethan Esval on 7/23/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface TopTensViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@end

