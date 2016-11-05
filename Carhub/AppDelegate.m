//
//  AppDelegate.m
//  Carhub
//
//  Created by Ethan Esval on 7/18/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "AppDelegate.h"
#import "Model.h"
#import "Make.h"
#import "News.h"
#import "TopTens.h"
#import "RaceType.h"
#import "Race.h"
#import "RaceResult.h"
#import "RaceSeason.h"
#import "HomePageMedia.h"
#import "Currency.h"
#define k_Save @"Saveitem"
#import "TopTensViewController.h"
#import "TopTensViewController2.h"
#define getModelDataURL @"http://www.pl0x.net/CarHubJSON4.php"
#define updateModelVersionURL @"http://pl0x.net/ModelUpdateJSON.php"
#define updateSingleModelURL @"http://pl0x.net/ReloadModelData.php?primarykey="
#define updateAllDataURL @"http://pl0x.net/ReloadAllData.php"
#define getMakeDataURL @"http://pl0x.net/CarMakesJSON.php"
#define getNewsDataURL @"http://pl0x.net/CarNewsJSON.php"
#define getTopTensDataURL @"http://pl0x.net/CombinedTopTens.php"
#define getRaceTypeDataURL1 @"http://pl0x.net/RaceTypeJSON.php"
#define getRaceListDataURL @"http://pl0x.net/RaceListJSON.php"
#define getRaceResultsDataURL @"http://pl0x.net/RaceResultsJSON.php"
#define getHomePageDataURL @"http://pl0x.net/HomePageJSON.php"
#define getCurrencyDataURL @"http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json"
#import "CheckInternet.h"
#import <Google/Analytics.h>
#import <OneSignal/OneSignal.h>
#import "DetailViewController.h"
#import "TestViewController.h"
#import "SWRevealViewController.h"

@implementation AppDelegate

@synthesize favoritesarray, modelArray, modeljsonArray, makeimageArray, makejsonArray, AlphabeticalArray, newsArray, newsjsonArray, makeimageArray2, makejsonArray2, AlphabeticalArray2, zt60Array, topspeedArray, nurbArray, newexpensiveArray, fuelArray, horsepowerArray, toptensArray, topTensjson, auctionexpensiveArray, postArray, postjsonArray, raceTypeArray, raceTypejson, raceListArray, raceListjson, raceResultsArray, raceResultsjson, homePageArray, homePagejson, currencyArray, currencyjsonArray, hasLoaded, hasInternet, raceSeasonjson, raceSeasonArray, activeStoryboard;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    
    self.shouldRotate = NO;
    BOOL returnValue = YES;
    
    if([self isInternetConnectionAvailable] == false)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please check your internet connectivity." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        hasLoaded = NO;
        hasInternet = NO;
        returnValue = NO;
    }
    else
        hasInternet = YES;
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:@"MavenProRegular" size:20]}];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    UIBarButtonItem *navBarButtonAppearance = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    [navBarButtonAppearance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:0.1], NSForegroundColorAttributeName: [UIColor clearColor] }forState:UIControlStateNormal];
    
    // show the storyboard
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    int height = [UIScreen mainScreen].bounds.size.height;
    
    if (height == 480) {
        activeStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard4" bundle:nil];
    } else if (height == 568) {
        activeStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    } if (height == 667) {
        activeStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard6" bundle:nil];
    } if (height == 736) {
        activeStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard6+" bundle:nil];
    }
    
    __block UIViewController *viewController;
    
    //register push notifications
    
    [OneSignal initWithLaunchOptions:launchOptions appId:@"fad30cee-c636-400d-ab1c-cb56a8b372f3"];
    
    [OneSignal initWithLaunchOptions:launchOptions appId:@"fad30cee-c636-400d-ab1c-cb56a8b372f3" handleNotificationReceived:^(OSNotification *notification) {

    } handleNotificationAction:^(OSNotificationOpenedResult *result) {
        
        // This block gets called when the user reacts to a notification received
        OSNotificationPayload* payload = result.notification.payload;
        
        if (payload.additionalData) {
            NSDictionary* additionalData = payload.additionalData;
            
            if(additionalData[@"Car"])
            {
                NSString *carFullName = additionalData[@"Car"];
                viewController = [activeStoryboard instantiateInitialViewController];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:carFullName forKey:@"Car"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"preloadToModel" object:nil userInfo:userInfo];
                });
                
                self.window.rootViewController = viewController;
                [self.window makeKeyAndVisible];
            }
            
            if(additionalData[@"Article"])
            {
                NSString *articleName = additionalData[@"Article"];
                viewController = [activeStoryboard instantiateInitialViewController];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:articleName forKey:@"Article"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"preloadToArticle" object:nil userInfo:userInfo];
                });
                
                self.window.rootViewController = viewController;
                [self.window makeKeyAndVisible];
            }
            
            if(additionalData[@"Video"])
            {
                NSString *videoName = additionalData[@"Video"];
                viewController = [activeStoryboard instantiateInitialViewController];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:videoName forKey:@"Video"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"preloadToVideo" object:nil userInfo:userInfo];
                });
                
                self.window.rootViewController = viewController;
                [self.window makeKeyAndVisible];
            }
            
            if(additionalData[@"Race"])
            {
                NSString *raceName = additionalData[@"Race"];
                viewController = [activeStoryboard instantiateInitialViewController];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:raceName forKey:@"Race"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"preloadToRace" object:nil userInfo:userInfo];
                });
                
                self.window.rootViewController = viewController;
                [self.window makeKeyAndVisible];
            }
        }
        
    } settings:@{kOSSettingsKeyInFocusDisplayOption : @(OSNotificationDisplayTypeNotification), kOSSettingsKeyAutoPrompt : @NO}];

    //@"fad30cee-c636-400d-ab1c-cb56a8b372f3"
    // Sync hashed email if you have a login system or collect it.
    // Will be used to reach the user at the most optimal time of day.
    // [OneSignal syncHashedEmail:userEmail];
    
    if(viewController == nil)
    {
        viewController = [activeStoryboard instantiateInitialViewController];
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
    }
    
    return returnValue;
}

