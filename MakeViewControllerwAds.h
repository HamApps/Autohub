//
//  MakeViewControllerwAds.h
//  Carhub
//
//  Created by Christopher Clark on 1/28/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Make.h"
#import "Model.h"

@interface MakeViewControllerwAds : UICollectionViewController

@property (nonatomic, strong) NSMutableArray * makejsonArray;
@property (nonatomic, strong) NSMutableArray * makeimageArray;
@property (nonatomic, strong) NSMutableArray * modelArray;
@property (nonatomic, strong) NSMutableArray * appdelmodelArray;

@property (nonatomic, strong) Make * currentMake;

- (void)getfirstModel:(id)firstcarObject1;
- (void)getsecondModel:(id)secondcarObject1;

@property(nonatomic, strong) Model * firstCar1;
@property(nonatomic, strong) Model * secondCar1;

@end
