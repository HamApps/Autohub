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
#define k_Save @"Saveitem"
#import "TopTensViewController.h"
#import "TopTensViewController2.h"
#define getModelDataURL @"http://pl0x.net/CarHubJSON3.php"
#define getMakeDataURL @"http://pl0x.net/CarMakesJSON.php"
#define getNewsDataURL @"http://pl0x.net/CarNewsJSON.php"
#define getTopTensDataURL @"http://pl0x.net/CombinedTopTens.php"


@implementation AppDelegate

@synthesize favoritesarray, modelArray, modeljsonArray, makeimageArray, makejsonArray, AlphabeticalArray, newsArray, newsjsonArray, makeimageArray2, makejsonArray2, AlphabeticalArray2, zt60Array, topspeedArray, nurbArray, newexpensiveArray, fuelArray, horsepowerArray, toptensArray, topTensjson, auctionexpensiveArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions

{
    
    UIStoryboard *storyboard = [self grabStoryboard];
    
    
    
    [self retrieveModelData];
    
    NSLog(@"Done 1");
    
    [self retrieveMakeImageData];
    
    NSLog(@"Done 2");
    
    [self retrievenewsData];
    
    NSLog(@"Done 3");
    
    [self retrieveMakeImageData2];
    
    NSLog(@"Done 4");
    
    [self retrieveTopTensData];
    
    NSLog(@"Done 5");
    
    [self splitTopTensArrays];
    
    NSLog(@"Done 6");
    
    
    
    // show the storyboard
    
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    
    [self.window makeKeyAndVisible];

        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        
        int height = [UIScreen mainScreen].bounds.size.height;
        if (height == 480) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard4" bundle:nil];
            UIViewController *viewController = [storyboard instantiateInitialViewController];
            self.window.rootViewController = viewController;
            [self.window makeKeyAndVisible];
        } else if (height == 568) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            UIViewController *viewController = [storyboard instantiateInitialViewController];
            self.window.rootViewController = viewController;
            [self.window makeKeyAndVisible];
        } if (height == 667) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard6" bundle:nil];
            UIViewController *viewController = [storyboard instantiateInitialViewController];
            self.window.rootViewController = viewController;
            [self.window makeKeyAndVisible];
        } if (height == 736) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard6+" bundle:nil];
            UIViewController *viewController = [storyboard instantiateInitialViewController];
            self.window.rootViewController = viewController;
            [self.window makeKeyAndVisible];
        }
    
    
    
    return YES;
}
- (UIStoryboard *)grabStoryboard {
    
    UIStoryboard *storyboard;
    
    // detect the height of our screen
    int height = [UIScreen mainScreen].bounds.size.height;
    UIImage* tabBarBackground = [UIImage imageNamed:@"DarkerTabBarColor.png"];
    [[UINavigationBar appearance] setBackgroundImage:tabBarBackground forBarMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"darkishgrey.jpg"] forBarMetrics:UIBarMetricsDefault];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Eurostile" size:21.0], NSFontAttributeName, nil]];
    
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_selected.png"]];
     
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    if (height == 480) {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard4" bundle:nil];
        // NSLog(@"Device has a 3.5inch Display.");
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        // NSLog(@"Device has a 4inch Display.");
    }
    
    return storyboard;
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
- (void)enablepurchase{
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

- (void) retrieveModelData;
{
    NSURL * modelurl = [NSURL URLWithString:getModelDataURL];
    NSData * modeldata = [NSData dataWithContentsOfURL:modelurl];
    
    modeljsonArray = [NSJSONSerialization JSONObjectWithData:modeldata options:kNilOptions error:nil];

    modelArray = [[NSMutableArray alloc] init];
    
    //Loop through ourjsonArray
    for (int i=0; i < modeljsonArray.count; i++)
    {
        //Create our city object
        NSString * cMake = [[modeljsonArray objectAtIndex:i] objectForKey:@"Make"];
        NSString * cModel = [[modeljsonArray objectAtIndex:i] objectForKey:@"Model"];
        NSString * cYearsMade = [[modeljsonArray objectAtIndex:i] objectForKey:@"Years Made"];
        NSString * cPrice = [[modeljsonArray objectAtIndex:i] objectForKey:@"Price"];
        NSNumber * cPriceLow = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"Price Low"]integerValue]];
        NSNumber * cPriceHigh = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"Price High"]integerValue]];
        NSString * cEngine = [[modeljsonArray objectAtIndex:i] objectForKey:@"Engine"];
        NSString * cTransmission = [[modeljsonArray objectAtIndex:i] objectForKey:@"Transmission"];
        NSString * cDriveType = [[modeljsonArray objectAtIndex:i] objectForKey:@"Drive Type"];
        NSString * cHorsepower = [[modeljsonArray objectAtIndex:i] objectForKey:@"Horsepower"];
        NSNumber * cHorsepowerLow = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"Horsepower Low"]integerValue]];
        NSNumber * cHorsepowerHigh = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"Horsepower High"]integerValue]];
        NSString * cZeroToSixty = [[modeljsonArray objectAtIndex:i] objectForKey:@"0-60"];
        NSNumber * cZeroToSixtyLow = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"0-60 Low"]doubleValue]];
        NSNumber * cZeroToSixtyHigh = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"0-60 High"]doubleValue]];
        NSString * cTopSpeed = [[modeljsonArray objectAtIndex:i] objectForKey:@"Top Speed (mph)"];
        NSString * cWeight = [[modeljsonArray objectAtIndex:i] objectForKey:@"Weight (lbs)"];
        NSString * cFuelEconomy = [[modeljsonArray objectAtIndex:i] objectForKey:@"Fuel Economy (mpg)"];
        NSNumber * cFuelEconomyLow = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"FE Low"]integerValue]];
        NSNumber * cFuelEconomyHigh = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"FE High"]integerValue]];
        NSString * cURL = [[modeljsonArray objectAtIndex:i] objectForKey:@"Image URL"];
        NSString * cWebsite = [[modeljsonArray objectAtIndex:i]objectForKey:@"Make Link"];
        NSString * cFullName = [NSString stringWithFormat:@"%@%@%@",cMake,@" ",cModel];
        NSString * cExhaust = [[modeljsonArray objectAtIndex:i] objectForKey:@"ExhaustSound"];
        
        //Add object to array
        [modelArray addObject:[[Model alloc]initWithCarMake:cMake andCarModel:cModel andCarYearsMade:cYearsMade andCarPrice:cPrice andCarPriceLow:cPriceLow andCarPriceHigh:cPriceHigh andCarEngine:cEngine andCarTransmission:cTransmission andCarDriveType:cDriveType andCarHorsepower:cHorsepower andCarHorsepowerLow:cHorsepowerLow andCarHorsepowerHigh:cHorsepowerHigh andCarZeroToSixty:cZeroToSixty andCarZeroToSixtyLow:cZeroToSixtyLow andCarZeroToSixtyHigh:cZeroToSixtyHigh andCarTopSpeed:cTopSpeed andCarWeight:cWeight andCarFuelEconomy:cFuelEconomy andCarFuelEconomyLow:cFuelEconomyLow andCarFuelEconomyHigh:cFuelEconomyHigh andCarImageURL:cURL andCarWebsite:cWebsite andCarFullName:cFullName andCarExhaust:cExhaust]];
    }
}

