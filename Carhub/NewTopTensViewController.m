//
//  NewTopTensViewController.m
//  Carhub
//
//  Created by Christopher Clark on 2/15/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "NewTopTensViewController.h"
#import "AppDelegate.h"
#import "TopTens.h"
#import "TopTensCell.h"
#import "Model.h"
#import "DetailViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SWRevealViewController.h"

@interface NewTopTensViewController ()

@end

@implementation NewTopTensViewController
@synthesize jsonArray, topTensArray, currentTopTen, urlExtention, appdelmodelArray, objectToSend;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set which Top Ten was picked
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    topTensArray = [[NSMutableArray alloc]init];
    self.title = currentTopTen;
    [self makeAppDelModelArray];

    if([currentTopTen isEqualToString:@"Fastest 0-60's"])
        [topTensArray addObjectsFromArray:appdel.zt60Array];
    if([currentTopTen isEqualToString:@"Top Speeds"])
        [topTensArray addObjectsFromArray:appdel.topspeedArray];
    if([currentTopTen isEqualToString:@"Nürburgring Lap Times"])
        [topTensArray addObjectsFromArray:appdel.nurbArray];
    if([currentTopTen isEqualToString:@"Most Expensive (New Cars)"])
        [topTensArray addObjectsFromArray:appdel.newexpensiveArray];
    if([currentTopTen isEqualToString:@"Most Expensive (Auction)"])
        [topTensArray addObjectsFromArray:appdel.auctionexpensiveArray];
    if([currentTopTen isEqualToString:@"Best Fuel Economy"])
        [topTensArray addObjectsFromArray:appdel.fuelArray];
    if([currentTopTen isEqualToString:@"Highest Horsepower"])
        [topTensArray addObjectsFromArray:appdel.horsepowerArray];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return topTensArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"toptens";
    TopTensCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    TopTens * toptensObject = [topTensArray objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[TopTensCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
    }
    cell.CarRank.text = toptensObject.CarRank;
    cell.CarName.text = toptensObject.CarName;
    cell.CarValue.text = toptensObject.CarValue;
    
    //Load and fade image
    [cell.CarImage sd_setImageWithURL:[NSURL URLWithString:toptensObject.CarURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]
            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                    [cell.CarImage setAlpha:0.0];
                    [UIImageView animateWithDuration:.5 animations:^{
                    [cell.CarImage setAlpha:1.0];
            }];
        }];
    
    return cell;
}

-(void)getTopTenID:(id)TopTenID;
{
    currentTopTen = TopTenID;
}

- (void) makeAppDelModelArray;
{
    appdelmodelArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelmodelArray addObjectsFromArray:appdel.modelArray];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"pushDetailView"])
    {
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        TopTens * toptensObject = [topTensArray objectAtIndex:indexPath.row];
        
        for(int i=0;i<appdelmodelArray.count;i++){
            Model * currentObj = [appdelmodelArray objectAtIndex:i];
            NSString * cURL = currentObj.CarImageURL;
            if([toptensObject.CarURL isEqualToString:cURL]){
                objectToSend = currentObj;
                break;
            }
        }
        Model * object = objectToSend;
        [[segue destinationViewController] getModel:object];
    }
}

@end