- (BOOL) isInternetConnectionAvailable
{
    CheckInternet *internet = [CheckInternet reachabilityWithHostName: @"www.google.com"];
    NetworkStatus netStatus = [internet currentReachabilityStatus];
    bool netConnection = false;
    switch (netStatus)
    {
        case NotReachable:
        {
            netConnection = false;
            break;
        }
        case ReachableViaWWAN:
        {
            netConnection = true;
            break;
        }
        case ReachableViaWiFi:
        {
            netConnection = true;
            break;
        }
    }
    return netConnection;
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (self.shouldRotate)
        return UIInterfaceOrientationMaskAllButUpsideDown;
    else
        return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)enablepurchase
{
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    int height = [UIScreen mainScreen].bounds.size.height;
    
    if (height == 480) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard4" bundle:nil];
        
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"IAP"]; // determine the initial view controller here
        
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"no" forKey:@"showads"];
        [defaults setBool:TRUE forKey:k_Save];
        [defaults synchronize];
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"IAP2"]; // determine the initial view controller here
        
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"no" forKey:@"showads"];
        [defaults setBool:TRUE forKey:k_Save];
        [defaults synchronize];
    }
}

-(void)updateSavedCarData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favoritesArray = [[NSMutableArray alloc]init];
    NSData *retrievedData = [defaults objectForKey:@"savedArray"];
    favoritesArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
    
    for(int i=0; i<modelArray.count; i++)
    {
        Model *currentModel = [modelArray objectAtIndex:i];

        for(int j=0; j<favoritesArray.count; j++)
        {
            Model *favorite = [favoritesArray objectAtIndex:j];
            if([favorite.CarFullName isEqualToString:currentModel.CarFullName])
                favorite = currentModel;
            [favoritesArray replaceObjectAtIndex:j withObject:favorite];
        }
        
        NSData *currentModelData = [NSKeyedArchiver archivedDataWithRootObject:currentModel];
        NSData *savedFirstCarData = [defaults objectForKey:@"firstcar"];
        NSData *savedSecondCarData = [defaults objectForKey:@"secondcar"];
        
        Model *firstCar;
        Model *secondCar;
        
        firstCar = [NSKeyedUnarchiver unarchiveObjectWithData:savedFirstCarData];
        secondCar = [NSKeyedUnarchiver unarchiveObjectWithData:savedSecondCarData];
        
        if([currentModel.CarFullName isEqualToString:firstCar.CarFullName])
        {
            [defaults setObject:currentModelData forKey:@"firstcar"];
        }
        
        if([currentModel.CarFullName isEqualToString:secondCar.CarFullName])
        {
            [defaults setObject:currentModelData forKey:@"secondcar"];
        }
    }
    
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:favoritesArray];
    [defaults setObject:arrayData forKey:@"savedArray"];
    [defaults synchronize];
}

-(void)updateAllData
{
    if([self isInternetConnectionAvailable] == false)
        return;
    
    modeljsonArray = [[NSMutableArray alloc]init];
    makejsonArray = [[NSMutableArray alloc]init];
    makejsonArray2 = [[NSMutableArray alloc]init];
    newsjsonArray = [[NSMutableArray alloc]init];
    topTensjson = [[NSMutableArray alloc]init];
    raceListjson = [[NSMutableArray alloc]init];
    raceTypejson = [[NSMutableArray alloc]init];
    raceSeasonjson = [[NSMutableArray alloc]init];
    raceResultsjson = [[NSMutableArray alloc]init];
    homePagejson = [[NSMutableArray alloc]init];
    
    [modeljsonArray removeAllObjects];
    [makejsonArray removeAllObjects];
    [makejsonArray2 removeAllObjects];
    [newsjsonArray removeAllObjects];
    [topTensjson removeAllObjects];
    [raceListjson removeAllObjects];
    [raceTypejson removeAllObjects];
    [raceResultsjson removeAllObjects];
    [raceSeasonArray removeAllObjects];
    [homePagejson removeAllObjects];
    
    NSURL * updateModelURL = [NSURL URLWithString:updateAllDataURL];
    NSData * updateData = [NSData dataWithContentsOfURL:updateModelURL];
    
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:updateData options:kNilOptions error:nil];

    for(int i=0; i<jsonArray.count; i++)
    {
        NSString * objectType = [[jsonArray objectAtIndex:i] objectForKey:@"ObjectType"];
        
        if([objectType isEqualToString:@"Model"])
            [modeljsonArray addObject:[jsonArray objectAtIndex:i]];
        if([objectType isEqualToString:@"Make"])
        {
            [makejsonArray addObject:[jsonArray objectAtIndex:i]];
            [makejsonArray2 addObject:[jsonArray objectAtIndex:i]];
        }
        if([objectType isEqualToString:@"News"])
            [newsjsonArray addObject:[jsonArray objectAtIndex:i]];
        if([objectType isEqualToString:@"TopTen"])
            [topTensjson addObject:[jsonArray objectAtIndex:i]];
        if([objectType isEqualToString:@"RaceList"])
            [raceListjson addObject:[jsonArray objectAtIndex:i]];
        if([objectType isEqualToString:@"RaceResult"])
            [raceResultsjson addObject:[jsonArray objectAtIndex:i]];
        if([objectType isEqualToString:@"RaceSeason"])
            [raceSeasonjson addObject:[jsonArray objectAtIndex:i]];
        if([objectType isEqualToString:@"RaceType"])
            [raceTypejson addObject:[jsonArray objectAtIndex:i]];
        if([objectType isEqualToString:@"HomeObject"])
            [homePagejson addObject:[jsonArray objectAtIndex:i]];
    }
    
    [self retrieveModelData];
    [self retrieveMakeImageData];
    [self retrievenewsData];
    [self retrieveMakeImageData2];
    [self splitTopTensArrays];
    [self retrieveRaceTypeData];
    [self splitRaceArray];
    [self retrieveRaceResultsData];
    [self retrieveRaceSeasonData];
    [self retrieveHomePageData];
    [self retrieveCurrencyData];
    [self setInitialRunSettings];
    [self setInitialSearchSettings];
    [self updateSavedCarData];
    
    hasLoaded = YES;
}