- (void) retrieveMakeImageData;
{
    NSURL * makeurl = [NSURL URLWithString:getMakeDataURL];
    NSData * makedata = [NSData dataWithContentsOfURL:makeurl];
    
    makejsonArray = [NSJSONSerialization JSONObjectWithData:makedata options:kNilOptions error:nil];
    makeimageArray = [[NSMutableArray alloc]init];
    
    NSSortDescriptor * alphasort = [NSSortDescriptor sortDescriptorWithKey:@"Make" ascending:YES];
    AlphabeticalArray = [makejsonArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphasort]];
    
    for (int i = 0; i < AlphabeticalArray.count; i++)
    {
        NSString * mName = [[AlphabeticalArray objectAtIndex:i] objectForKey:@"Make"];
        
        [makeimageArray addObject:mName];
    }
    NSString * defaultrow = @"Select a Make";
    [makeimageArray insertObject:defaultrow atIndex:0];
}

- (void) retrieveMakeImageData2;
{
    NSURL * makeurl = [NSURL URLWithString:getMakeDataURL];
    NSData * makedata = [NSData dataWithContentsOfURL:makeurl];
    
    makejsonArray2 = [NSJSONSerialization JSONObjectWithData:makedata options:kNilOptions error:nil];
    
    //set up the makes array
    makeimageArray2 = [[NSMutableArray alloc]init];
    
    NSSortDescriptor * alphasort = [NSSortDescriptor sortDescriptorWithKey:@"Make" ascending:YES];
    AlphabeticalArray2 = [makejsonArray2 sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphasort]];
    
    for (int i = 0; i < makejsonArray2.count; i++)
    {
        //Create the MakeImage object
        NSString * mName = [[AlphabeticalArray2 objectAtIndex:i] objectForKey:@"Make"];
        NSString * mImageURL = [[AlphabeticalArray2 objectAtIndex:i] objectForKey:@"ImageURL"];
        [makeimageArray2 addObject:[[Make alloc]initWithMakeName:mName andMakeImageURL:mImageURL]];
    }
}

