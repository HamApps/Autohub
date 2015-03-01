//
//  FavoritesViewController.m
//  Carhub
//
//  Created by Christopher Clark on 8/23/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "FavoritesViewController.h"
#import "DetailViewController.h"
#import "CarViewCell.h"
#import "Model.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Model.h"

#define getDataURL @"http://pl0x.net/CarHubJSON2.php"

#define getImageURL @"http://pl0x.net/image.php"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

@synthesize searchArray, ModelArray;


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
    [self loadSavedCars];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewData) name:@"ReloadRootViewControllerTable" object:nil];
    
    self.title = @"Favorite Cars";
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"whiteback.jpg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ModelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ModelCell";
    CarViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"whiteback.jpg"]];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"whiteback.jpg"]];
    
    if (cell==nil) {
        cell = [[CarViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    UIButton * button = cell.deleteButton;
    [button addTarget:self action:@selector(removeFavorite:) forControlEvents:UIControlEventTouchUpInside];
    
    Model * modelObject = [ModelArray objectAtIndex:indexPath.row];

    
    cell.CarName.text = modelObject.CarFullName;
    //Accessory stuff
    cell.layer.borderWidth=1.0f;
    cell.layer.borderColor=[UIColor blackColor].CGColor;
    //cell.layer.cornerRadius = 20;
    cell.CarName.layer.borderWidth=1.0f;
    cell.CarName.layer.borderColor=[UIColor whiteColor].CGColor;
    NSLog(@"fullname: %@", modelObject.CarFullName);
    
    
    NSString *identifier = [[[NSString stringWithFormat:@"%@", modelObject.CarMake]stringByAppendingString:@" "]stringByAppendingString:modelObject.CarModel];
    NSString *urlIdentifier = [NSString stringWithFormat:@"imageurl%@%@%@",modelObject.CarMake,@" ", modelObject.CarModel];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imagedata = [defaults objectForKey:identifier];
    [defaults setObject:[NSString stringWithFormat:@"%lu", (unsigned long)ModelArray.count] forKey:@"count"];
    
    if([[defaults objectForKey:@"count"] integerValue] == [[NSString stringWithFormat:@"%lu", (unsigned long)ModelArray.count] integerValue])
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
                            
                        }
                    });
                }
            }
        });
    }
    return cell;
}

-(void)loadSavedCars;
{
    //Get from defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ModelArray = [[NSMutableArray alloc]init];
    NSData *retrievedData = [defaults objectForKey:@"savedArray"];
    ModelArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
    [defaults synchronize];
    NSLog(@"retrievedArray: %@", ModelArray);
}

-(NSIndexPath*)GetIndexPathFromSender:(id)sender{
    
    if(!sender) { return nil; }
    
    if([sender isKindOfClass:[UITableViewCell class]])
    {
        UITableViewCell *cell = sender;
        return [self.tableView indexPathForCell:cell];
    }
    
    return [self GetIndexPathFromSender:((UIView*)[sender superview])];
}

-(void)removeFavorite:(id)sender{
    NSLog(@"meow");
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    NSLog(@"sender %ld",(long)sender);
    NSLog(@"indexpath.row %ld",(long)indexPath.row);
    [ModelArray removeObjectAtIndex:indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:ModelArray];
    [defaults setObject:arrayData forKey:@"savedArray"];
    [defaults synchronize];
    NSLog(@"newArray.count %lu", (unsigned long)ModelArray.count);
    [self loadSavedCars];
    [self.tableView reloadData];
}

-(void) reloadTableViewData{
    NSLog(@"meow");
    [self loadSavedCars];
    [self.tableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