-(void)setInitialRunSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"HasLaunchedOnce"])
    {
        [defaults setBool:YES forKey:@"HasLaunchedOnce"];
        
        [defaults setObject:@"($) US Dollar" forKey:@"Currency"];
        [defaults setObject:@"hp" forKey:@"Horsepower"];
        [defaults setObject:@"lb·ft" forKey:@"Torque"];
        [defaults setObject:@"MPH" forKey:@"Top Speed"];
        [defaults setObject:@"lbs" forKey:@"Weight"];
        [defaults setObject:@"MPG US" forKey:@"Fuel Economy"];
        [defaults setObject:@"Horizontal Scroll" forKey:@"Makes Layout Preference"];

        [defaults synchronize];
    }
}
     
-(void)setInitialSearchSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:@"Any" forKey:@"Make Setting"];
    
    Model *defaultModel = [[Model alloc]initWithCarPrimaryKey:[NSNumber numberWithInt:0] andCarMake:@"" andCarModel:@"Any" andCarYearsMade:@"" andCarMSRP:[NSNumber numberWithInt:0] andCarPrice:@"" andCarPriceLow:[NSNumber numberWithInt:0] andCarPriceHigh:[NSNumber numberWithInt:0] andCarEngine:@"" andCarTransmission:@"" andCarDriveType:@"" andCarHorsepower:@"" andCarHorsepowerLow:[NSNumber numberWithInt:0] andCarHorsepowerHigh:[NSNumber numberWithInt:0] andCarTorque:@"" andCarTorqueLow:[NSNumber numberWithInt:0] andCarTorqueHigh:[NSNumber numberWithInt:0] andCarZeroToSixty:@"" andCarZeroToSixtyLow:[NSNumber numberWithInt:0]  andCarZeroToSixtyHigh:[NSNumber numberWithInt:0] andCarTopSpeed:@"" andCarTopSpeedLow:@"" andCarTopSpeedHigh:@"" andCarWeight:@"" andCarWeightLow:[NSNumber numberWithInt:0] andCarWeightHigh:[NSNumber numberWithInt:0] andCarFuelEconomy:@"" andCarFuelEconomyLow:[NSNumber numberWithInt:0] andCarFuelEconomyHigh:[NSNumber numberWithInt:0] andCarImageURL:@"" andCarWebsite:@"" andCarFullName:@"Any" andCarExhaust:@"" andCarHTML:@"" andShouldFlipEvox:@"" andisClass:[NSNumber numberWithInt:0] andisSubclass:[NSNumber numberWithInt:0] andisModel:[NSNumber numberWithInt:0] andisStyle:[NSNumber numberWithInt:0] andCarClass:@"" andCarSubclass:@"" andCarStyle:@"" andRemoveLogo:[NSNumber numberWithInteger:0] andZoomScale:[NSNumber numberWithInt:0]];
    
    NSData *defaultModelData = [NSKeyedArchiver archivedDataWithRootObject:defaultModel];

    [defaults setObject:defaultModelData forKey:@"Model Setting"];
    [defaults setObject:@"Any" forKey:@"Price Setting"];
    [defaults setObject:@"Any" forKey:@"Converted Price Setting"];
    [defaults setObject:@"Any" forKey:@"Engine Setting"];
    [defaults setObject:@"Any" forKey:@"Transmission Setting"];
    [defaults setObject:@"Any" forKey:@"Drive Type Setting"];
    [defaults setObject:@"Any" forKey:@"Horsepower Setting"];
    [defaults setObject:@"Any" forKey:@"Converted Horsepower Setting"];
    [defaults setObject:@"Any" forKey:@"Torque Setting"];
    [defaults setObject:@"Any" forKey:@"Converted Torque Setting"];
    [defaults setObject:@"Any" forKey:@"0-60 Time Setting"];
    [defaults setObject:@"Any" forKey:@"Fuel Economy Setting"];
    [defaults setObject:@"Any" forKey:@"Converted Fuel Economy Setting"];
    [defaults synchronize];
}

