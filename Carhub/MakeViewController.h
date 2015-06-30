//
//  MakeViewController.h
//  Carhub
//
//  Created by Christopher Clark on 8/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Make.h"
#import "Model.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface MakeViewController : UICollectionViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@property (nonatomic, strong) NSMutableArray * makeimageArray;
@property (nonatomic, strong) NSMutableArray * modelArray;
@property (nonatomic, strong) Make * currentMake;

@end
