//
//  RaceViewController.m
//  Carhub
//
//  Created by Christopher Clark on 10/9/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import "RaceViewController.h"
#import "AppDelegate.h"
#import "CarViewCell.h"
#import "Race.h"
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "RaceResultsViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface RaceViewController ()

@end

@implementation RaceViewController
@synthesize currentRaceType, currentRaceTypeArray, currentRaceID;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"currentRaceType: %@", currentRaceType.RaceTypeString);
    
    AppDelegate *appdel = [UIApplication sharedApplication].delegate;
    [appdel setShouldRotate:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    //Set which RaceType was picked
    currentRaceTypeArray = [[NSMutableArray alloc]init];
    
    if([currentRaceType.RaceTypeString isEqualToString:@"Formula 1"])
        [currentRaceTypeArray addObjectsFromArray:appdel.formulaOneArray];
    if([currentRaceType.RaceTypeString isEqualToString:@"Nascar"])
        [currentRaceTypeArray addObjectsFromArray:appdel.nascarArray];
    if([currentRaceType.RaceTypeString isEqualToString:@"IndyCar"])
        [currentRaceTypeArray addObjectsFromArray:appdel.indyCarArray];
    if([currentRaceType.RaceTypeString isEqualToString:@"FIA World Endurance Championships"])
        [currentRaceTypeArray addObjectsFromArray:appdel.fiaArray];
    if([currentRaceType.RaceTypeString isEqualToString:@"WRC"])
        [currentRaceTypeArray addObjectsFromArray:appdel.wrcArray];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return currentRaceTypeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ModelCell";
    CarViewCell *cell = (CarViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    __weak CarViewCell *cell2 = cell;
    
    if (cell==nil) {
        cell = [[CarViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Race * raceObject;
    
    raceObject = [currentRaceTypeArray objectAtIndex:indexPath.row];
    
    NSLog(@"race type array: %@", raceObject);
    
    NSURL *imageURL;
    if([raceObject.RaceImageURL containsString:@"raceno"])
        imageURL = [NSURL URLWithString:raceObject.RaceImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/raceimage.php"]];
    else
        imageURL = [NSURL URLWithString:raceObject.RaceImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/OtherPictures/"]];
    
    [cell.CarImage setImageWithURL:imageURL
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                [cell2.CarImage setAlpha:0.0];
                                [UIImageView animateWithDuration:.5 animations:^{
                                    [cell2.CarImage setAlpha:1.0];
                                }];
                            }
       usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    cell.CarName.text = raceObject.RaceName;
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentRaceID = [currentRaceTypeArray objectAtIndex:indexPath.row];
    NSString *raceType = currentRaceID.RaceType;
    NSLog(@"currentraceid.racename: %@", currentRaceID.RaceName);
    
    if([raceType isEqualToString:@"Formula 1"])
        [self performSegueWithIdentifier:@"pushFormula1" sender:self];
    if([raceType isEqualToString:@"Nascar"])
        [self performSegueWithIdentifier:@"pushNascar" sender:self];
    if([raceType isEqualToString:@"IndyCar"])
        [self performSegueWithIdentifier:@"pushIndyCar" sender:self];
    if([raceType isEqualToString:@"FIA World Endurance Championships"])
        [self performSegueWithIdentifier:@"pushFIA" sender:self];
    if([raceType isEqualToString:@"WRC"])
        [self performSegueWithIdentifier:@"pushWRC" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSLog(@"currentraceid.racename: %@", currentRaceID.RaceName);

    
    if ([[segue identifier] isEqualToString:@"pushFormula1"] || [[segue identifier] isEqualToString:@"pushNascar"] || [[segue identifier] isEqualToString:@"pushIndyCar"] || [[segue identifier] isEqualToString:@"pushFIA"] || [[segue identifier] isEqualToString:@"pushWRC"])
    {
        [[segue destinationViewController] getRaceResults:currentRaceID];
    }
}

-(void)getRaceTypeID:(id)RaceTypeID
{
    currentRaceType = RaceTypeID;
}

@end