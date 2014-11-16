//
//  AppDelegate.h
//  Carhub
//
//  Created by Ethan Esval on 7/18/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "iRate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ADBannerView *UIiAD;
@property (nonatomic, retain) NSMutableArray * favoritesarray;
@property (nonatomic, strong) NSMutableArray * modeljsonArray;
@property (nonatomic, strong) NSMutableArray * modelArray;

@property (nonatomic, strong) NSMutableArray * makejsonArray;
@property (nonatomic, strong) NSMutableArray * makeimageArray;
@property (nonatomic, strong) NSArray * AlphabeticalArray;

@property (nonatomic, strong) NSMutableArray * makejsonArray2;
@property (nonatomic, strong) NSMutableArray * makeimageArray2;
@property (nonatomic, strong) NSArray * AlphabeticalArray2;

@property (nonatomic, strong) NSMutableArray * newsjsonArray;
@property (nonatomic, strong) NSMutableArray * newsArray;

//+ (void)initialize;
- (void)enablepurchase;

@end