-(void)retrieveCurrencyData
{
    NSURL * currencyurl = [NSURL URLWithString:getCurrencyDataURL];
    NSData * currencydata = [NSData dataWithContentsOfURL:currencyurl];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:currencydata options:kNilOptions error:nil];
    NSArray *fetchedArr = [json objectForKey:@"list"];
    fetchedArr = [fetchedArr valueForKey:@"resources"];
    fetchedArr = [fetchedArr valueForKey:@"resource"];
    fetchedArr = [fetchedArr valueForKey:@"fields"];
    
    currencyArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < fetchedArr.count; i++)
    {
        NSString * cName = [[fetchedArr objectAtIndex:i] objectForKey:@"name"];
        NSNumber * cRate = [NSNumber numberWithDouble:[[[fetchedArr objectAtIndex:i]objectForKey:@"price"]doubleValue]];
        [currencyArray addObject:[[Currency alloc]initWithCurrencyName:cName andCurrencyRate:cRate]];
    }
}

- (void) retrieveModelData;
{
    [modelArray removeAllObjects];
    
    modelArray = [[NSMutableArray alloc] init];
    
    NSSortDescriptor * alphasort = [NSSortDescriptor sortDescriptorWithKey:@"Model" ascending:YES];
    modeljsonArray = [[modeljsonArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphasort]]mutableCopy];
    
    for (int i=0; i < modeljsonArray.count; i++)
    {
        NSNumber * cPrimaryKey = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"primarykey"]integerValue]];
        NSString * cMake = [[modeljsonArray objectAtIndex:i] objectForKey:@"Make"];
        NSString * cModel = [[modeljsonArray objectAtIndex:i] objectForKey:@"Model"];
        NSString * cYearsMade = [[modeljsonArray objectAtIndex:i] objectForKey:@"Years Made"];
        NSNumber * cMSRP = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"MSRP"]integerValue]];
        NSString * cPrice = [[modeljsonArray objectAtIndex:i] objectForKey:@"Price"];
        NSNumber * cPriceLow = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"Price Low"]integerValue]];
        NSNumber * cPriceHigh = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"Price High"]integerValue]];
        NSString * cEngine = [[modeljsonArray objectAtIndex:i] objectForKey:@"Engine"];
        NSString * cTransmission = [[modeljsonArray objectAtIndex:i] objectForKey:@"Transmission"];
        NSString * cDriveType = [[modeljsonArray objectAtIndex:i] objectForKey:@"Drive Type"];
        NSString * cHorsepower = [[modeljsonArray objectAtIndex:i] objectForKey:@"Horsepower"];
        NSNumber * cHorsepowerLow = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"Horsepower Low"]integerValue]];
        NSNumber * cHorsepowerHigh = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"Horsepower High"]integerValue]];
        NSString * cTorque = [[modeljsonArray objectAtIndex:i] objectForKey:@"Torque"];
        NSNumber * cTorqueLow = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"Torque Low"]integerValue]];
        NSNumber * cTorqueHigh = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"Torque High"]integerValue]];
        NSString * cZeroToSixty = [[modeljsonArray objectAtIndex:i] objectForKey:@"0-60"];
        NSNumber * cZeroToSixtyLow = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"0-60 Low"]doubleValue]];
        NSNumber * cZeroToSixtyHigh = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"0-60 High"]doubleValue]];
        NSString * cTopSpeed = [[modeljsonArray objectAtIndex:i] objectForKey:@"Top Speed (mph)"];
        NSString * cTopSpeedLow = [[modeljsonArray objectAtIndex:i] objectForKey:@"Top Speed Low"];
        NSString * cTopSpeedHigh = [[modeljsonArray objectAtIndex:i] objectForKey:@"Top Speed High"];
        NSString * cWeight = [[modeljsonArray objectAtIndex:i] objectForKey:@"Weight (lbs)"];
        NSNumber * cWeightLow = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"Weight Low"]integerValue]];
        NSNumber * cWeightHigh = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"Weight High"]integerValue]];
        NSString * cFuelEconomy = [[modeljsonArray objectAtIndex:i] objectForKey:@"Fuel Economy (mpg)"];
        NSNumber * cFuelEconomyLow = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"FE Low"]integerValue]];
        NSNumber * cFuelEconomyHigh = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"FE High"]integerValue]];
        NSString * cURL = [[modeljsonArray objectAtIndex:i] objectForKey:@"Image URL"];
        NSString * cWebsite = [[modeljsonArray objectAtIndex:i]objectForKey:@"Make Link"];
        NSString * cFullName = [NSString stringWithFormat:@"%@%@%@",cMake,@" ",cModel];
        NSString * cExhaust = [[modeljsonArray objectAtIndex:i] objectForKey:@"ExhaustSound"];
        NSString * cHTML = [[modeljsonArray objectAtIndex:i] objectForKey:@"ImageHTML"];
        NSString * cShouldFlipEvox = [[modeljsonArray objectAtIndex:i] objectForKey:@"ShouldFlipEvox"];
        NSNumber * cisClass = [NSNumber numberWithInteger:[[[modeljsonArray objectAtIndex:i]objectForKey:@"isClass"]integerValue]];
        NSNumber * cisSubClass = [NSNumber numberWithInteger:[[[modeljsonArray objectAtIndex:i]objectForKey:@"isSubclass"]integerValue]];
        NSNumber * cisStyle = [NSNumber numberWithInteger:[[[modeljsonArray objectAtIndex:i]objectForKey:@"isStyle"]integerValue]];
        NSNumber * cisModel = [NSNumber numberWithInteger:[[[modeljsonArray objectAtIndex:i]objectForKey:@"isModel"]integerValue]];
        NSString * cCarClass = [[modeljsonArray objectAtIndex:i] objectForKey:@"CarClass"];
        NSString * cCarSubclass = [[modeljsonArray objectAtIndex:i] objectForKey:@"CarSubclass"];
        NSString * cCarStyle = [[modeljsonArray objectAtIndex:i] objectForKey:@"CarStyle"];
        NSNumber * cRemoveLogo = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"RemoveLogo"]doubleValue]];
        NSNumber * cZoomScale = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"Zoom Scale"]doubleValue]];
        
        [modelArray addObject:[[Model alloc]initWithCarPrimaryKey:cPrimaryKey andCarMake:cMake andCarModel:cModel andCarYearsMade:cYearsMade andCarMSRP:cMSRP andCarPrice:cPrice andCarPriceLow:cPriceLow andCarPriceHigh:cPriceHigh andCarEngine:cEngine andCarTransmission:cTransmission andCarDriveType:cDriveType andCarHorsepower:cHorsepower andCarHorsepowerLow:cHorsepowerLow andCarHorsepowerHigh:cHorsepowerHigh andCarTorque:cTorque andCarTorqueLow:cTorqueLow andCarTorqueHigh:cTorqueHigh andCarZeroToSixty:cZeroToSixty andCarZeroToSixtyLow:cZeroToSixtyLow andCarZeroToSixtyHigh:cZeroToSixtyHigh andCarTopSpeed:cTopSpeed andCarTopSpeedLow:cTopSpeedLow andCarTopSpeedHigh:cTopSpeedHigh andCarWeight:cWeight andCarWeightLow:cWeightLow andCarWeightHigh:cWeightHigh andCarFuelEconomy:cFuelEconomy andCarFuelEconomyLow:cFuelEconomyLow andCarFuelEconomyHigh:cFuelEconomyHigh andCarImageURL:cURL andCarWebsite:cWebsite andCarFullName:cFullName andCarExhaust:cExhaust andCarHTML:cHTML andShouldFlipEvox:cShouldFlipEvox andisClass:cisClass andisSubclass:cisSubClass andisModel:cisModel andisStyle:cisStyle andCarClass:cCarClass andCarSubclass:cCarSubclass andCarStyle:cCarStyle andRemoveLogo:cRemoveLogo andZoomScale:cZoomScale]];
    }
}

