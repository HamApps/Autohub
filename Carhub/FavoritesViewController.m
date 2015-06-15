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
#import "SDWebImage/UIImageView+WebCache.h"

#define getDataURL @"http://pl0x.net/CarHubJSON2.php"

#define getImageURL @"http://pl0x.net/image.php"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

@synthesize searchArray, ModelArray, editButton;


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
    
    editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style: UIBarButtonItemStyleBordered target:self action:@selector(enterEditMode:)];
    [self.navigationItem setLeftBarButtonItem:editButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewData) name:@"ReloadRootViewControllerTable" object:nil];
    
    self.title = @"Favorite Cars";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *resultsPredicate = [NSPredicate predicateWithFormat:@"SELF.CarFullName contains [search] %@", searchText];
    self.searchArray = [[self.ModelArray filteredArrayUsingPredicate:resultsPredicate]mutableCopy];
    NSLog(@"searchArray %@", searchArray);
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
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

-(void) reloadTableViewData{
    NSLog(@"meow");
    [self loadSavedCars];
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (IBAction)enterEditMode:(id)sender {
    
    if ([self.tableView isEditing]) {
        // If the tableView is already in edit mode, turn it off. Also change the title of the button to reflect the intended verb (‘Edit’, in this case).
        [self.tableView setEditing:NO animated:YES];
        [self.editButton setTitle:@"Edit"];
    }
    else {
        [self.editButton setTitle:@"Done"];
        
        // Turn on edit mode
        
        [self.tableView setEditing:YES animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableView beginUpdates];
        [ModelArray removeObjectAtIndex:indexPath.row];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:ModelArray];
        [defaults setObject:arrayData forKey:@"savedArray"];
        [defaults synchronize];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self loadSavedCars];
        [self.tableView endUpdates];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeStar" object:nil];
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.tableView reloadData];
        });
    }
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
