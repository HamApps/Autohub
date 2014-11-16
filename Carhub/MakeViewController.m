//
//  MakeViewController.m
//  Carhub
//
//  Created by Christopher Clark on 8/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "AppDelegate.h"
#import "MakeViewController.h"
#import "MakeCell.h"
#import "BackgroundLayer.h"
#import "Make.h"
#import "Model.h"
#import "ModelViewController.h"
#import <QuartzCore/QuartzCore.h>

#define getMakeDataURL @"http://pl0x.net/CarMakesJSON.php"
#define getModelDataURL @"http://pl0x.net/CarHubJSON2.php"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface MakeViewController ()

@end

@implementation MakeViewController
@synthesize makejsonArray, makeimageArray, currentMake, modelArray, modeljsonArray, filteredArray, AlphabeticalArray, cachedImages, appdelmodelArray;

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
    self.cachedImages = [[NSMutableDictionary alloc]init];
    // Set a title for the view controller
    self.title = @"Makes";
    
    //Load the MakeImage Data
    //[self retrieveMakeImageData];
    //[self retrieveModelData];
    [self makeAppDelModelArray];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"Metal Background.jpg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return makeimageArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MakeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MakeReuseID" forIndexPath:indexPath];
    
    Make * makeObject;
    makeObject = [makeimageArray objectAtIndex:indexPath.item];
    
    NSString *identifier = [NSString stringWithFormat:@"MakeReuseID%ld" , (long)indexPath.row];
    
    
    cell.layer.borderWidth=0.7f;
    cell.layer.borderColor=[UIColor whiteColor].CGColor;
    //cell.layer.cornerRadius = 10;
    
    cell.MakeNameLabel.text =makeObject.MakeName;


    //NSString *identifier = [NSString stringWithFormat:@"MakeReuseID%d", indexPath.row];
    
    cell.MakeImageView.image = [self.cachedImages valueForKey:identifier];
    
    if([self.cachedImages objectForKey:identifier] !=nil){
        cell.MakeImageView.image = [self.cachedImages valueForKey:identifier];

    }else{
    
        char const*s = [identifier UTF8String];
            dispatch_queue_t queue = dispatch_queue_create(s, 0);
        
            dispatch_async(queue, ^{
                NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:makeObject.MakeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image2.php"]]];
                if (imgData) {
                    UIImage *image = [UIImage imageWithData:imgData];
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            MakeCell *updateCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
                            if (updateCell)
                            {
                                
                                updateCell.MakeImageView.image = image;

                                [self.cachedImages setValue:image forKey:identifier];
                                updateCell.MakeImageView.image = [self.cachedImages valueForKey:identifier];
                                [UIImageView beginAnimations:nil context:NULL];
                                [UIImageView setAnimationDuration:.75];
                                [updateCell.MakeImageView setAlpha:1.0];
                                [UIImageView commitAnimations];
                                
                        
                                
                                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                //[defaults setObject:UIImagePNGRepresentation(image) forKey:@"cacheimagedata"];
                                //[defaults setObject:UIImageJPEGRepresentation(image, 1) forKey:@"cacheimagedata"];
                                //NSData *imgData = [NSKeyedArchiver archivedDataWithRootObject:image];
                                //NSData *imagedata = [[NSUserDefaults standardUserDefaults] objectForKey:@"cacheimagedata"];
                                //cell.MakeImageView.image = [UIImage imageWithData:imgData];
                                
                                
                                [defaults synchronize];
                            }
                        });
                    }
                }
            });
    }
    
    return cell;
}

- (void)getfirstModel:(id)firstcarObject1;
{
    _firstCar1 = firstcarObject1;
}

- (void)getsecondModel:(id)secondcarObject1;
{
    _secondCar1 = secondcarObject1;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Get the new view controller using [seguedestinationviewcontroller]
    if ([[segue identifier] isEqualToString:@"pushModelView"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
        [[segue destinationViewController] getmodelarray:modelArray];

        NSIndexPath * indexPath = [self.collectionView indexPathForCell:sender];
        Make * makeobject = [makeimageArray objectAtIndex:indexPath.row];
        //Make * modelobject = currentMake;
        [[segue destinationViewController] getMake:makeobject];
    }
}

// Pass the selected object to the new view controller.


- (void) makeAppDelModelArray;
{
    appdelmodelArray = [[NSMutableArray alloc]init];
    makeimageArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"appdelarray2: %@", appdel.modelArray);
    [appdelmodelArray addObjectsFromArray:appdel.modelArray];
    NSLog(@"appdelarray3: %@", appdelmodelArray);
    
    makeimageArray = [[NSMutableArray alloc]init];
    [makeimageArray addObjectsFromArray:appdel.makeimageArray2];
}

#pragma mark -
#pragma mark Class Methods

/*- (void) retrieveModelData;
{
    NSURL * modelurl = [NSURL URLWithString:getModelDataURL];
    NSData * modeldata = [NSData dataWithContentsOfURL:modelurl];
    
    modeljsonArray = [NSJSONSerialization JSONObjectWithData:modeldata options:kNilOptions error:nil];
    
    
    NSLog(@"contents of firstcar: %@", _firstCar1);
    
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
        
        
        
        
        
        //Add the object to the array
        [modelArray addObject:[[Model alloc]initWithCarMake:cMake andCarModel:cModel andCarYearsMade:cYearsMade andCarPrice:cPrice andCarEngine:cEngine andCarTransmission:cTransmission andCarDriveType:cDriveType andCarHorsepower:cHorsepower andCarZeroToSixty:cZeroToSixty andCarTopSpeed:cTopSpeed andCarWeight:cWeight andCarFuelEconomy:cFuelEconomy andCarImageURL:cURL andCarWebsite:cWebsite]];
        
        
        
        
    }
    
    
    [self.collectionView reloadData];
}*/


- (void) retrieveMakeImageData;
{
    NSURL * makeurl = [NSURL URLWithString:getMakeDataURL];
    NSData * makedata = [NSData dataWithContentsOfURL:makeurl];
    
    makejsonArray = [NSJSONSerialization JSONObjectWithData:makedata options:kNilOptions error:nil];
    
    NSLog(@"contents of firstcar: %@", _firstCar1);
    
    //set up the makes array
    makeimageArray = [[NSMutableArray alloc]init];
    
    NSSortDescriptor * alphasort = [NSSortDescriptor sortDescriptorWithKey:@"Make" ascending:YES];
    AlphabeticalArray = [makejsonArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphasort]];
    
    //Loop through our makejsonArray
    for (int i = 0; i < makejsonArray.count; i++)
    {
        //Create the MakeImage object
        NSString * mName = [[AlphabeticalArray objectAtIndex:i] objectForKey:@"Make"];
        NSString * mImageURL = [[AlphabeticalArray objectAtIndex:i] objectForKey:@"ImageURL"];
        
        //Add the MakeImage object to the MakeImage array
        
        [makeimageArray addObject:[[Make alloc]initWithMakeName:mName andMakeImageURL:mImageURL]];
        
    }
    
    //Reload the Collection View
    [self.collectionView reloadData];
}

@end
