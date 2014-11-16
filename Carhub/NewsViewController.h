//
//  NewsViewController.h
//  Carhub
//
//  Created by Christopher Clark on 8/22/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface NewsViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray * jsonArray;
@property (nonatomic, strong) NSMutableArray * newsArray;

@property (nonatomic, strong) NSMutableDictionary *cachedImages;

- (void) retrieveData;

@end
