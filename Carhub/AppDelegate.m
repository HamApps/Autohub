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
#import "HomePageMedia.h"
#import "Currency.h"
#define k_Save @"Saveitem"
#import "TopTensViewController.h"
#import "TopTensViewController2.h"
#define getModelDataURL @"http://www.pl0x.net/CarHubJSON4.php"
#define getMakeDataURL @"http://pl0x.net/CarMakesJSON.php"
#define getNewsDataURL @"http://pl0x.net/CarNewsJSON.php"
#define getTopTensDataURL @"http://pl0x.net/CombinedTopTens.php"
#define getRaceTypeDataURL1 @"http://pl0x.net/RaceTypeJSON.php"
#define getRaceListDataURL @"http://pl0x.net/RaceListJSON.php"
#define getRaceResultsDataURL @"http://pl0x.net/RaceResultsJSON.php"
#define getHomePageDataURL @"http://pl0x.net/HomePageJSON.php"
#define getCurrencyDataURL @"http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json"
#import "CheckInternet.h"

@implementation AppDelegate

@synthesize favoritesarray, modelArray, modeljsonArray, makeimageArray, makejsonArray, AlphabeticalArray, newsArray, newsjsonArray, makeimageArray2, makejsonArray2, AlphabeticalArray2, zt60Array, topspeedArray, nurbArray, newexpensiveArray, fuelArray, horsepowerArray, toptensArray, topTensjson, auctionexpensiveArray, postArray, postjsonArray, raceTypeArray, raceTypejson, raceListArray, raceListjson, formulaOneArray, raceResultsArray, raceResultsjson, wrcArray, nascarArray, fiaArray, indyCarArray, homePageArray, homePagejson, currencyArray, currencyjsonArray, hasLoaded;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if([self isInternetConnectionAvailable] == false)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please check your internet connectivity." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        hasLoaded = NO;
        return NO;
    }
    
    [self retrieveModelData];
    NSLog(@"Done 1");
    [self retrieveMakeImageData];
    NSLog(@"Done 2");
    [self retrievenewsData];
    NSLog(@"Done 3");
    [self retrieveMakeImageData2];
    NSLog(@"Done 4");
    [self splitTopTensArrays];
    NSLog(@"Done 5");
    [self retrieveRaceTypeData];
    NSLog(@"Done 6");
    [self splitRaceArray];
    NSLog(@"Done 7");
    [self retrieveRaceResultsData];
    NSLog(@"Done 8");
    [self retrieveHomePageData];
    NSLog(@"Done 9");
    [self retrieveCurrencyData];
    NSLog(@"Done 10");
    [self setInitialRunSettings];

    
    // show the storyboard
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    int height = [UIScreen mainScreen].bounds.size.height;
    if (height == 480) {
        NSLog(@"storyboard4");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard4" bundle:nil];
        UIViewController *viewController = [storyboard instantiateInitialViewController];
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
    } else if (height == 568) {
        NSLog(@"storyboard5");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *viewController = [storyboard instantiateInitialViewController];
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
    } if (height == 667) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *viewController = [storyboard instantiateInitialViewController];
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
    } if (height == 736) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard6+" bundle:nil];
        UIViewController *viewController = [storyboard instantiateInitialViewController];
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
    }
    
    hasLoaded = YES;
    
    return YES;
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
            NSLog(@"Access Not Available");
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

