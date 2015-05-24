//
//  SearchModelController.m
//  Carhub
//
//  Created by Christopher Clark on 9/8/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "SearchModelController.h"
#import "MakeViewController.h"
#import "Model.h"
#import "CarViewCell.h"
#import "DetailViewController.h"
#import "SearchViewController.h"

#define getDataURL @"http://pl0x.net/CarHubJSON2.php"
#define getImageURL @"http://pl0x.net/image.php"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface SearchModelController ()

@end

@implementation SearchModelController
@synthesize currentModel, ModelArray, jsonArray, carArray, cachedImages;

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
    self.title = @"Results";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"whiteback.jpg"]];
    
    //Load Model Data
    
    NSLog(@"CarArraycount: %lu", (unsigned long)ModelArray.count);
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
    return carArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ModelCell";
    CarViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Model * modelObject;
    modelObject = [carArray objectAtIndex:indexPath.row];
    
    cell.CarName.text = modelObject.CarModel;
    //Accessory stuff89
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.layer.borderWidth=1.0f;
    cell.layer.borderColor=[UIColor blackColor].CGColor;
    cell.CarName.layer.borderWidth=1.0f;
    cell.CarName.layer.borderColor=[UIColor whiteColor].CGColor;
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"whiteback.jpg"]];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"whiteback.jpg"]];
    
    NSString *identifier = [[[NSString stringWithFormat:@"%@", modelObject.CarMake]stringByAppendingString:@" "]stringByAppendingString:modelObject.CarModel];
    NSString *urlIdentifier = [NSString stringWithFormat:@"imageurl%@%@",modelObject.CarMake, modelObject.CarModel];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imagedata = [defaults objectForKey:identifier];
    cell.CarImage.image = [UIImage imageWithData:imagedata];
    [UIImageView beginAnimations:nil context:NULL];
    [UIImageView setAnimationDuration:.01];
    [cell.CarImage setAlpha:1.0];
    [UIImageView commitAnimations];
    
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
        Model * object = [carArray objectAtIndex:indexPath.row];
        [[segue destinationViewController] getModel:object];
    }
}

- (void)getsearcharray:(id)searcharrayObject;
{
    //ModelArray = [[NSMutableArray alloc]init];
    carArray = searcharrayObject;
    NSLog(@"CarArraycount: %lu", (unsigned long)ModelArray.count);
    NSLog(@"meow");
}

@end
