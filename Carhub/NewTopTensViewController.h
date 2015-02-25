//
//  NewTopTensViewController.h
//  Carhub
//
//  Created by Christopher Clark on 2/15/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTopTensViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray * jsonArray;
@property (nonatomic, strong) NSMutableArray * topTensArray;
@property (nonatomic, strong) NSString *currentTopTen;
@property (nonatomic, strong) NSString *urlExtention;

-(void)getTopTenID:(id)TopTenID;

@end
