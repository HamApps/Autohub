//
//  RaceViewController.m
//  Carhub
//
//  Created by Christopher Clark on 10/9/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import "RaceViewController.h"
#import "AppDelegate.h"
#import "RaceTypeCell.h"
#import "Race.h"
#import "RaceSeason.h"
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "PageItemController.h"
#import <Google/Analytics.h>

@interface RaceViewController ()

@end

@implementation RaceViewController
@synthesize currentRaceType, raceSeasonArray, currentRaceID;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.title = currentRaceType.RaceTypeString;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:self.title];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
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
    return raceSeasonArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SeasonCell";
    RaceTypeCell *cell = (RaceTypeCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil)
    {
        cell = [[RaceTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    RaceSeason * seasonObject;
    seasonObject = [raceSeasonArray objectAtIndex:indexPath.row];
    cell.currentRaceSeason = seasonObject;
    
    cell.controller = self;
    
    cell.seasonLabel.text = seasonObject.SeasonName;
    
    return cell;
}

#pragma mark - Navigation

-(void)pushRaceWithRaceObject:(Race *)raceObject
{
    currentRaceID = raceObject;
    if([currentRaceID.RaceType isEqualToString:@"Formula 1"] || [currentRaceID.RaceType isEqualToString:@"Supercars Championship"])
        [self performSegueWithIdentifier:@"pushResults1" sender:self];
    if([currentRaceID.RaceType isEqualToString:@"NASCAR"])
        [self performSegueWithIdentifier:@"pushResults2" sender:self];
    if([currentRaceID.RaceType isEqualToString:@"FIA World Endurance Championship"])
        [self performSegueWithIdentifier:@"pushResults3" sender:self];
    if([currentRaceID.RaceType isEqualToString:@"IndyCar"])
        [self performSegueWithIdentifier:@"pushResults4" sender:self];
    if([currentRaceID.RaceType isEqualToString:@"DTM"])
        [self performSegueWithIdentifier:@"pushResults5" sender:self];
    if([currentRaceID.RaceType isEqualToString:@"WRC"] || [currentRaceID.RaceType isEqualToString:@"Formula E"])
        [self performSegueWithIdentifier:@"pushResults6" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushResults1"] || [[segue identifier] isEqualToString:@"pushResults2"] || [[segue identifier] isEqualToString:@"pushResults3"] || [[segue identifier] isEqualToString:@"pushResults4"] || [[segue identifier] isEqualToString:@"pushResults5"] || [[segue identifier] isEqualToString:@"pushResults6"])
    {
        [[segue destinationViewController] getRaceResults:currentRaceID];
    }
}

-(void)getRaceTypeID:(id)RaceTypeID
{
    currentRaceType = RaceTypeID;
    
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.SeasonClass contains %@", currentRaceType.RaceTypeString];
    raceSeasonArray = [[appdel.raceSeasonArray filteredArrayUsingPredicate:predicate]mutableCopy];
}

@end
