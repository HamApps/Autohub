//
//  ModelViewController.m
//  Carhub
//
//  Created by Christopher Clark on 8/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "ModelViewController.h"
#import "MakeViewController.h"
#import "Model.h"
#import "CarViewCell.h"
#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

#define getDataURL @"http://pl0x.net/CarHubJSON2.php"

#define getImageURL @"http://pl0x.net/image.php"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface ModelViewController ()

@end

@implementation ModelViewController
@synthesize currentModel, currentMake, ModelArray, jsonArray, carArray, cachedImages, AlphabeticalArray, appdelmodelArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cachedImages = [[NSMutableDictionary alloc]init];
    //Set the title of the VC: will be make name
    self.title = currentMake.MakeName;
    
    //Load Model Data
    [self makeAppDelModelArray];
    [self getnumber];
    //[self retrieveData];
    
    NSLog(@"CarArraycount: %lu", (unsigned long)carArray.count);
    NSLog(@"FirstCar: %@", _firstCar2);
    

    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return ModelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ModelCell";
    CarViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"Metal Background.jpg"]];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Metal Background.jpg"]];
    
    
    Model * modelObject;
    modelObject = [ModelArray objectAtIndex:indexPath.row];

    if (cell == nil) {
        cell = [[CarViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:CellIdentifier];
    }
    
    NSString *identifier = [NSString stringWithFormat:@"ModelCell%ld" , (long)indexPath.row];
    
    // Configure the cell...
    
    cell.CarName.text = modelObject.CarModel;
    //Accessory stuff89
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.layer.borderWidth=1.0f;
    cell.layer.borderColor=[UIColor blackColor].CGColor;
    //cell.layer.cornerRadius = 20;
    cell.CarName.layer.borderWidth=1.0f;
    cell.CarName.layer.borderColor=[UIColor whiteColor].CGColor;

    //NSString *identifier = [NSString stringWithFormat:@"ModelCell%ld" , (long)indexPath.row];
    cell.CarImage.image = [self.cachedImages valueForKey:identifier];
    
    if([self.cachedImages objectForKey:identifier] !=nil){
        cell.CarImage.image = [self.cachedImages valueForKey:identifier];
    }else{
        
        char const*s = [identifier UTF8String];
        dispatch_queue_t queue = dispatch_queue_create(s, 0);
    
    dispatch_async(queue, ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:modelObject.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]];
        if (imgData) {
            UIImage *image = [UIImage imageWithData:imgData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    CarViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    
                    if (updateCell)
                        [self.cachedImages setValue:image forKey:identifier];
                        updateCell.CarImage.image = [self.cachedImages valueForKey:identifier];
                        updateCell.CarImage.image = image;
                        //UIImage *cachedimage = image;
                        [UIImageView beginAnimations:nil context:NULL];
                        [UIImageView setAnimationDuration:.75];
                        [updateCell.CarImage setAlpha:1.0];
                        [UIImageView commitAnimations];
                
                });
            }
        }
    });
        
    }
    return cell;
}




/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark -
#pragma mark Methods

- (void)getMake:(id)makeObject;
{
    currentMake = makeObject;
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"pushDetailView"])
    {
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        
        //Get the object for the selected row
        Model * object = [ModelArray objectAtIndex:indexPath.row];
        Model * firstcarobject3 = _firstCar2;
        Model * secondcarobject3 = _secondCar2;
        [[segue destinationViewController] getfirstModel:firstcarobject3];
        [[segue destinationViewController] getsecondModel:secondcarobject3];
        [[segue destinationViewController] getModel:object];
    }
    
}

- (void)getfirstModel:(id)firstcarObject2;
{
    _firstCar2 = firstcarObject2;
}

- (void)getsecondModel:(id)secondcarObject2;
{
    _secondCar2 = secondcarObject2;
}

- (void)getmodelarray:(id)modeljsonarray;
{
    carArray = modeljsonarray;
    NSLog(@"jsonarray%lu", (unsigned long)carArray.count);
    NSLog(@"fulljsonarray%@", carArray);
}

- (void)getnumber
{
    NSPredicate *MakePredicate = [NSPredicate predicateWithFormat:@"CarMake == %@", currentMake.MakeName];
    //ModelArray = [carArray filteredArrayUsingPredicate:MakePredicate];
    ModelArray = [appdelmodelArray filteredArrayUsingPredicate:MakePredicate];
    NSLog(@"ModelArray%lu", (unsigned long)ModelArray.count);
}

- (void) makeAppDelModelArray;
{
    appdelmodelArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"appdelarray2: %@", appdel.modelArray);
    [appdelmodelArray addObjectsFromArray:appdel.modelArray];
    NSLog(@"appdelarray3: %@", appdelmodelArray);
}

- (void) retrieveData;
{
    NSURL * url = [NSURL URLWithString:getDataURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSPredicate *AcuraPredicate = [NSPredicate predicateWithFormat:@"Make CONTAINS %@", self.title];
    ModelArray = [jsonArray filteredArrayUsingPredicate:AcuraPredicate];
    
    [self.tableView numberOfRowsInSection:ModelArray.count];
    
    //Set up our cities arrray
    carArray = [[NSMutableArray alloc] init];
    
    //Loop through ourjsonArray
    for (int i=0; i < ModelArray.count; i++)
    {
        //Create our city object
        NSString * cMake = [[ModelArray objectAtIndex:i] objectForKey:@"Make"];
        NSString * cModel = [[ModelArray objectAtIndex:i] objectForKey:@"Model"];
        NSString * cYearsMade = [[ModelArray objectAtIndex:i] objectForKey:@"Years Made"];
        NSString * cPrice = [[ModelArray objectAtIndex:i] objectForKey:@"Price"];
        NSString * cEngine = [[ModelArray objectAtIndex:i] objectForKey:@"Engine"];
        NSString * cTransmission = [[ModelArray objectAtIndex:i] objectForKey:@"Transmission"];
        NSString * cDriveType = [[ModelArray objectAtIndex:i] objectForKey:@"Drive Type"];
        NSString * cHorsepower = [[ModelArray objectAtIndex:i] objectForKey:@"Horsepower"];
        NSString * cZeroToSixty = [[ModelArray objectAtIndex:i] objectForKey:@"0-60"];
        NSString * cTopSpeed = [[ModelArray objectAtIndex:i] objectForKey:@"Top Speed (mph)"];
        NSString * cWeight = [[ModelArray objectAtIndex:i] objectForKey:@"Weight (lbs)"];
        NSString * cFuelEconomy = [[ModelArray objectAtIndex:i] objectForKey:@"Fuel Economy (mpg)"];
        NSString * cURL = [[ModelArray objectAtIndex:i] objectForKey:@"Image URL"];
        NSString * cWebsite = [[ModelArray objectAtIndex:i]objectForKey:@"Make Link"];
        
        //Add the city object to our cities array
        [carArray addObject:[[Model alloc]initWithCarMake:cMake andCarModel:cModel andCarYearsMade:cYearsMade andCarPrice:cPrice andCarEngine:cEngine andCarTransmission:cTransmission andCarDriveType:cDriveType andCarHorsepower:cHorsepower andCarZeroToSixty:cZeroToSixty andCarTopSpeed:cTopSpeed andCarWeight:cWeight andCarFuelEconomy:cFuelEconomy andCarImageURL:cURL andCarWebsite:cWebsite]];
    }
    NSLog(@"cararraymeow%@", carArray);
    NSLog(@"predicatescount%lu", (unsigned long)carArray.count);
}


@end