- (UIStoryboard *)grabStoryboard {
    
    UIStoryboard *storyboard;
    
    // detect the height of our screen
    int height = [UIScreen mainScreen].bounds.size.height;
    UIImage* tabBarBackground = [UIImage imageNamed:@"DarkerTabBarColor.png"];
    [[UINavigationBar appearance] setBackgroundImage:tabBarBackground forBarMetrics:UIBarMetricsDefault];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    if (height == 480) {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard4" bundle:nil];
        // NSLog(@"Device has a 3.5inch Display.");
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        // NSLog(@"Device has a 4inch Display.");
    }
    
    return storyboard;
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
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

-(void)performInitialLoad
{
    [self retrieveModelData];
    NSLog(@"Done 1");
    [self retrieveMakeImageData];
    NSLog(@"Done 2");
    [self retrievenewsData];
    NSLog(@"Done 3");
    [self retrieveMakeImageData2];
    NSLog(@"Done 4");
    [self splitTopTensArrays];
    NSLog(@"Done 5");
    [self retrieveRaceTypeData];
    NSLog(@"Done 6");
    [self splitRaceArray];
    NSLog(@"Done 7");
    [self retrieveRaceResultsData];
    NSLog(@"Done 8");
    [self retrieveHomePageData];
    NSLog(@"Done 9");
    [self retrieveCurrencyData];
    NSLog(@"Done 10");
    [self setInitialRunSettings];
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
        [defaults setObject:@"MPH" forKey:@"Top Speed"];
        [defaults setObject:@"lbs" forKey:@"Weight"];
        [defaults setObject:@"MPG US" forKey:@"Fuel Economy"];
        [defaults setObject:@"Horizontal Scroll" forKey:@"Makes Layout Preference"];
        [defaults synchronize];
    }
}

