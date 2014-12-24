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

@interface MakeViewController : UICollectionViewController

@property (nonatomic, strong) NSMutableArray * makeimageArray;
@property (nonatomic, strong) NSMutableArray * modelArray;
@property (nonatomic, strong) NSMutableArray * appdelmodelArray;

@property (nonatomic, strong) Make * currentMake;

- (void)getfirstModel:(id)firstcarObject1;
- (void)getsecondModel:(id)secondcarObject1;

@property(nonatomic, strong) Model * firstCar1;
@property(nonatomic, strong) Model * secondCar1;

@end
