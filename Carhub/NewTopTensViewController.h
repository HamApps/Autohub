//
//  NewTopTensViewController.h
//  Carhub
//
//  Created by Christopher Clark on 2/15/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "TopTensCell.h"
#import "DetailViewController.h"

@interface NewTopTensViewController : UIViewController<UITableViewDelegate, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray * jsonArray;
@property (nonatomic, strong) NSMutableArray * topTensArray;
@property (nonatomic, strong) NSMutableArray * appdelmodelArray;
@property (nonatomic, strong) NSString *currentTopTen;
@property (nonatomic, strong) NSString *urlExtention;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) Model * objectToSend;
@property (nonatomic, strong) NSIndexPath *sendingIndex;
@property (nonatomic, strong) TopTensCell *detailCell;
@property (nonatomic, strong) UIScrollView *detailImageScroller;
@property (nonatomic, assign) DetailViewController *detailView;
@property CGRect initialCellFrame;
@property CGRect initialScrollerFrame;
@property NSString* titleString;
@property int yCenter;
@property int yCenterModel;

-(void)getTopTenID:(id)TopTenID;

@end
