//
//  RaceResultsViewController.m
//  Carhub
//
//  Created by Christopher Clark on 10/10/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import "RaceResultsViewController.h"
#import "AppDelegate.h"
#import "RaceResult.h"
#import "RaceResultCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface RaceResultsViewController ()

@end

@implementation RaceResultsViewController
@synthesize currentRaceResultsArray, currentRace;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"currentRace: %@", currentRace.RaceName);
    NSLog(@"raceResultsArray: %@", currentRaceResultsArray);
    
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
    return currentRaceResultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RaceCell";
    RaceResultCell *cell = (RaceResultCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[RaceResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    RaceResult * raceResultObject;
    
    raceResultObject = [currentRaceResultsArray objectAtIndex:indexPath.row];
    
    NSLog(@"race type array: %@", raceResultObject);
    
    cell.positionLabel.text = raceResultObject.Position;
    cell.driverLabel.text = raceResultObject.Driver;
    cell.teamLabel.text = raceResultObject.Team;
    cell.countryLabel.text = raceResultObject.Country;
    cell.CarLabel.text = raceResultObject.Car;
    cell.timeLabel.text = raceResultObject.Time;
    cell.bestLapTimeLabel.text = raceResultObject.BestLapTime;
    cell.RaceClass.text = raceResultObject.RaceClass;
    
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)getRaceResults:(id)currentRaceID
{
    NSLog(@"2");
    currentRace = currentRaceID;
    currentRaceResultsArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for(int i=0; i<appdel.raceResultsArray.count; i++)
    {
        RaceResult *raceResult = [appdel.raceResultsArray objectAtIndex:i];
        if(raceResult.RaceID == currentRace.RaceName)
            [currentRaceResultsArray addObjectsFromArray:[appdel.raceResultsArray objectAtIndex:i]];
    }
    NSLog(@"currentRaceResultsArray: %@", currentRaceResultsArray);
    
    [currentRaceResultsArray addObjectsFromArray:appdel.raceResultsArray];
}

@end