- (void) retrieveMakeImageData;
{
    [makeimageArray removeAllObjects];
    
    makeimageArray = [[NSMutableArray alloc]init];
    
    NSSortDescriptor * alphasort = [NSSortDescriptor sortDescriptorWithKey:@"Make" ascending:YES];
    
    AlphabeticalArray = [makejsonArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphasort]];
    
    for (int i = 0; i < AlphabeticalArray.count; i++)
    {
        NSString * mName = [[AlphabeticalArray objectAtIndex:i] objectForKey:@"Make"];
        
        [makeimageArray addObject:mName];
    }
    NSString * defaultrow = @"Any";
    [makeimageArray insertObject:defaultrow atIndex:0];
}

- (void) retrieveMakeImageData2;
{
    [makeimageArray2 removeAllObjects];
    
    makeimageArray2 = [[NSMutableArray alloc]init];
    
    NSSortDescriptor * alphasort = [NSSortDescriptor sortDescriptorWithKey:@"Make" ascending:YES];
    AlphabeticalArray2 = [makejsonArray2 sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphasort]];
    
    for (int i = 0; i < makejsonArray2.count; i++)
    {
        NSString * mName = [[AlphabeticalArray2 objectAtIndex:i] objectForKey:@"Make"];
        NSString * mImageURL = [[AlphabeticalArray2 objectAtIndex:i] objectForKey:@"ImageURL"];
        NSString * mCountry = [[AlphabeticalArray2 objectAtIndex:i] objectForKey:@"Country"];
        NSNumber * mZoomScale = [NSNumber numberWithDouble:[[[AlphabeticalArray2 objectAtIndex:i]objectForKey:@"Zoom Scale"]doubleValue]];
        
        [makeimageArray2 addObject:[[Make alloc]initWithMakeName:mName andMakeImageURL:mImageURL andMakeCountry:mCountry andZoomScale:mZoomScale]];
    }
}

