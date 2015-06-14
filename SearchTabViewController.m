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
#import "MakeViewController.h"

@interface SearchTabViewController ()

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
    self.view.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
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
    [cell.CarImage sd_setImageWithURL:[NSURL URLWithString:modelObject.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                [cell.CarImage setAlpha:0.0];
                                [UIImageView animateWithDuration:.5 animations:^{
                                    [cell.CarImage setAlpha:1.0];
                                }];
                            }];
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
