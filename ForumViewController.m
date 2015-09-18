//
//  ForumViewController.m
//  Carhub
//
//  Created by Christopher Clark on 9/12/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "ForumViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "ForumCell.h"
#import "Post.h"

@interface ForumViewController ()

@end

@implementation ForumViewController
@synthesize appdelpostArray, postArray, searchBar, searchArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.barButton.target = self.revealViewController;
    self.barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
    self.view.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self makeAppDelPostArray];
    [self getPostArray];
    
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return postArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PostCell";

    ForumCell *cell = (ForumCell *)[self.tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    if (cell==nil) {
        cell = [[ForumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Post * postObject;
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        postObject = [self.searchArray objectAtIndex:indexPath.row];
        self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
        self.searchDisplayController.searchResultsTableView.separatorColor = [UIColor clearColor];
    } else {
        postObject = [self.postArray objectAtIndex:indexPath.row];
    }
    
    //Load and fade image
    /*[cell.CarImage sd_setImageWithURL:[NSURL URLWithString:modelObject.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                [cell.CarImage setAlpha:0.0];
                                [UIImageView animateWithDuration:.5 animations:^{
                                    [cell.CarImage setAlpha:1.0];
                                }];
                            }];*/
    cell.postDescription.text = postObject.postDescription;
    NSNumber *voteTotal = [NSNumber numberWithFloat:([postObject.upCount floatValue] - [postObject.downCount floatValue])];
    cell.voteTotalLabel.text = [voteTotal stringValue];
    
    return cell;

}

- (void) makeAppDelPostArray;
{
    appdelpostArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelpostArray addObjectsFromArray:appdel.postArray];
}

- (void) getPostArray;
{
    postArray = [[NSMutableArray alloc]init];
    postArray = appdelpostArray;
    NSLog(@"postarray %@", postArray);
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

@end
