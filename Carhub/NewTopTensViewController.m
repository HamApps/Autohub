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
#import "AppDelegate.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

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
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    //Set which Top Ten was picked
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    topTensArray = [[NSMutableArray alloc]init];
    self.title = currentTopTen;
    [self makeAppDelModelArray];

    if([currentTopTen isEqualToString:@"0-60 Times"])
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 212;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"toptens";
    TopTensCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    __weak TopTensCell *cell2 = cell;
    TopTens * toptensObject = [topTensArray objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[TopTensCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
    }
    cell.CarRank.text = toptensObject.CarRank;
    cell.CarName.text = toptensObject.CarName;
    cell.CarValue.text = toptensObject.CarValue;
    
    CALayer * circle = [cell.CarRank layer];
    [circle setMasksToBounds:YES];
    [circle setCornerRadius:13.0];
    [circle setBorderWidth:1.5];
    
    if ([toptensObject.CarRank isEqualToString:@"1"])
        [circle setBorderColor:[[UIColor colorWithRed:(227/255.0) green:(205/255.0) blue:(79/255.0) alpha:1] CGColor]];
    else if ([toptensObject.CarRank isEqualToString:@"2"])
        [circle setBorderColor:[[UIColor colorWithRed:(175/255.0) green:(182/255.0) blue:(187/255.0) alpha:1] CGColor]];
    else if ([toptensObject.CarRank isEqualToString:@"3"])
        [circle setBorderColor:[[UIColor colorWithRed:(192/255.0) green:(108/255.0) blue:(39/255.0) alpha:1] CGColor]];
    else
        [circle setBorderColor:[[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] CGColor]];
    
    NSURL *imageURL;
    if([toptensObject.CarURL containsString:@"carno"])
        imageURL = [NSURL URLWithString:toptensObject.CarURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]];
    else
        imageURL = [NSURL URLWithString:toptensObject.CarURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];
    
    [cell.CarImage setImageWithURL:imageURL
            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                    [cell2.CarImage setAlpha:0.0];
                    [UIImageView animateWithDuration:.5 animations:^{
                    [cell2.CarImage setAlpha:1.0];
            }];
        }
       usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    return cell;
}

- (void)reloadData
{
    // Reload table data
    [self.tableView reloadData];
    [self.tableView numberOfRowsInSection:topTensArray.count];
    NSLog(@"made it");
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