-(void)retrieveCurrencyData
{
    NSURL * currencyurl = [NSURL URLWithString:getCurrencyDataURL];
    NSData * currencydata = [NSData dataWithContentsOfURL:currencyurl];
    //currencyjsonArray = [NSJSONSerialization JSONObjectWithData:currencydata options:kNilOptions error:nil];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:currencydata options:kNilOptions error:nil];
    NSArray *fetchedArr = [json objectForKey:@"list"];
    fetchedArr = [fetchedArr valueForKey:@"resources"];
    fetchedArr = [fetchedArr valueForKey:@"resource"];
    fetchedArr = [fetchedArr valueForKey:@"fields"];
    
    NSLog(@"currencyjsonarray.count: %@", fetchedArr);
    
    currencyArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < fetchedArr.count; i++)
    {
        //Create the MakeImage object
        NSString * cName = [[fetchedArr objectAtIndex:i] objectForKey:@"name"];
        NSNumber * cRate = [NSNumber numberWithDouble:[[[fetchedArr objectAtIndex:i]objectForKey:@"price"]doubleValue]];
        [currencyArray addObject:[[Currency alloc]initWithCurrencyName:cName andCurrencyRate:cRate]];
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
        NSString * cZeroToSixty = [[modeljsonArray objectAtIndex:i] objectForKey:@"0-60"];
        NSNumber * cZeroToSixtyLow = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"0-60 Low"]doubleValue]];
        NSNumber * cZeroToSixtyHigh = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"0-60 High"]doubleValue]];
        NSString * cTopSpeed = [[modeljsonArray objectAtIndex:i] objectForKey:@"Top Speed (mph)"];
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
        NSNumber * cisClass = [NSNumber numberWithInteger:[[[modeljsonArray objectAtIndex:i]objectForKey:@"isClass"]integerValue]];
        NSNumber * cisSubClass = [NSNumber numberWithInteger:[[[modeljsonArray objectAtIndex:i]objectForKey:@"isSubclass"]integerValue]];
        NSNumber * cisModel = [NSNumber numberWithInteger:[[[modeljsonArray objectAtIndex:i]objectForKey:@"isModel"]integerValue]];
        NSString * cCarClass = [[modeljsonArray objectAtIndex:i] objectForKey:@"CarClass"];
        NSString * cCarSubclass = [[modeljsonArray objectAtIndex:i] objectForKey:@"CarSubclass"];
        NSNumber * cZoomScale = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"Zoom Scale"]doubleValue]];
        NSNumber * cOffsetX = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"Offset X"]doubleValue]];
        NSNumber * cOffsetY = [NSNumber numberWithDouble:[[[modeljsonArray objectAtIndex:i]objectForKey:@"Offset Y"]doubleValue]];
        
        //Add object to array
        
        [modelArray addObject:[[Model alloc]initWithCarMake:cMake andCarModel:cModel andCarYearsMade:cYearsMade andCarMSRP:cMSRP andCarPrice:cPrice andCarPriceLow:cPriceLow andCarPriceHigh:cPriceHigh andCarEngine:cEngine andCarTransmission:cTransmission andCarDriveType:cDriveType andCarHorsepower:cHorsepower andCarHorsepowerLow:cHorsepowerLow andCarHorsepowerHigh:cHorsepowerHigh andCarZeroToSixty:cZeroToSixty andCarZeroToSixtyLow:cZeroToSixtyLow andCarZeroToSixtyHigh:cZeroToSixtyHigh andCarTopSpeed:cTopSpeed andCarWeight:cWeight andCarWeightLow:cWeightLow andCarWeightHigh:cWeightHigh andCarFuelEconomy:cFuelEconomy andCarFuelEconomyLow:cFuelEconomyLow andCarFuelEconomyHigh:cFuelEconomyHigh andCarImageURL:cURL andCarWebsite:cWebsite andCarFullName:cFullName andCarExhaust:cExhaust andCarHTML:cHTML andisClass:cisClass andisSubclass:cisSubClass andisModel:cisModel andCarClass:cCarClass andCarSubclass:cCarSubclass andZoomScale:cZoomScale andOffsetX:cOffsetX andOffsetY:cOffsetY]];
    }
    NSLog(@"modelarray.count %lu", (unsigned long)modelArray.count);
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
    NSString * defaultrow = @"Any";
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
        NSString * mCountry = [[AlphabeticalArray2 objectAtIndex:i] objectForKey:@"Country"];
        [makeimageArray2 addObject:[[Make alloc]initWithMakeName:mName andMakeImageURL:mImageURL andMakeCountry:mCountry]];
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
        NSString * nVideoID = [[newsjsonArray objectAtIndex:i] objectForKey:@"VideoID"];
        NSString * nDescription = [[newsjsonArray objectAtIndex:i] objectForKey:@"Description"];
        NSString * nArticle = [[newsjsonArray objectAtIndex:i] objectForKey:@"Article"];
        NSString * nDate = [[newsjsonArray objectAtIndex:i] objectForKey:@"Date"];
        NSString * nAuthor = [[newsjsonArray objectAtIndex:i] objectForKey:@"Author"];
        NSString * nArticleURL = [[newsjsonArray objectAtIndex:i] objectForKey:@"articleURL"];
        NSString * nImageURL1 = [[newsjsonArray objectAtIndex:i] objectForKey:@"ImageURL1"];
        NSString * nImage1Position = [[newsjsonArray objectAtIndex:i] objectForKey:@"Image1Position"];
        NSNumber * nImage1YPosition = [NSNumber numberWithDouble:[[[newsjsonArray objectAtIndex:i]objectForKey:@"Image1YPosition"]doubleValue]];
        NSNumber * nImage1Width = [NSNumber numberWithDouble:[[[newsjsonArray objectAtIndex:i]objectForKey:@"Image1Width"]doubleValue]];
        NSString * nImageURL2 = [[newsjsonArray objectAtIndex:i] objectForKey:@"ImageURL2"];
        NSString * nImage2Position = [[newsjsonArray objectAtIndex:i] objectForKey:@"Image2Position"];
        NSNumber * nImage2YPosition = [NSNumber numberWithDouble:[[[newsjsonArray objectAtIndex:i]objectForKey:@"Image2YPosition"]doubleValue]];
        NSNumber * nImage2Width = [NSNumber numberWithDouble:[[[newsjsonArray objectAtIndex:i]objectForKey:@"Image2Width"]doubleValue]];
        NSString * nImageURL3 = [[newsjsonArray objectAtIndex:i] objectForKey:@"ImageURL3"];
        NSString * nImage3Position = [[newsjsonArray objectAtIndex:i] objectForKey:@"Image3Position"];
        NSNumber * nImage3YPosition = [NSNumber numberWithDouble:[[[newsjsonArray objectAtIndex:i]objectForKey:@"Image3YPosition"]doubleValue]];
        NSNumber * nImage3Width = [NSNumber numberWithDouble:[[[newsjsonArray objectAtIndex:i]objectForKey:@"Image3Width"]doubleValue]];
        NSString * nImageURL4 = [[newsjsonArray objectAtIndex:i] objectForKey:@"ImageURL4"];
        NSString * nImage4Position = [[newsjsonArray objectAtIndex:i] objectForKey:@"Image4Position"];
        NSNumber * nImage4YPosition = [NSNumber numberWithDouble:[[[newsjsonArray objectAtIndex:i]objectForKey:@"Image4YPosition"]doubleValue]];
        NSNumber * nImage4Width = [NSNumber numberWithDouble:[[[newsjsonArray objectAtIndex:i]objectForKey:@"Image4Width"]doubleValue]];
        NSString * nImageURL5 = [[newsjsonArray objectAtIndex:i] objectForKey:@"ImageURL5"];
        NSString * nImage5Position = [[newsjsonArray objectAtIndex:i] objectForKey:@"Image5Position"];
        NSNumber * nImage5YPosition = [NSNumber numberWithDouble:[[[newsjsonArray objectAtIndex:i]objectForKey:@"Image5YPosition"]doubleValue]];
        NSNumber * nImage5Width = [NSNumber numberWithDouble:[[[newsjsonArray objectAtIndex:i]objectForKey:@"Image5Width"]doubleValue]];
        
        [newsArray addObject:[[News alloc]initWithNewsTitle:nTitle andNewsImageURL:nImageURL andNewsVideoID:nVideoID andNewsDescription:nDescription andNewsArticle:nArticle andNewsDate:nDate andNewsAuthor:nAuthor andNewsArticleURL:nArticleURL andNewsImageURL1:nImageURL1 andNewsImage1Position:nImage1Position andNewsImage1YPosition:nImage1YPosition andNewsImage1Width:nImage1Width andNewsImageURL2:nImageURL2 andNewsImage2Position:nImage2Position andNewsImage2YPosition:nImage2YPosition andNewsImage2Width:nImage2Width andNewsImageURL3:nImageURL3 andNewsImage3Position:nImage3Position andNewsImage3YPosition:nImage3YPosition andNewsImage3Width:nImage3Width andNewsImageURL4:nImageURL4 andNewsImage4Position:nImage4Position andNewsImage4YPosition:nImage4YPosition andNewsImage4Width:nImage4Width andNewsImageURL5:nImageURL5 andNewsImage5Position:nImage5Position andNewsImage5YPosition:nImage5YPosition andNewsImage5Width:nImage5Width]];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void) retrieveRaceTypeData;
{
    NSURL * url = [NSURL URLWithString:getRaceTypeDataURL1];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    raceTypejson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    //Set up our arrray
    raceTypeArray = [[NSMutableArray alloc] init];
    
    //Loop through ourjsonArray
    for (int i=0; i < raceTypejson.count; i++)
    {
        //Create our city object
        NSString * nRaceType = [[raceTypejson objectAtIndex:i] objectForKey:@"RaceType"];
        NSString * nImageURL = [[raceTypejson objectAtIndex:i] objectForKey:@"ImageURL"];
        
        //Add the city object to our cities array
        [raceTypeArray addObject:[[RaceType alloc]initWithRaceType:nRaceType andTypeImageURL:nImageURL]];
    }
}

