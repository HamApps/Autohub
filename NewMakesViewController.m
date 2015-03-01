//
//  NewMakesViewController.m
//  Carhub
//
//  Created by Christopher Clark on 2/28/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "NewMakesViewController.h"
#import "AppDelegate.h"
#import "MakeCell.h"
#import "BackgroundLayer.h"
#import "Make.h"
#import "Model.h"
#import "ModelViewController.h"
#import <QuartzCore/QuartzCore.h>

#define getMakeDataURL @"http://pl0x.net/CarMakesJSON.php"
#define getModelDataURL @"http://pl0x.net/CarHubJSON2.php"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface NewMakesViewController ()

@end

@implementation NewMakesViewController
@synthesize makeimageArray, currentMake, modelArray, appdelmodelArray, searchArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeAppDelModelArray];
    self.title = @"Makes";
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"whiteback.jpg"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return makeimageArray.count;
}

searchBar:(UISearchBar *)bar textDidChange:(NSString *)searchText
{
    
}
- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    //NSPredicate *resultsPredicate = [NSPredicate predicateWithFormat:@"SELF.CarModel contains [search] %@", searchText];
    NSPredicate *resultsPredicate = [NSPredicate predicateWithFormat:@"SELF.CarFullName contains [search] %@", searchText];
    self.searchArray = [[self.ModelArray filteredArrayUsingPredicate:resultsPredicate]mutableCopy];
    NSLog(@"searchArray %@", searchArray);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MakeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MakeReuseID" forIndexPath:indexPath];
    
    Make * makeObject;
    makeObject = [makeimageArray objectAtIndex:indexPath.item];
    
    NSString *identifier = [NSString stringWithFormat:@"MakeReuseID%ld" , (long)indexPath.row];
    NSString *urlIdentifier = [NSString stringWithFormat:@"imageurl%@", makeObject.MakeName];
    
    
    cell.layer.borderWidth=0.7f;
    cell.layer.borderColor=[UIColor whiteColor].CGColor;
    //cell.layer.cornerRadius = 10;
    
    cell.MakeNameLabel.text=makeObject.MakeName;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imagedata = [defaults objectForKey:identifier];
    [defaults setObject:[NSString stringWithFormat:@"%lu", (unsigned long)makeimageArray.count] forKey:@"count"];
    
    //NSLog([defaults objectForKey:urlIdentifier]);
    
    if([[defaults objectForKey:@"count"] integerValue] == [[NSString stringWithFormat:@"%lu", (unsigned long)makeimageArray.count] integerValue])
    {
        cell.MakeImageView.image = [UIImage imageWithData:imagedata];
        //[UIImageView beginAnimations:nil context:NULL];
        //[UIImageView setAnimationDuration:.75];
        [cell.MakeImageView setAlpha:1.0];
        //[UIImageView commitAnimations];
    }
    
    if(!([[defaults objectForKey:urlIdentifier] isEqualToString:makeObject.MakeImageURL])||cell.MakeImageView.image == nil){
        char const*s = [identifier UTF8String];
        dispatch_queue_t queue = dispatch_queue_create(s, 0);
        
        dispatch_async(queue, ^{
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:makeObject.MakeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image2.php"]]];
            if (imgData) {
                UIImage *image = [UIImage imageWithData:imgData];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MakeCell *updateCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
                        if (updateCell)
                        {
                            [defaults setObject:UIImagePNGRepresentation(image) forKey:identifier];
                            [defaults setObject:makeObject.MakeImageURL forKey:urlIdentifier];
                            NSData *imgdata = [defaults objectForKey:identifier];
                            updateCell.MakeImageView.image = [UIImage imageWithData:imgdata];
                            [updateCell.MakeImageView setAlpha:0.0];
                            [UIImageView beginAnimations:nil context:NULL];
                            [UIImageView setAnimationDuration:.75];
                            [updateCell.MakeImageView setAlpha:1.0];
                            [UIImageView commitAnimations];
                            
                        }
                    });
                }
            }
        });
    }
    
    
    return cell;
}



- (void)getfirstModel:(id)firstcarObject1;
{
    _firstCar1 = firstcarObject1;
}

- (void)getsecondModel:(id)secondcarObject1;
{
    _secondCar1 = secondcarObject1;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) makeAppDelModelArray;
{
    appdelmodelArray = [[NSMutableArray alloc]init];
    makeimageArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelmodelArray addObjectsFromArray:appdel.modelArray];
    
    makeimageArray = [[NSMutableArray alloc]init];
    [makeimageArray addObjectsFromArray:appdel.makeimageArray2];
}

@end