- (void) retrievenewsData;
{
    [newsArray removeAllObjects];
    
    newsArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i < newsjsonArray.count; i++)
    {
        NSString * nTitle = [[newsjsonArray objectAtIndex:i] objectForKey:@"Title"];
        NSString * nImageURL = [[newsjsonArray objectAtIndex:i] objectForKey:@"ImageURL"];
        NSString * nVideoID = [[newsjsonArray objectAtIndex:i] objectForKey:@"VideoID"];
        NSString * nDescription = [[newsjsonArray objectAtIndex:i] objectForKey:@"Description"];
        NSString * nArticle = [[newsjsonArray objectAtIndex:i] objectForKey:@"Article"];
        NSString * nDate = [[newsjsonArray objectAtIndex:i] objectForKey:@"Date"];
        NSString * nAuthor = [[newsjsonArray objectAtIndex:i] objectForKey:@"Author"];
        NSString * nImageURL1 = [[newsjsonArray objectAtIndex:i] objectForKey:@"ImageURL1"];
        NSString * nImageURL2 = [[newsjsonArray objectAtIndex:i] objectForKey:@"ImageURL2"];
        NSString * nImageURL3 = [[newsjsonArray objectAtIndex:i] objectForKey:@"ImageURL3"];
        NSString * nImageURL4 = [[newsjsonArray objectAtIndex:i] objectForKey:@"ImageURL4"];
        NSString * nImageURL5 = [[newsjsonArray objectAtIndex:i] objectForKey:@"ImageURL5"];
        NSString * nImage1Caption = [[newsjsonArray objectAtIndex:i] objectForKey:@"Image1Caption"];
        NSString * nImage2Caption = [[newsjsonArray objectAtIndex:i] objectForKey:@"Image2Caption"];
        NSString * nImage3Caption = [[newsjsonArray objectAtIndex:i] objectForKey:@"Image3Caption"];
        NSString * nImage4Caption = [[newsjsonArray objectAtIndex:i] objectForKey:@"Image4Caption"];
        NSString * nImage5Caption = [[newsjsonArray objectAtIndex:i] objectForKey:@"Image5Caption"];
                
        [newsArray addObject:[[News alloc]initWithNewsTitle:nTitle andNewsImageURL:nImageURL andNewsVideoID:nVideoID andNewsDescription:nDescription andNewsArticle:nArticle andNewsDate:nDate andNewsAuthor:nAuthor andNewsImageURL1:nImageURL1 andNewsImageURL2:nImageURL2 andNewsImageURL3:nImageURL3 andNewsImageURL4:nImageURL4 andNewsImageURL5:nImageURL5 andNewsImage1Caption:nImage1Caption andNewsImage2Caption:nImage2Caption andNewsImage3Caption:nImage3Caption andNewsImage4Caption:nImage4Caption andNewsImage5Caption:nImage5Caption]];
    }
}

- (void) retrieveRaceTypeData;
{
    [raceTypeArray removeAllObjects];
    
    raceTypeArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i < raceTypejson.count; i++)
    {
        NSString * nRaceType = [[raceTypejson objectAtIndex:i] objectForKey:@"RaceType"];
        NSString * nImageURL = [[raceTypejson objectAtIndex:i] objectForKey:@"ImageURL"];
        NSNumber * nZoomScale = [NSNumber numberWithDouble:[[[raceTypejson objectAtIndex:i]objectForKey:@"Zoom Scale"]doubleValue]];
        
        [raceTypeArray addObject:[[RaceType alloc]initWithRaceType:nRaceType andTypeImageURL:nImageURL andTypeZoomScale:nZoomScale]];
    }
}

- (void) retrieveRaceSeasonData;
{
    [raceSeasonArray removeAllObjects];
    
    raceSeasonArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i < raceSeasonjson.count; i++)
    {
        NSString * nSeason = [[raceSeasonjson objectAtIndex:i] objectForKey:@"SeasonName"];
        NSString * nClass = [[raceSeasonjson objectAtIndex:i] objectForKey:@"SeasonClass"];
        
        [raceSeasonArray addObject:[[RaceSeason alloc]initWithSeasonName:nSeason andSeasonClass:nClass]];
    }
}

- (void) splitRaceArray;
{
    [raceListArray removeAllObjects];
    
    raceListArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i < raceListjson.count; i++)
    {
        NSString * nRaceName = [[raceListjson objectAtIndex:i] objectForKey:@"RaceName"];
        NSString * nSeasonRaceName = [[raceListjson objectAtIndex:i] objectForKey:@"SeasonRaceName"];
        NSString * nImageURL = [[raceListjson objectAtIndex:i] objectForKey:@"RaceImageURL"];
        NSNumber * nZoomScale = [NSNumber numberWithDouble:[[[raceListjson objectAtIndex:i]objectForKey:@"Zoom Scale"]doubleValue]];
        NSString * nRaceType = [[raceListjson objectAtIndex:i] objectForKey:@"RaceType"];
        NSString * nRaceSeason = [[raceListjson objectAtIndex:i] objectForKey:@"RaceSeason"];
        NSString * nResultsImageURL1 = [[raceListjson objectAtIndex:i] objectForKey:@"ResultsImageURL1"];
        NSString * nResultsImageURL2 = [[raceListjson objectAtIndex:i] objectForKey:@"ResultsImageURL2"];
        NSString * nResultsImageURL3 = [[raceListjson objectAtIndex:i] objectForKey:@"ResultsImageURL3"];
        NSString * nResultsImageURL4 = [[raceListjson objectAtIndex:i] objectForKey:@"ResultsImageURL4"];
        
        NSString *dateString = [[raceListjson objectAtIndex:i] objectForKey:@"RaceDate"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yy"];
        NSDate *nRaceDate = [dateFormatter dateFromString:dateString];
        
        Race *currentRace = [[Race alloc]initWithRaceName:nRaceName andSeasonRaceName:nSeasonRaceName andRaceImageURL:nImageURL andRaceZoomScale:nZoomScale andRaceType:nRaceType andRaceSeason:nRaceSeason andRaceDate:nRaceDate andResultsImageURL1:nResultsImageURL1 andResultsImageURL2:nResultsImageURL2 andResultsImageURL3:nResultsImageURL3 andResultsImageURL4:nResultsImageURL4];
    
        [raceListArray addObject:currentRace];
    }
}