- (void) splitRaceArray;
{
    NSURL * url = [NSURL URLWithString:getRaceListDataURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    raceListjson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    raceListArray = [[NSMutableArray alloc]init];
    formulaOneArray = [[NSMutableArray alloc]init];
    nascarArray = [[NSMutableArray alloc]init];
    indyCarArray = [[NSMutableArray alloc]init];
    wrcArray = [[NSMutableArray alloc]init];
    fiaArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i < raceListjson.count; i++)
    {
        NSString * nRaceName = [[raceListjson objectAtIndex:i] objectForKey:@"RaceName"];
        NSString * nImageURL = [[raceListjson objectAtIndex:i] objectForKey:@"RaceImageURL"];
        NSString * nRaceType = [[raceListjson objectAtIndex:i] objectForKey:@"RaceType"];
        NSString * nResultsImageURL1 = [[raceListjson objectAtIndex:i] objectForKey:@"ResultsImageURL1"];
        NSString * nResultsImageURL2 = [[raceListjson objectAtIndex:i] objectForKey:@"ResultsImageURL2"];
        NSString * nResultsImageURL3 = [[raceListjson objectAtIndex:i] objectForKey:@"ResultsImageURL3"];
        NSString * nResultsImageURL4 = [[raceListjson objectAtIndex:i] objectForKey:@"ResultsImageURL4"];
        
        if([nRaceType isEqualToString:@"Formula 1"]){
            [formulaOneArray addObject:[[Race alloc]initWithRaceName:nRaceName andTypeImageURL:nImageURL andRaceType:nRaceType andResultsImageURL1:nResultsImageURL1 andResultsImageURL2:nResultsImageURL2 andResultsImageURL3:nResultsImageURL3 andResultsImageURL4:nResultsImageURL4]];
            [raceListArray addObject:[[Race alloc]initWithRaceName:nRaceName andTypeImageURL:nImageURL andRaceType:nRaceType andResultsImageURL1:nResultsImageURL1 andResultsImageURL2:nResultsImageURL2 andResultsImageURL3:nResultsImageURL3 andResultsImageURL4:nResultsImageURL4]];
        }
        if([nRaceType isEqualToString:@"Nascar"]){
            [nascarArray addObject:[[Race alloc]initWithRaceName:nRaceName andTypeImageURL:nImageURL andRaceType:nRaceType andResultsImageURL1:nResultsImageURL1 andResultsImageURL2:nResultsImageURL2 andResultsImageURL3:nResultsImageURL3 andResultsImageURL4:nResultsImageURL4]];
            [raceListArray addObject:[[Race alloc]initWithRaceName:nRaceName andTypeImageURL:nImageURL andRaceType:nRaceType andResultsImageURL1:nResultsImageURL1 andResultsImageURL2:nResultsImageURL2 andResultsImageURL3:nResultsImageURL3 andResultsImageURL4:nResultsImageURL4]];
        }
        if([nRaceType isEqualToString:@"IndyCar"]){
            [indyCarArray addObject:[[Race alloc]initWithRaceName:nRaceName andTypeImageURL:nImageURL andRaceType:nRaceType andResultsImageURL1:nResultsImageURL1 andResultsImageURL2:nResultsImageURL2 andResultsImageURL3:nResultsImageURL3 andResultsImageURL4:nResultsImageURL4]];
            [raceListArray addObject:[[Race alloc]initWithRaceName:nRaceName andTypeImageURL:nImageURL andRaceType:nRaceType andResultsImageURL1:nResultsImageURL1 andResultsImageURL2:nResultsImageURL2 andResultsImageURL3:nResultsImageURL3 andResultsImageURL4:nResultsImageURL4]];
        }
        if([nRaceType isEqualToString:@"FIA World Endurance Championships"]){
            [fiaArray addObject:[[Race alloc]initWithRaceName:nRaceName andTypeImageURL:nImageURL andRaceType:nRaceType andResultsImageURL1:nResultsImageURL1 andResultsImageURL2:nResultsImageURL2 andResultsImageURL3:nResultsImageURL3 andResultsImageURL4:nResultsImageURL4]];
            [raceListArray addObject:[[Race alloc]initWithRaceName:nRaceName andTypeImageURL:nImageURL andRaceType:nRaceType andResultsImageURL1:nResultsImageURL1 andResultsImageURL2:nResultsImageURL2 andResultsImageURL3:nResultsImageURL3 andResultsImageURL4:nResultsImageURL4]];
        }
        if([nRaceType isEqualToString:@"WRC"]){
            [wrcArray addObject:[[Race alloc]initWithRaceName:nRaceName andTypeImageURL:nImageURL andRaceType:nRaceType andResultsImageURL1:nResultsImageURL1 andResultsImageURL2:nResultsImageURL2 andResultsImageURL3:nResultsImageURL3 andResultsImageURL4:nResultsImageURL4]];
            [raceListArray addObject:[[Race alloc]initWithRaceName:nRaceName andTypeImageURL:nImageURL andRaceType:nRaceType andResultsImageURL1:nResultsImageURL1 andResultsImageURL2:nResultsImageURL2 andResultsImageURL3:nResultsImageURL3 andResultsImageURL4:nResultsImageURL4]];
        }
    }
}

