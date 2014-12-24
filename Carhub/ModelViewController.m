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
@synthesize currentMake, ModelArray, jsonArray, carArray, appdelmodelArray;

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
    //Set the title of the VC: will be make name
    self.title = currentMake.MakeName;
    
    //Load Model Data
    [self makeAppDelModelArray];
    [self getnumber];
    
    NSLog(@"CarArraycount: %lu", (unsigned long)carArray.count);
    NSLog(@"FirstCar: %@", _firstCar2);
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
    
    //NSString *identifier = [[NSString stringWithFormat:@"ModelCell%ld" , (long)indexPath.row] stringByAppendingString:currentMake.MakeName];
    NSString *identifier = [[NSString stringWithFormat:@"%@", modelObject.CarMake]stringByAppendingString:modelObject.CarModel];
    NSString *urlIdentifier = [NSString stringWithFormat:@"imageurl%@%@",modelObject.CarMake, modelObject.CarModel];
    
    // Configure the cell...
    
    cell.CarName.text = modelObject.CarModel;
    //Accessory stuff
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.layer.borderWidth=1.0f;
    cell.layer.borderColor=[UIColor blackColor].CGColor;
    //cell.layer.cornerRadius = 20;
    cell.CarName.layer.borderWidth=1.0f;
    cell.CarName.layer.borderColor=[UIColor whiteColor].CGColor;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imagedata = [defaults objectForKey:identifier];
    [defaults setObject:[NSString stringWithFormat:@"%i", ModelArray.count] forKey:@"count"];
    
    if([[defaults objectForKey:@"count"] integerValue] == [[NSString stringWithFormat:@"%i", ModelArray.count] integerValue])
    {
        cell.CarImage.image = [UIImage imageWithData:imagedata];
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:.01];
        [cell.CarImage setAlpha:1.0];
        [UIImageView commitAnimations];
    }
    if(!([[defaults objectForKey:urlIdentifier] isEqualToString:modelObject.CarImageURL]) || cell.CarImage.image == nil){
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
                            {
                                [defaults setObject:UIImagePNGRepresentation(image) forKey:identifier];
                                [defaults setObject:modelObject.CarImageURL forKey:urlIdentifier];
                                NSData *imgdata = [defaults objectForKey:identifier];
                                updateCell.CarImage.image = [UIImage imageWithData:imgdata];
                                [updateCell.CarImage setAlpha:0.0];
                                [UIImageView beginAnimations:nil context:NULL];
                                [UIImageView setAnimationDuration:.75];
                                [updateCell.CarImage setAlpha:1.0];
                                [UIImageView commitAnimations];
                        
                                //[defaults synchronize];
                            }
                        });
                    }
                }
            });
    }
    return cell;
}


#pragma mark -
#pragma mark Methods

- (void)getMake:(id)makeObject;
{
    currentMake = makeObject;
}



 #pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected objects to the new view controller.
    
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

@end
