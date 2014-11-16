//
//  FavoritesViewController.m
//  Carhub
//
//  Created by Christopher Clark on 8/23/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "FavoritesViewController.h"
#import "DetailViewController.h"
#import "CarViewCell.h"
#import "Model.h"
#import "AppDelegate.h"
#import "FavoritesClass.h"
#import "Model.h"

#define kNSUSERDEFAULTSCAR @"nsuserdefaultscar"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

@synthesize FavoriteCar, favoritesarray, defaultsarray, TestLabel;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog (@"favoritecar%@", [defaults objectForKey:kNSUSERDEFAULTSCAR]);
    Model *favorite = [[Model alloc]init];
    favorite = [self readFavoriteObjectWithKey:kNSUSERDEFAULTSCAR];
    self.title = favorite.CarModel;
    
    favoritesarray = [[NSMutableArray alloc]init];
    [favoritesarray addObject:favorite];
    
    defaultsarray = [[NSMutableArray alloc]init];
    defaultsarray = [defaults objectForKey:@"favoritesarray"];
    
    self.TestLabel.text = FavoriteCar.CarModel;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:defaultsarray];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"defaultsarray"];
    
    NSLog (@"defaultsfavoritesarray: %@", [defaults objectForKey:@"favoritesarray"]);
    NSLog (@"defaultsarray: %@", defaultsarray);
    NSLog (@"favoritesarray: %@", favoritesarray);
    NSLog(@"favorite%@", favorite);
    NSLog(@"defaultsarraycount%lu", (unsigned long)defaultsarray.count);
    NSLog(@"favoritecar%@", FavoriteCar);
    NSLog (@"defaultsarray: %@", defaultsarray);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    static NSString *CellIdentifier = @"FavoritesCell";
    [self.tableView registerClass:[CarViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    favoritesarray = [[NSMutableArray alloc]init];
    [self loadcars];
    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    Model *favorite = [[Model alloc]init];
    favorite = [self readFavoriteObjectWithKey:kNSUSERDEFAULTSCAR];
    
    
    favoritesarray = [[NSMutableArray alloc]init];
    [favoritesarray addObject:favorite];

}

- (Model *)readFavoriteObjectWithKey:(NSString *)key
{
    NSData *favoriteobject = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    Model *favorite = [NSKeyedUnarchiver unarchiveObjectWithData:favoriteobject];
    return favorite;
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
    //return defaultsarray.count;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    defaultsarray = [[NSMutableArray alloc]init];
    defaultsarray = [defaults objectForKey:@"favoritesarray"];
    return defaultsarray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    CarViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    defaultsarray = [[NSMutableArray alloc]init];
    defaultsarray = [defaults objectForKey:@"favoritesarray"];
    
    //NSData *defaultarray = [defaults objectForKey:@"favoritesarray"];
    //Model *favorite = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"favoritesarray"]];
    
    
    FavoriteCar = [defaultsarray objectAtIndex:indexPath.row];

    FavoriteCar = [self readFavoriteObjectWithKey:kNSUSERDEFAULTSCAR];
    

    
    //cell.CarName.text  = FavoriteCar.CarModel;
    //cell.CarName.text = favorite.CarModel;
    cell.CarImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:FavoriteCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]]];
    
    //Accessory
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.layer.borderWidth=1.0f;
    cell.layer.borderColor=[UIColor blackColor].CGColor;
    cell.CarName.layer.borderWidth=1.0f;
    cell.CarName.layer.borderColor=[UIColor whiteColor].CGColor;
    
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


-(void)loadcars;
{
    //[favoritesarray addObject:FavoriteCar];
    NSLog (@"favoritesarray%@", favoritesarray);
    NSArray *savedarray2 = [[NSArray alloc]initWithArray:favoritesarray];
    NSLog (@"savedarray2%@", savedarray2);
    NSLog (@"savedarray%@", favoritesarray);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults synchronize];
    
    
    
    //FavoritesViewController *favorites = [[FavoritesViewController alloc]init];
    //favorites.favoritesarray = [[NSMutableArray alloc]init];
    //[favorites.favoritesarray addObject:_currentCararray];
    //NSLog(@"Favoritesarray%@", favorites.favoritesarray);

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
