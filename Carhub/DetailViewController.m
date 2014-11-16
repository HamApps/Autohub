//
//  DetailViewController.m
//  Carhub
//
//  Created by Christopher Clark on 7/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "DetailViewController.h"
#import "BackgroundLayer.h"
#import "CompareViewController.h"
#import "AppDelegate.h"
#import "FavoritesViewController.h"
#import "FavoritesClass.h"
#import "TopTensViewController.h"
#import "Model.h"

#define kNSUSERDEFAULTSCAR @"nsuserdefaultscar"

#define DELEGATE ((AppDelegate*)[[UIApplication sharedApplication]delegate])

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize currentCararray, delegate, favoritesArray;

- (AppDelegate *) appdelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

@synthesize CarMakeLabel, CarModelLabel, CarYearsMadeLabel, CarPriceLabel, CarEngineLabel, CarTransmissionLabel, CarDriveTypeLabel, CarHorsepowerLabel, CarZeroToSixtyLabel, CarTopSpeedLabel, CarWeightLabel, CarFuelEconomyLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog (@"usercars: %@", [defaults objectForKey:@"savedcar"]);
    
    optionsSingle = [FavoritesClass favoritecars];
    NSLog (@"favoritesclassarray%@", optionsSingle.favoritearray);
    
    
    
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 568)];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"Metal Background.jpg"]];
    
    
    NSString * makewithspace = [_currentCar.CarMake stringByAppendingString:@" "];
    NSString * detailtitle = [makewithspace stringByAppendingString:_currentCar.CarModel];
    self.title = detailtitle;
    
    //NSLog(@"%@", _);
    if (!currentCararray){
    self.currentCararray = [[NSMutableArray alloc]init];
    [self.currentCararray addObject:_currentCar];
    }
    
    if (imageview.image ==nil) {

    dispatch_async(kBgQueue, ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_currentCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]];
        if (imgData) {
            UIImage *image = [UIImage imageWithData:imgData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageview.image = image;
                    [UIImageView beginAnimations:nil context:NULL];
                    [UIImageView setAnimationDuration:.75];
                    [imageview setAlpha:1.0];
                    [UIImageView commitAnimations];
                });
            }
        }
    });
    }

    
    NSLog(@"currentcararray%@", currentCararray);
    
    // Do any additional setup after loading the view.
                
    //Load up the UI
    [self setLabels];
}
                               
                               




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Methods

- (void)getModel:(id)modelObject;
{
    _currentCar = modelObject;
}

- (void)getfirstModel:(id)firstcarObject3;
{
    _firstCar3 = firstcarObject3;
}

- (void)getsecondModel:(id)secondcarObject3;
{
    _secondCar3 = secondcarObject3;
}

- (void)writeFavoriteObject:(Model *)favorite
{
    NSData *favoriteObject = [NSKeyedArchiver archivedDataWithRootObject:favorite];
    [[NSUserDefaults standardUserDefaults] setObject:favoriteObject forKey:kNSUSERDEFAULTSCAR];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (Model *)readFavoriteObjectWithKey:(NSString *)key
{
    NSData *favoriteobject = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    Model *favorite = [NSKeyedUnarchiver unarchiveObjectWithData:favoriteobject];
    return favorite;
}

- (IBAction)_sendtoFavorites {
    Model *favorite = [[Model alloc]init];
    favorite = _currentCar;
    NSLog (@"favorite%@", favorite);

    [self writeFavoriteObject:favorite];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog (@"keyedcar: %@", [defaults objectForKey:kNSUSERDEFAULTSCAR]);
    
    //NSData *favoritedata = [defaults objectForKey:kNSUSERDEFAULTSCAR];
    
    favoritesArray = [[NSMutableArray alloc]init];
    favoritesArray = [defaults objectForKey:@"favoritesarray"];
    if (favoritesArray != nil){
        [favoritesArray addObject:[defaults objectForKey:kNSUSERDEFAULTSCAR]];
        NSLog (@"favoritesarraybefore: %@", favoritesArray);
        [defaults setObject:favoritesArray forKey:@"favoritesarray"];
        NSLog (@"defaultsarray: %@", [defaults objectForKey:@"favoritesarray"]);
    }else{
    favoritesArray = [defaults objectForKey:@"favoritesarray"];
    [favoritesArray addObject:[defaults objectForKey:kNSUSERDEFAULTSCAR]];
    NSLog (@"favoritesarraymeow: %@", favoritesArray);
    [defaults setObject:favoritesArray forKey:@"favoritesarray"];
        NSLog (@"defaultsarray: %@", [defaults objectForKey:@"favoritesarray"]);
    }
}




- (void)setLabels
{
    CarMakeLabel.text = _currentCar.CarMake;
    CarModelLabel.text = _currentCar.CarModel;
    CarYearsMadeLabel.text = _currentCar.CarYearsMade;
    CarPriceLabel.text = _currentCar.CarPrice;
    CarEngineLabel.text = _currentCar.CarEngine;
    CarTransmissionLabel.text= _currentCar.CarTransmission;
    CarDriveTypeLabel.text = _currentCar.CarDriveType;
    CarHorsepowerLabel.text = _currentCar.CarHorsepower;
    CarZeroToSixtyLabel.text = _currentCar.CarZeroToSixty;
    CarTopSpeedLabel.text = _currentCar.CarTopSpeed;
    CarWeightLabel.text = _currentCar.CarWeight;
    CarFuelEconomyLabel.text = _currentCar.CarFuelEconomy;
    
}


 #pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"pushCompareView"])
    {
        //Get the object for the selected row
        Model * firstcarobject = _currentCar;
        [[segue destinationViewController] getfirstModel:firstcarobject];
        Model * secondcarobject = _secondCar3;
        [[segue destinationViewController] getsecondModel:secondcarobject];
    }
    if ([[segue identifier] isEqualToString:@"pushCompareView2"])
    {
        //Get the object
        Model * secondcarobject = _currentCar;
        [[segue destinationViewController] getsecondModel:secondcarobject];
        Model * firstcarobject = _firstCar3;
        [[segue destinationViewController] getfirstModel:firstcarobject];
    }
    if ([[segue identifier] isEqualToString:@"pushimageview"])
    {
        //Get the object
        Model * firstcarobject = _currentCar;
        [[segue destinationViewController] getfirstModel:firstcarobject];
    }
    if ([[segue identifier] isEqualToString:@"pushfavorites"])
    {
        //Get the object
        Model * firstcarobject = _currentCar;
        [[segue destinationViewController] getfirstModel:firstcarobject];
    }

    
}

-(IBAction)Website
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:_currentCar.CarWebsite]];
    NSLog(@"website: %@", _currentCar.CarWebsite);
}

#pragma mark iAd Delegate Methods

@end