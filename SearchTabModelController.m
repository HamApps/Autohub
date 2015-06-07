//
//  SearchTabViewController.m
//  Carhub
//
//  Created by Christopher Clark on 2/27/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.

#import "SearchTabViewController.h"
#import "MakeViewController.h"
#import "Model.h"
#import "CarViewCell.h"
#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface SearchTabModelController ()

@end

@implementation SearchTabViewController
@synthesize ModelArray, searchArray, appdelmodelArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchDisplayController.active = YES;
    
    [self.searchBar becomeFirstResponder];
    
    self.title = @"Find Cars";
    [self makeAppDelModelArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    //NSPredicate *resultsPredicate = [NSPredicate predicateWithFormat:@"SELF.CarModel contains [search] %@", searchText];
    NSPredicate *resultsPredicate = [NSPredicate predicateWithFormat:@"SELF.CarFullName contains [search] %@", searchText];
    self.searchArray = [[self.ModelArray filteredArrayUsingPredicate:resultsPredicate]mutableCopy];
    NSLog(@"searchArray %@", searchArray);
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return self.searchArray.count;
    }else{
        return self.ModelArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 183;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ModelCell";
    CarViewCell *cell = (CarViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"whiteback.jpg"]];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"whiteback.jpg"]];
    
    if (cell==nil) {
        cell = [[CarViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Model * modelObject;
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        modelObject = [self.searchArray objectAtIndex:indexPath.row];
    } else {
        modelObject = [self.ModelArray objectAtIndex:indexPath.row];
    }
    
    cell.CarName.text = modelObject.CarFullName;
    //Accessory stuff
    cell.layer.borderWidth=1.0f;
    cell.layer.borderColor=[UIColor blackColor].CGColor;
    //cell.layer.cornerRadius = 20;
    cell.CarName.layer.borderWidth=1.0f;
    cell.CarName.layer.borderColor=[UIColor whiteColor].CGColor;
    
    //Load and fade image
    
    
    
    /*NSString *identifier = [[[NSString stringWithFormat:@"%@", modelObject.CarMake]stringByAppendingString:@" "]stringByAppendingString:modelObject.CarModel];
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
     }*/
    return cell;
}

- (void) makeAppDelModelArray;
{
    appdelmodelArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelmodelArray addObjectsFromArray:appdel.modelArray];
    ModelArray = [[NSMutableArray alloc]init];
    [ModelArray addObjectsFromArray:appdelmodelArray];
    NSLog(@"appdelmodelarray %@", appdelmodelArray);
    NSLog(@"modelarray %@", ModelArray);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushDetailView"])
    {
        NSIndexPath * indexPath;
        Model * object;
        
        if (self.searchDisplayController.active) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            object = [searchArray objectAtIndex:indexPath.row];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            object = [ModelArray objectAtIndex:indexPath.row];
        }
        NSLog (@"object.Carmodel%@", object.CarModel);
        [[segue destinationViewController] getModel:object];
    }
}

@end