- (void) retrieveRaceResultsData;
{
    [raceResultsArray removeAllObjects];

    raceResultsArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i < raceResultsjson.count; i++)
    {
        NSNumber * nPosition = [NSNumber numberWithDouble:[[[raceResultsjson objectAtIndex:i]objectForKey:@"Position"]doubleValue]];
        NSString * nExcluded = [[raceResultsjson objectAtIndex:i] objectForKey:@"Excluded"];
        NSString * nDriver = [[raceResultsjson objectAtIndex:i] objectForKey:@"Driver"];
        NSString * nTeam = [[raceResultsjson objectAtIndex:i] objectForKey:@"Team"];
        NSString * nCountry = [[raceResultsjson objectAtIndex:i] objectForKey:@"Country"];
        NSString * nCar = [[raceResultsjson objectAtIndex:i] objectForKey:@"Car"];
        NSString * nTime = [[raceResultsjson objectAtIndex:i] objectForKey:@"Time"];
        NSString * nBestLapTime = [[raceResultsjson objectAtIndex:i] objectForKey:@"BestLapTime"];
        NSString * nRaceClass = [[raceResultsjson objectAtIndex:i]objectForKey:@"Class"];
        NSString * nRaceID = [[raceResultsjson objectAtIndex:i] objectForKey:@"RaceID"];
        NSString * nDriver2 = [[raceResultsjson objectAtIndex:i] objectForKey:@"Driver2"];
        NSString * nDriver3 = [[raceResultsjson objectAtIndex:i] objectForKey:@"Driver3"];
        NSString * nCategory = [[raceResultsjson objectAtIndex:i] objectForKey:@"Category"];
        NSString * nCarNumber = [[raceResultsjson objectAtIndex:i] objectForKey:@"CarNumber"];

        
        [raceResultsArray addObject:[[RaceResult alloc]initWithPosition:nPosition andExcluded:nExcluded andDriver:nDriver andTeam:nTeam andCountry:nCountry andCar:nCar andTime:nTime andBestLapTime:nBestLapTime andRaceClass:nRaceClass andRaceID:nRaceID andDriver2:nDriver2 andDriver3:nDriver3 andCategory:nCategory andCarNumber:nCarNumber]];
    }
}

- (void) splitTopTensArrays;
{
    [zt60Array removeAllObjects];
    [topspeedArray removeAllObjects];
    [nurbArray removeAllObjects];
    [newexpensiveArray removeAllObjects];
    [auctionexpensiveArray removeAllObjects];
    [horsepowerArray removeAllObjects];
    [fuelArray removeAllObjects];
    
    zt60Array = [[NSMutableArray alloc]init];
    topspeedArray = [[NSMutableArray alloc]init];
    nurbArray = [[NSMutableArray alloc]init];
    newexpensiveArray = [[NSMutableArray alloc]init];
    auctionexpensiveArray = [[NSMutableArray alloc]init];
    horsepowerArray = [[NSMutableArray alloc]init];
    fuelArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i < topTensjson.count; i++)
    {
        NSString * nType = [[topTensjson objectAtIndex:i] objectForKey:@"TopTenType"];
        
        if([nType isEqualToString:@"ZeroToSixty"]){
            NSString * nRank = [[topTensjson objectAtIndex:i] objectForKey:@"Rank"];
            NSString * nName = [[topTensjson objectAtIndex:i] objectForKey:@"Car Name"];
            NSString * nValue = [[topTensjson objectAtIndex:i] objectForKey:@"Value"];
            NSString * nURL = [[topTensjson objectAtIndex:i] objectForKey:@"ImageURL"];
            
            [zt60Array addObject:[[TopTens alloc]initWithCarRank:nRank andCarName:nName andCarValue:nValue andCarURL:nURL andTopTenType:nType]];
        }
        if([nType isEqualToString:@"TopSpeeds"]){
            NSString * nRank = [[topTensjson objectAtIndex:i] objectForKey:@"Rank"];
            NSString * nName = [[topTensjson objectAtIndex:i] objectForKey:@"Car Name"];
            NSString * nValue = [[topTensjson objectAtIndex:i] objectForKey:@"Value"];
            NSString * nURL = [[topTensjson objectAtIndex:i] objectForKey:@"ImageURL"];
            
            [topspeedArray addObject:[[TopTens alloc]initWithCarRank:nRank andCarName:nName andCarValue:nValue andCarURL:nURL andTopTenType:nType]];
        }
        if([nType isEqualToString:@"Nurb"]){
            NSString * nRank = [[topTensjson objectAtIndex:i] objectForKey:@"Rank"];
            NSString * nName = [[topTensjson objectAtIndex:i] objectForKey:@"Car Name"];
            NSString * nValue = [[topTensjson objectAtIndex:i] objectForKey:@"Value"];
            NSString * nURL = [[topTensjson objectAtIndex:i] objectForKey:@"ImageURL"];
            
            [nurbArray addObject:[[TopTens alloc]initWithCarRank:nRank andCarName:nName andCarValue:nValue andCarURL:nURL andTopTenType:nType]];
        }
        if([nType isEqualToString:@"NewExpensive"]){
            NSString * nRank = [[topTensjson objectAtIndex:i] objectForKey:@"Rank"];
            NSString * nName = [[topTensjson objectAtIndex:i] objectForKey:@"Car Name"];
            NSString * nValue = [[topTensjson objectAtIndex:i] objectForKey:@"Value"];
            NSString * nURL = [[topTensjson objectAtIndex:i] objectForKey:@"ImageURL"];
            
            [newexpensiveArray addObject:[[TopTens alloc]initWithCarRank:nRank andCarName:nName andCarValue:nValue andCarURL:nURL andTopTenType:nType]];
        }
        if([nType isEqualToString:@"AuctionExpensive"]){
            NSString * nRank = [[topTensjson objectAtIndex:i] objectForKey:@"Rank"];
            NSString * nName = [[topTensjson objectAtIndex:i] objectForKey:@"Car Name"];
            NSString * nValue = [[topTensjson objectAtIndex:i] objectForKey:@"Value"];
            NSString * nURL = [[topTensjson objectAtIndex:i] objectForKey:@"ImageURL"];
            
            [auctionexpensiveArray addObject:[[TopTens alloc]initWithCarRank:nRank andCarName:nName andCarValue:nValue andCarURL:nURL andTopTenType:nType]];
        }
        if([nType isEqualToString:@"Horsepower"]){
            NSString * nRank = [[topTensjson objectAtIndex:i] objectForKey:@"Rank"];
            NSString * nName = [[topTensjson objectAtIndex:i] objectForKey:@"Car Name"];
            NSString * nValue = [[topTensjson objectAtIndex:i] objectForKey:@"Value"];
            NSString * nURL = [[topTensjson objectAtIndex:i] objectForKey:@"ImageURL"];
            
            [horsepowerArray addObject:[[TopTens alloc]initWithCarRank:nRank andCarName:nName andCarValue:nValue andCarURL:nURL andTopTenType:nType]];
        }
        if([nType isEqualToString:@"Fuel"]){
            NSString * nRank = [[topTensjson objectAtIndex:i] objectForKey:@"Rank"];
            NSString * nName = [[topTensjson objectAtIndex:i] objectForKey:@"Car Name"];
            NSString * nValue = [[topTensjson objectAtIndex:i] objectForKey:@"Value"];
            NSString * nURL = [[topTensjson objectAtIndex:i] objectForKey:@"ImageURL"];
            
            [fuelArray addObject:[[TopTens alloc]initWithCarRank:nRank andCarName:nName andCarValue:nValue andCarURL:nURL andTopTenType:nType]];
        }
    }
}

