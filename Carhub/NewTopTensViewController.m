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

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

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
    if([currentTopTen isEqualToString:@"Most Expensive"])
        [topTensArray addObjectsFromArray:appdel.expensiveArray];
    if([currentTopTen isEqualToString:@"Best Fuel Economy"])
        [topTensArray addObjectsFromArray:appdel.fuelArray];
    if([currentTopTen isEqualToString:@"Highest Horsepower"])
        [topTensArray addObjectsFromArray:appdel.horsepowerArray];
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
    
    if (cell == nil) {
        cell = [[TopTensCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
    }
    
    cell.CarRank.text = toptensObject.CarRank;
    cell.CarName.text = toptensObject.CarName;
    cell.CarValue.text = toptensObject.CarValue;
    
    NSString *identifier = [NSString stringWithFormat:@"%@", toptensObject.CarName];
    NSString *urlIdentifier = [NSString stringWithFormat:@"imageurl%@", toptensObject.CarName];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imagedata = [defaults objectForKey:identifier];
    [defaults setObject:[NSString stringWithFormat:@"%lu", (unsigned long)topTensArray.count] forKey:@"count"];
    
    if([[defaults objectForKey:@"count"] integerValue] == [[NSString stringWithFormat:@"%lu", (unsigned long)topTensArray.count] integerValue])
    {
        cell.CarImage.image = [UIImage imageWithData:imagedata];
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:.01];
        [cell.CarImage setAlpha:1.0];
        [UIImageView commitAnimations];
    }
    if(!([[defaults objectForKey:urlIdentifier] isEqualToString:toptensObject.CarURL]) || cell.CarImage.image == nil){
        char const*s = [identifier UTF8String];
        dispatch_queue_t queue = dispatch_queue_create(s, 0);
        
        dispatch_async(queue, ^{
            
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:toptensObject.CarURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]];
            if (imgData) {
                UIImage *image = [UIImage imageWithData:imgData];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        TopTensCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                        if (updateCell)
                        {
                            [defaults setObject:UIImagePNGRepresentation(image) forKey:identifier];
                            [defaults setObject:toptensObject.CarURL forKey:urlIdentifier];
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
    }
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
}

- (void) makeAppDelModelArray;
{
    appdelmodelArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelmodelArray addObjectsFromArray:appdel.modelArray];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
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
