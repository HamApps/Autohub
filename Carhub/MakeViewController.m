//
//  MakeViewController.m
//  Carhub
//
//  Created by Christopher Clark on 8/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "AppDelegate.h"
#import "MakeViewController.h"
#import "MakeCell.h"
#import "BackgroundLayer.h"
#import "Make.h"
#import "Model.h"
#import "ModelViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "SWRevealViewController.h"

@interface MakeViewController ()

@end

@implementation MakeViewController
@synthesize makeimageArray, currentMake, modelArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
    
    self.barButton.target = self.revealViewController;
    self.barButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    [self makeAppDelMakeArray];
    self.title = @"Makes";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return makeimageArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MakeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MakeReuseID" forIndexPath:indexPath];
    Make * makeObject;
    makeObject = [makeimageArray objectAtIndex:indexPath.item];
    
    //UI stuff
    cell.layer.borderWidth=0.6f;
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    //Load and fade image
    [cell.MakeImageView sd_setImageWithURL:[NSURL URLWithString:makeObject.MakeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image2.php"]]
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                        [cell.MakeImageView setAlpha:0.0];
                        [UIImageView animateWithDuration:.5 animations:^{
                        [cell.MakeImageView setAlpha:1.0];
                    }];
                }];
    
    cell.MakeNameLabel.text=makeObject.MakeName;
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushModelView"])
    {
        NSIndexPath * indexPath = [self.collectionView indexPathForCell:sender];
        Make * makeobject = [makeimageArray objectAtIndex:indexPath.row];
        [[segue destinationViewController] getMake:makeobject];
    }
}

- (void) makeAppDelMakeArray;
{
    makeimageArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [makeimageArray addObjectsFromArray:appdel.makeimageArray2];
}

@end
