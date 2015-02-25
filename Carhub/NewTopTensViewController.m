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

@interface NewTopTensViewController ()

@end

@implementation NewTopTensViewController
@synthesize jsonArray, topTensArray, currentTopTen, urlExtention;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set which Top Ten was picked
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    topTensArray = [[NSMutableArray alloc]init];
    self.title = currentTopTen;

    if([currentTopTen isEqualToString:@"Fastest 0-60's"])
        [topTensArray addObjectsFromArray:appdel.zt60Array];
    if([currentTopTen isEqualToString:@"Top Speeds"])
        [topTensArray addObjectsFromArray:appdel.topspeedArray];
    if([currentTopTen isEqualToString:@"Nürburgring Lap Times"])
        [topTensArray addObjectsFromArray:appdel.nurbArray];
    if([currentTopTen isEqualToString:@"Most Expensive"])
        [topTensArray addObjectsFromArray:appdel.expensiveArray];
    if([currentTopTen isEqualToString:@"Best Fuel Economy"])
        [topTensArray addObjectsFromArray:appdel.fuelArray];
    if([currentTopTen isEqualToString:@"Highest Horsepower"])
        [topTensArray addObjectsFromArray:appdel.horsepowerArray];
    
    NSLog(@"current top ten %@", currentTopTen);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return topTensArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"toptens";
    TopTensCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    TopTens * toptensObject = [topTensArray objectAtIndex:indexPath.row];
    
    cell.CarRank.text = toptensObject.CarRank;
    cell.CarName.text = toptensObject.CarName;
    cell.CarValue.text = toptensObject.CarValue;
    NSLog(@"CarName %@",toptensObject.CarName);
    
    
    
    cell.CarImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:toptensObject.CarURL relativeToURL:[NSURL URLWithString: @"http://pl0x.net/image.php"]]]];
    
    // Configure the cell...
    
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

-(void)getTopTenID:(id)TopTenID;
{
    currentTopTen = TopTenID;
    NSLog(@"currentTopTen %@",currentTopTen);
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
