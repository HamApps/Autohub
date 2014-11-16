//
//  NewsViewController.m
//  Carhub
//
//  Created by Christopher Clark on 8/22/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "NewsViewController.h"
#import "CarViewCell.h"
#import "News.h"
#import "NewsDetailViewController.h"
#import "AppDelegate.h"

#define kNSUSERDEFAULTSCAR @"nsuserdefaultscar"

#define getDataURL @"http://pl0x.net/CarNewsJSON.php"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface NewsViewController ()

@end

@implementation NewsViewController

@synthesize jsonArray, newsArray, cachedImages;

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
    
    self.title = @"Auto News";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //Load Data
    
    //[self retrieveData];
    [self makeAppDelNewsArray];
    NSLog(@"%@", newsArray);
    self.cachedImages = [[NSMutableDictionary alloc]init];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"Metal Background.jpg"]];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    //return newsArray.count;
    return newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"NewsCell";
    CarViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    News * newsObject;
    newsObject = [newsArray objectAtIndex:indexPath.row];
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[CarViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
    }
    
    cell.CarName.text = newsObject.NewsTitle;
    //cell.CarImage.image = nil;
    cell.NewsDescription.text = newsObject.NewsDescription;
    //Accessory
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.layer.borderWidth=1.0f;
    cell.layer.borderColor=[UIColor blackColor].CGColor;
    cell.CarName.layer.borderWidth=1.0f;
    cell.CarName.layer.borderColor=[UIColor whiteColor].CGColor;
    
    NSString *identifier = [NSString stringWithFormat:@"ModelCell%ld" , (long)indexPath.row];
    cell.CarImage.image = [self.cachedImages valueForKey:identifier];
    
    if([self.cachedImages objectForKey:identifier] !=nil){
        cell.CarImage.image = [self.cachedImages valueForKey:identifier];
    }else{
        
        char const*s = [identifier UTF8String];
        dispatch_queue_t queue = dispatch_queue_create(s, 0);

    
        dispatch_async(queue, ^{
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:newsObject.NewsImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/newsimage.php"]]];
            if (imgData) {
                UIImage *image = [UIImage imageWithData:imgData];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CarViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                        
                        if (updateCell)
                            [self.cachedImages setValue:image forKey:identifier];
                        updateCell.CarImage.image = [self.cachedImages valueForKey:identifier];
                        updateCell.CarImage.image = image;
                        //UIImage *cachedimage = image;
                        [UIImageView beginAnimations:nil context:NULL];
                        [UIImageView setAnimationDuration:.75];
                        [updateCell.CarImage setAlpha:1.0];
                        [UIImageView commitAnimations];
                        
                    });
                }
            }
        });
        
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushNewsDetailView"])
    {
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        
        //Get the object for the selected row
        News * object = [newsArray objectAtIndex:indexPath.row];
        [[segue destinationViewController] getNews:object];
    }
    
}



- (void) retrieveData;
{
    NSURL * url = [NSURL URLWithString:getDataURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    
    //Set up our cities arrray
    newsArray = [[NSMutableArray alloc] init];
    
    //Loop through ourjsonArray
    for (int i=0; i < jsonArray.count; i++)
    {
        //Create our city object
        NSString * nTitle = [[jsonArray objectAtIndex:i] objectForKey:@"Title"];
        NSString * nImageURL = [[jsonArray objectAtIndex:i] objectForKey:@"ImageURL"];
        NSString * nDescription = [[jsonArray objectAtIndex:i] objectForKey:@"Description"];
        NSString * nArticle = [[jsonArray objectAtIndex:i] objectForKey:@"Article"];
    
        //Add the city object to our cities array
        [newsArray addObject:[[News alloc]initWithNewsTitle:nTitle andNewsImageURL:nImageURL andNewsDescription:nDescription andNewsArticle:nArticle]];
    }
}

- (void) makeAppDelNewsArray;
{
    newsArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSLog(@"appdelarray2: %@", appdel.newsArray);
    [newsArray addObjectsFromArray:appdel.newsArray];
    NSLog(@"appdelarray3: %@", newsArray);
    
}



@end