- (void) retrievenewsData;
{
    NSURL * url = [NSURL URLWithString:getNewsDataURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    newsjsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    //Set up our cities arrray
    newsArray = [[NSMutableArray alloc] init];
    
    //Loop through ourjsonArray
    for (int i=0; i < newsjsonArray.count; i++)
    {
        //Create our city object
        NSString * nTitle = [[newsjsonArray objectAtIndex:i] objectForKey:@"Title"];
        NSString * nImageURL = [[newsjsonArray objectAtIndex:i] objectForKey:@"ImageURL"];
        NSString * nDescription = [[newsjsonArray objectAtIndex:i] objectForKey:@"Description"];
        NSString * nArticle = [[newsjsonArray objectAtIndex:i] objectForKey:@"Article"];
        NSString * nDate = [[newsjsonArray objectAtIndex:i] objectForKey:@"Date/Name"];
        NSString * nArticleURL = [[newsjsonArray objectAtIndex:i] objectForKey:@"articleURL"];
        
        //Add the city object to our cities array
        [newsArray addObject:[[News alloc]initWithNewsTitle:nTitle andNewsImageURL:nImageURL andNewsDescription:nDescription andNewsArticle:nArticle andNewsDate:nDate andNewsArticleURL:nArticleURL]];
    }
}

- (void) retrieveTopTensData;
{
    NSURL * url = [NSURL URLWithString:getTopTensDataURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    topTensjson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    toptensArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i < topTensjson.count; i++)
    {
        NSString * nRank = [[topTensjson objectAtIndex:i] objectForKey:@"Rank"];
        NSString * nName = [[topTensjson objectAtIndex:i] objectForKey:@"Car Name"];
        NSString * nValue = [[topTensjson objectAtIndex:i] objectForKey:@"Value"];
        NSString * nURL = [[topTensjson objectAtIndex:i] objectForKey:@"ImageURL"];
        NSString * nType = [[topTensjson objectAtIndex:i] objectForKey:@"TopTenType"];
        
        [toptensArray addObject:[[TopTens alloc]initWithCarRank:nRank andCarName:nName andCarValue:nValue andCarURL:nURL andTopTenType:nType]];
    }
}

- (void) splitTopTensArrays;
{
    NSURL * url = [NSURL URLWithString:getTopTensDataURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    topTensjson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
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

@end
