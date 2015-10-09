//
//  RaceTypeViewController.m
//  Carhub
//
//  Created by Christopher Clark on 9/21/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "RaceTypeViewController.h"
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "NewsCell.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "CarViewCell.h"
#import "RaceType.h"

@interface RaceTypeViewController ()

@end

@implementation RaceTypeViewController
@synthesize raceTypeArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.barButton.target = self.revealViewController;
    self.barButton.action = @selector(revealToggle:);
    self.title = @"Race Types";
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //Load Data
    [self makeAppDelRaceTypeArray];
    NSLog(@"race type array: %@", raceTypeArray);
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
    return raceTypeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 183;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ModelCell";
    CarViewCell *cell = (CarViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[CarViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    RaceType * raceTypeObject;
    
    raceTypeObject = [self.raceTypeArray objectAtIndex:indexPath.row];
    
    NSLog(@"race type array: %@", raceTypeObject);


    //Load and fade image
    [cell.CarImage sd_setImageWithURL:[NSURL URLWithString:raceTypeObject.TypeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                [cell.CarImage setAlpha:0.0];
                                [UIImageView animateWithDuration:.5 animations:^{
                                    [cell.CarImage setAlpha:1.0];
                                }];
                            }];
    cell.CarName.text = raceTypeObject.RaceTypeString;
    
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

- (void) makeAppDelRaceTypeArray;
{
    raceTypeArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [raceTypeArray addObjectsFromArray:appdel.raceTypeArray];
}

@end