- (void) retrieveHomePageData;
{
    [homePageArray removeAllObjects];
    
    homePageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < homePagejson.count; i++)
    {
        NSString * nImageURL = [[homePagejson objectAtIndex:i] objectForKey:@"ImageURL"];
        NSNumber * nZoomScale = [NSNumber numberWithDouble:[[[homePagejson objectAtIndex:i]objectForKey:@"Zoom Scale"]doubleValue]];
        NSNumber * nZoomScale2 = [NSNumber numberWithDouble:[[[homePagejson objectAtIndex:i]objectForKey:@"ZoomScale2"]doubleValue]];
        NSNumber * nZoomScale3 = [NSNumber numberWithDouble:[[[homePagejson objectAtIndex:i]objectForKey:@"ZoomScale3"]doubleValue]];
        NSNumber * nZoomScale4 = [NSNumber numberWithDouble:[[[homePagejson objectAtIndex:i]objectForKey:@"ZoomScale4"]doubleValue]];
        NSString * nImageURL2 = [[homePagejson objectAtIndex:i] objectForKey:@"ImageURL2"];
        NSString * nImageURL3 = [[homePagejson objectAtIndex:i] objectForKey:@"ImageURL3"];
        NSString * nImageURL4 = [[homePagejson objectAtIndex:i] objectForKey:@"ImageURL4"];
        NSString * nCarHTML = [[homePagejson objectAtIndex:i] objectForKey:@"CarHTML"];
        NSString * nFullCarModel = [[homePagejson objectAtIndex:i] objectForKey:@"FullCarModel"];
        NSString * nDescription = [[homePagejson objectAtIndex:i] objectForKey:@"Description"];
        NSString * nRaceDate = [[homePagejson objectAtIndex:i] objectForKey:@"RaceDate"];
        NSString * nSpecType1 = [[homePagejson objectAtIndex:i] objectForKey:@"SpecType1"];
        NSString * nSpecLabel1 = [[homePagejson objectAtIndex:i] objectForKey:@"SpecLabel1"];
        NSString * nSpecType2 = [[homePagejson objectAtIndex:i] objectForKey:@"SpecType2"];
        NSString * nSpecLabel2 = [[homePagejson objectAtIndex:i] objectForKey:@"SpecLabel2"];
        NSString * nMediaType = [[homePagejson objectAtIndex:i] objectForKey:@"MediaType"];
        
        [homePageArray addObject:[[HomePageMedia alloc] initWithImageURL:nImageURL andZoomScale:nZoomScale andZoomScale2:nZoomScale2 andZoomScale3:nZoomScale3 andZoomScale4:nZoomScale4 andImageURL2:nImageURL2 andImageURL3:nImageURL3 andImageURL4:nImageURL4 andCarHTML:nCarHTML andFullCarModel:nFullCarModel andDescription:nDescription andRaceDate:nRaceDate andSpecType1:nSpecType1 andSpecLabel1:nSpecLabel1 andSpecType2:nSpecType2 andSpecLabel2:nSpecLabel2 andMediaType:nMediaType]];
    }
}
@end
