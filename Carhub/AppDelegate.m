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
#define k_Save @"Saveitem"
#import "TopTensViewController.h"
#import "TopTensViewController2.h"
#define getModelDataURL @"http://pl0x.net/CarHubJSON2.php"
#define getMakeDataURL @"http://pl0x.net/CarMakesJSON.php"
#define getNewsDataURL @"http://pl0x.net/CarNewsJSON.php"

@implementation AppDelegate

@synthesize favoritesarray, modelArray, modeljsonArray, makeimageArray, makejsonArray, AlphabeticalArray, newsArray, newsjsonArray, makeimageArray2, makejsonArray2, AlphabeticalArray2;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIStoryboard *storyboard = [self grabStoryboard];
    
    [self retrieveModelData];
    [self retrieveMakeImageData];
    [self retrievenewsData];
    [self retrieveMakeImageData2];
    
    // show the storyboard
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    [self.window makeKeyAndVisible];
    
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool saved = [defaults boolForKey:k_Save];
    
    if (!saved){
        //not saved code here
    } else {
        //saved code here
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        
        int height = [UIScreen mainScreen].bounds.size.height;
        
        if (height == 480) {
        
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard4" bundle:nil];
        
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"IAP"]; // determine the initial view controller here and instantiate it with [storyboard instantiateViewControllerWithIdentifier:<storyboard id>];
        
            self.window.rootViewController = viewController;
            [self.window makeKeyAndVisible];
        } else {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"IAP2"];
            self.window.rootViewController = viewController;
            [self.window makeKeyAndVisible];
        }
    }
    
    return YES;
    return YES;
}

- (UIStoryboard *)grabStoryboard {
    
    UIStoryboard *storyboard;
    
    // detect the height of our screen
    int height = [UIScreen mainScreen].bounds.size.height;
    
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
    
    TopTensViewController * toptens1 = [[TopTensViewController alloc]init];
    [toptens1 disableAds];
    TopTensViewController2 * toptens2 = [[TopTensViewController2 alloc]init];
    [toptens2 disableAds];
    
    if (height == 480) {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard4" bundle:nil];
    
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"IAP"]; // determine the initial view controller here
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:TRUE forKey:k_Save];
    [defaults synchronize];
    } else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"IAP2"]; // determine the initial view controller here
            
            self.window.rootViewController = viewController;
            [self.window makeKeyAndVisible];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:TRUE forKey:k_Save];
            [defaults synchronize];
    }
    
}

- (void) retrieveModelData;
{
    NSURL * modelurl = [NSURL URLWithString:getModelDataURL];
    NSData * modeldata = [NSData dataWithContentsOfURL:modelurl];
    
    modeljsonArray = [NSJSONSerialization JSONObjectWithData:modeldata options:kNilOptions error:nil];
    
    //Set up our cities arrray
    modelArray = [[NSMutableArray alloc] init];
    
    //Loop through ourjsonArray
    for (int i=0; i < modeljsonArray.count; i++)
    {
        //Create our city object
        NSString * cMake = [[modeljsonArray objectAtIndex:i] objectForKey:@"Make"];
        NSString * cModel = [[modeljsonArray objectAtIndex:i] objectForKey:@"Model"];
        NSString * cYearsMade = [[modeljsonArray objectAtIndex:i] objectForKey:@"Years Made"];
        NSString * cPrice = [[modeljsonArray objectAtIndex:i] objectForKey:@"Price"];
        NSString * cEngine = [[modeljsonArray objectAtIndex:i] objectForKey:@"Engine"];
        NSString * cTransmission = [[modeljsonArray objectAtIndex:i] objectForKey:@"Transmission"];
        NSString * cDriveType = [[modeljsonArray objectAtIndex:i] objectForKey:@"Drive Type"];
        NSString * cHorsepower = [[modeljsonArray objectAtIndex:i] objectForKey:@"Horsepower"];
        NSString * cZeroToSixty = [[modeljsonArray objectAtIndex:i] objectForKey:@"0-60"];
        NSString * cTopSpeed = [[modeljsonArray objectAtIndex:i] objectForKey:@"Top Speed (mph)"];
        NSString * cWeight = [[modeljsonArray objectAtIndex:i] objectForKey:@"Weight (lbs)"];
        NSString * cFuelEconomy = [[modeljsonArray objectAtIndex:i] objectForKey:@"Fuel Economy (mpg)"];
        NSString * cURL = [[modeljsonArray objectAtIndex:i] objectForKey:@"Image URL"];
        NSString * cWebsite = [[modeljsonArray objectAtIndex:i]objectForKey:@"Make Link"];
        
        
        //Add the city object to our cities array
        [modelArray addObject:[[Model alloc]initWithCarMake:cMake andCarModel:cModel andCarYearsMade:cYearsMade andCarPrice:cPrice andCarEngine:cEngine andCarTransmission:cTransmission andCarDriveType:cDriveType andCarHorsepower:cHorsepower andCarZeroToSixty:cZeroToSixty andCarTopSpeed:cTopSpeed andCarWeight:cWeight andCarFuelEconomy:cFuelEconomy andCarImageURL:cURL andCarWebsite:cWebsite]];
        
    }
    NSLog(@"appdelarray: %@", modelArray);
    
}

- (void) retrieveMakeImageData;
{
    NSURL * makeurl = [NSURL URLWithString:getMakeDataURL];
    NSData * makedata = [NSData dataWithContentsOfURL:makeurl];
    
    makejsonArray = [NSJSONSerialization JSONObjectWithData:makedata options:kNilOptions error:nil];
    
    //set up the makes array
    makeimageArray = [[NSMutableArray alloc]init];
    
    NSSortDescriptor * alphasort = [NSSortDescriptor sortDescriptorWithKey:@"Make" ascending:YES];
    AlphabeticalArray = [makejsonArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphasort]];
    
    //Loop through our makejsonArray
    for (int i = 0; i < AlphabeticalArray.count; i++)
    {
        //Create the MakeImage object
        NSString * mName = [[AlphabeticalArray objectAtIndex:i] objectForKey:@"Make"];
        
        //Add the MakeImage object to the MakeImage array
        NSLog(@"mname %@", mName);
        
        [makeimageArray addObject:mName];
    }
    NSString * defaultrow = @"Select a Make";
    [makeimageArray insertObject:defaultrow atIndex:0];
    
    NSLog(@"makeimagearrayappdel: %@", makeimageArray);
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
    
    //Loop through our makejsonArray
    for (int i = 0; i < makejsonArray2.count; i++)
    {
        //Create the MakeImage object
        NSString * mName = [[AlphabeticalArray2 objectAtIndex:i] objectForKey:@"Make"];
        NSString * mImageURL = [[AlphabeticalArray2 objectAtIndex:i] objectForKey:@"ImageURL"];
        
        //Add the MakeImage object to the MakeImage array
        
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
        
        //Add the city object to our cities array
        [newsArray addObject:[[News alloc]initWithNewsTitle:nTitle andNewsImageURL:nImageURL andNewsDescription:nDescription andNewsArticle:nArticle]];
    }
}



@end
