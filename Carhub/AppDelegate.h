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

@property (assign, nonatomic) BOOL shouldRotate;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ADBannerView *UIiAD;
@property (nonatomic, retain) NSMutableArray * favoritesarray;
@property (nonatomic, strong) NSMutableArray * modeljsonArray;
@property (nonatomic, strong) NSMutableArray * modelArray;

@property (nonatomic, strong) NSMutableArray * makejsonArray;
@property (nonatomic, strong) NSMutableArray * makeimageArray;
@property (nonatomic, strong) NSArray * AlphabeticalArray;

@property (nonatomic, strong) NSMutableArray * postjsonArray;
@property (nonatomic, strong) NSMutableArray * postArray;

@property (nonatomic, strong) NSMutableArray * makejsonArray2;
@property (nonatomic, strong) NSMutableArray * makeimageArray2;
@property (nonatomic, strong) NSArray * AlphabeticalArray2;

@property (nonatomic, strong) NSMutableArray * newsjsonArray;
@property (nonatomic, strong) NSMutableArray * newsArray;

@property (nonatomic, strong) NSMutableArray * zt60Array;
@property (nonatomic, strong) NSMutableArray * topspeedArray;
@property (nonatomic, strong) NSMutableArray * nurbArray;
@property (nonatomic, strong) NSMutableArray * newexpensiveArray;
@property (nonatomic, strong) NSMutableArray * auctionexpensiveArray;
@property (nonatomic, strong) NSMutableArray * fuelArray;
@property (nonatomic, strong) NSMutableArray * horsepowerArray;
@property (nonatomic, strong) NSMutableArray * topTensjson;
@property (nonatomic, strong) NSMutableArray * toptensArray;

//+ (void)initialize;
- (void)enablepurchase;

@end
