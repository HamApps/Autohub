//
//  Created by Ethan Esval on 7/18/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "iRate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (assign, nonatomic) BOOL shouldRotate;

@property (assign, nonatomic) BOOL hasLoaded;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ADBannerView *UIiAD;
@property (nonatomic, strong) NSMutableArray * currencyjsonArray;
@property (nonatomic, strong) NSMutableArray * currencyArray;
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
@property (nonatomic, strong) NSMutableArray * raceTypejson;
@property (nonatomic, strong) NSMutableArray * raceTypeArray;
@property (nonatomic, strong) NSMutableArray * raceListjson;
@property (nonatomic, strong) NSMutableArray * raceListArray;
@property (nonatomic, strong) NSMutableArray * formulaOneArray;
@property (nonatomic, strong) NSMutableArray * nascarArray;
@property (nonatomic, strong) NSMutableArray * indyCarArray;
@property (nonatomic, strong) NSMutableArray * fiaArray;
@property (nonatomic, strong) NSMutableArray * wrcArray;
@property (nonatomic, strong) NSMutableArray * raceResultsjson;
@property (nonatomic, strong) NSMutableArray * raceResultsArray;
@property (nonatomic, strong) NSMutableArray * homePagejson;
@property (nonatomic, strong) NSMutableArray * homePageArray;

//App Delegate Methods to call
-(void)performInitialLoad;
- (void) splitTopTensArrays;
- (void) retrieveHomePageData;
- (void) retrievenewsData;
- (void) enablepurchase;

@end