- (void) retrieveRaceResultsData;
{
    NSURL * url = [NSURL URLWithString:getRaceResultsDataURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    raceResultsjson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    //Set up our arrray
    raceResultsArray = [[NSMutableArray alloc] init];
    
    //Loop through ourjsonArray
    for (int i=0; i < raceResultsjson.count; i++)
    {
        //Create our city object
        NSString * nPosition = [[raceResultsjson objectAtIndex:i] objectForKey:@"Position"];
        NSString * nDriver = [[raceResultsjson objectAtIndex:i] objectForKey:@"Driver"];
        NSString * nTeam = [[raceResultsjson objectAtIndex:i] objectForKey:@"Team"];
        NSString * nCountry = [[raceResultsjson objectAtIndex:i] objectForKey:@"Country"];
        NSString * nCar = [[raceResultsjson objectAtIndex:i] objectForKey:@"Car"];
        NSString * nTime = [[raceResultsjson objectAtIndex:i] objectForKey:@"Time"];
        NSString * nBestLapTime = [[raceResultsjson objectAtIndex:i] objectForKey:@"BestLapTime"];
        NSString * nRaceClass = [[raceResultsjson objectAtIndex:i]objectForKey:@"Class"];
        NSString * nRaceID = [[raceResultsjson objectAtIndex:i] objectForKey:@"RaceID"];
        
        //Add the city object to our cities array
        [raceResultsArray addObject:[[RaceResult alloc]initWithPosition:nPosition andDriver:nDriver andTeam:nTeam andCountry:nCountry andCar:nCar andTime:nTime andBestLapTime:nBestLapTime andRaceClass:nRaceClass andRaceID:nRaceID]];
    }
    NSLog(@"raceresults: %@", raceResultsArray);
    NSLog(@"raceresults.count: %lu", (unsigned long)raceResultsArray.count);

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

- (void) retrieveHomePageData;
{
    NSURL * homepagedataurl = [NSURL URLWithString:getHomePageDataURL];
    NSData * homepagedata = [NSData dataWithContentsOfURL:homepagedataurl];
    
    homePagejson = [NSJSONSerialization JSONObjectWithData:homepagedata options:kNilOptions error:nil];
    homePageArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < homePagejson.count; i++)
    {
        NSString * nImageURL = [[homePagejson objectAtIndex:i] objectForKey:@"ImageURL"];
        NSString * nImageURL2 = [[homePagejson objectAtIndex:i] objectForKey:@"ImageURL2"];
        NSString * nImageURL3 = [[homePagejson objectAtIndex:i] objectForKey:@"ImageURL3"];
        NSString * nImageURL4 = [[homePagejson objectAtIndex:i] objectForKey:@"ImageURL4"];
        NSString * nCarHTML = [[homePagejson objectAtIndex:i] objectForKey:@"CarHTML"];
        NSString * nDescription = [[homePagejson objectAtIndex:i] objectForKey:@"Description"];
        NSString * nSpecType1 = [[homePagejson objectAtIndex:i] objectForKey:@"SpecType1"];
        NSString * nSpecLabel1 = [[homePagejson objectAtIndex:i] objectForKey:@"SpecLabel1"];
        NSString * nSpecType2 = [[homePagejson objectAtIndex:i] objectForKey:@"SpecType2"];
        NSString * nSpecLabel2 = [[homePagejson objectAtIndex:i] objectForKey:@"SpecLabel2"];
        NSString * nMediaType = [[homePagejson objectAtIndex:i] objectForKey:@"MediaType"];
        
        [homePageArray addObject:[[HomePageMedia alloc] initWithImageURL:nImageURL andImageURL2:nImageURL2 andImageURL3:nImageURL3 andImageURL4:nImageURL4 andCarHTML:nCarHTML andDescription:nDescription andSpecType1:nSpecType1 andSpecLabel1:nSpecLabel1 andSpecType2:nSpecType2 andSpecLabel2:nSpecLabel2 andMediaType:nMediaType]];
    }
    HomePageMedia *media = [homePageArray objectAtIndex:0];
    
    NSLog(@"homepagearray: %@", media.ImageURL2);
}
@end
