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
#import "SDWebImage/UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "NewMakesViewController.h"

@interface ModelViewController ()

@end

@implementation ModelViewController
@synthesize currentMake, ModelArray, searchArray, appdelmodelArray, currentClass, currentSubclass, searchBar;

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
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    //Load Model Data
    [self makeAppDelModelArray];
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *resultsPredicate = [NSPredicate predicateWithFormat:@"SELF.CarFullName contains [search] %@", searchText];
    self.searchArray = [[self.ModelArray filteredArrayUsingPredicate:resultsPredicate]mutableCopy];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
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
    __weak CarViewCell *cell2 = cell;

    if (cell==nil) {
        cell = [[CarViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Model * modelObject;
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
    modelObject = [self.searchArray objectAtIndex:indexPath.row];
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor whiteColor];
    self.searchDisplayController.searchResultsTableView.separatorColor = [UIColor clearColor];
    } else {
        modelObject = [self.ModelArray objectAtIndex:indexPath.row];
    }
    
    NSURL *imageURL;
    if([modelObject.CarImageURL containsString:@"carno"])
        imageURL = [NSURL URLWithString:modelObject.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
    else
        imageURL = [NSURL URLWithString:modelObject.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];
    
    //Load and fade image
    [cell.CarImage setImageWithURL:imageURL
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                        [cell2.CarImage setAlpha:0.0];
                        [UIImageView animateWithDuration:.5 animations:^{
                        [cell2.CarImage setAlpha:1.0];
                    }];
                }
       usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    cell.CarName.text = modelObject.CarModel;
    
    return cell;
}

- (void)getMake:(id)makeObject;
{
    currentMake = makeObject;
    [self makeAppDelModelArray];
    [self filterToClassArray];
    self.title = currentMake.MakeName;
}

- (void)getClass:(id)classObject;
{
    currentClass = classObject;
    [self makeAppDelModelArray];
    [self filterToSubClassArray];
    self.title = currentClass;
    NSLog(@"in here");
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:@selector(returnToMakes)];
    backButton.tintColor = [UIColor blackColor];
    [self.navigationItem setLeftBarButtonItem: backButton];
}

- (void)getSubclass:(id)subclassObject;
{
    currentSubclass = subclassObject;
    [self makeAppDelModelArray];
    [self filterToModelArray];
    self.title = currentSubclass;
    NSLog(@"CURRENTSUBCLASS %@", currentSubclass);
}

- (void)filterToClassArray
{
    NSPredicate *MakePredicate = [NSPredicate predicateWithFormat:@"CarMake == %@", currentMake.MakeName];
    ModelArray = [appdelmodelArray filteredArrayUsingPredicate:MakePredicate];
    NSPredicate *AnotherPredicate = [NSPredicate predicateWithFormat:@"isClass == %@", [NSNumber numberWithInt:1]];
    ModelArray = [ModelArray filteredArrayUsingPredicate:AnotherPredicate];
}

- (void)filterToSubClassArray
{
    NSPredicate *ClassPredicate = [NSPredicate predicateWithFormat:@"CarClass == %@", currentClass];
    ModelArray = [appdelmodelArray filteredArrayUsingPredicate:ClassPredicate];
}

- (void)filterToModelArray
{
    NSPredicate *SubclassPredicate = [NSPredicate predicateWithFormat:@"CarSubclass == %@", currentSubclass];
    ModelArray = [appdelmodelArray filteredArrayUsingPredicate:SubclassPredicate];
}

- (void) makeAppDelModelArray;
{
    appdelmodelArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelmodelArray addObjectsFromArray:appdel.modelArray];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Model * pushingObject;
    if (self.searchDisplayController.active)
        pushingObject = [searchArray objectAtIndex:indexPath.row];
    else
        pushingObject = [ModelArray objectAtIndex:indexPath.row];
        
    if([pushingObject.isModel isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        NSLog(@"detail");
        [self performSegueWithIdentifier:@"pushDetailView" sender:self];
    }
    else if([pushingObject.isSubclass isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        currentSubclass = pushingObject.CarModel;
        [self performSegueWithIdentifier:@"pushModels" sender:self];
    }
    else if([pushingObject.isClass isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        currentClass = pushingObject.CarModel;
        [self performSegueWithIdentifier:@"pushSubclasses" sender:self];
    }
}

-(void)returnToMakes
{
    [self performSegueWithIdentifier:@"backToMakes" sender:self];
}

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
        
        [[segue destinationViewController] getModel:object];
    }
    
    if([[segue identifier] isEqualToString:@"pushSubclasses"])
    {
        [[segue destinationViewController] getClass: currentClass];
    }
    
    if([[segue identifier] isEqualToString:@"pushModels"])
    {
        [[segue destinationViewController] getSubclass: currentSubclass];
    }
}

@end
