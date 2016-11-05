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
#import "DisputeInfoViewController.h"
#import <Google/Analytics.h>

@interface NewTopTensViewController ()

@end

@implementation NewTopTensViewController
@synthesize jsonArray, topTensArray, currentTopTen, urlExtention, appdelmodelArray, objectToSend, sendingIndex, detailImageScroller, detailView, detailCell, initialCellFrame, initialScrollerFrame, titleString, tableView, yCenter, yCenterModel;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    //Set which Top Ten was picked
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    topTensArray = [[NSMutableArray alloc]init];
    self.title = currentTopTen;
    titleString = self.title;
    [self makeAppDelModelArray];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:self.title];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

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
    
    yCenter = 0;
    yCenterModel = 0;
    int height = [UIScreen mainScreen].bounds.size.height;
    if (height == 480) {
        yCenter = 180;
        yCenterModel = 200;
    } if (height == 568) {
        yCenter = 180;
        yCenterModel = 200;
    } if (height == 667) {
        yCenter = 200;
        yCenterModel = 220;
    } if (height == 736) {
        yCenter = 208;
        yCenterModel = 230;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return topTensArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"toptens";
    TopTensCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    TopTens * toptensObject = [topTensArray objectAtIndex:indexPath.row];
    
    if (cell == nil)
    {
        cell = [[TopTensCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
    }
    cell.CarRank.text = toptensObject.CarRank;
    cell.CarName.text = toptensObject.CarName;
    cell.CarValue.text = toptensObject.CarValue;
    
     NSString *urlString = [toptensObject.CarRank stringByAppendingString:@".png"];
    [cell.RankImageView setImage:[self resizeImage:[UIImage imageNamed:urlString] reSize:cell.RankImageView.frame.size]];
    
    Model * modelObject = [self findModel:toptensObject];
    
    [cell setUpCarImageWithModel:modelObject];
    
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedImage:)];
    [cell addGestureRecognizer:tapImage];
    
    cell.CarName.text = modelObject.CarFullName;
    
    return cell;
}

- (void) makeAppDelModelArray;
{
    appdelmodelArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelmodelArray addObjectsFromArray:appdel.modelArray];
}

-(Model *)findModel:(TopTens *)topTensObject
{
    Model *object;
    for(int i=0;i<appdelmodelArray.count;i++)
    {
        Model * currentObj = [appdelmodelArray objectAtIndex:i];
        NSString * cURL = currentObj.CarImageURL;
        if([topTensObject.CarURL isEqualToString:cURL])
        {
            object = currentObj;
            break;
        }
    }
    return object;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    sendingIndex = indexPath;
    [self pushDetailWithIndexPath:indexPath];
}

-(void)tappedImage:(UITapGestureRecognizer *)sender
{
    UIView *view = sender.view;
    CGPoint hitPoint = [view convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    [self.tableView selectRowAtIndexPath:hitIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:hitIndex];
}

-(void)pushDetailWithIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    TopTensCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    detailCell = selectedCell;
    detailImageScroller = selectedCell.imageScroller2;
    Model *pushingObject = [self findModel:[topTensArray objectAtIndex:indexPath.row]];
    objectToSend = pushingObject;
    
    [detailCell.imageScroller2 setAlpha:.5];
    [detailCell.CarName setAlpha:.5];
    [detailCell.CarRank setAlpha:.5];
    [detailCell.CarValue setAlpha:.5];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [detailCell.imageScroller2 setAlpha:1];
        [detailCell.CarName setAlpha:1];
        [detailCell.CarRank setAlpha:1];
        [detailCell.CarValue setAlpha:1];
    });
    
    CGRect newFrame = [self.view convertRect:selectedCell.frame fromView:selectedCell.superview];
    initialCellFrame = newFrame;
    initialScrollerFrame = selectedCell.imageScroller2.frame;
    CGRect newFrame2 = [self.view convertRect:selectedCell.imageScroller2.frame fromView:selectedCell.imageScroller2.superview];
    [self.view addSubview:selectedCell];
    [self.view addSubview:detailImageScroller];
    [selectedCell setFrame:newFrame];
    [detailImageScroller setFrame:newFrame2];
    
    [UIView animateWithDuration:.5 animations:^{
        [self.tableView setAlpha:0.0];
        [selectedCell setAlpha:0.0];
        [selectedCell setCenter:CGPointMake(self.view.frame.size.width/2, yCenter)];
        [detailImageScroller setCenter:CGPointMake(self.view.frame.size.width/2, yCenter)];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [self setTitleLabelWithString:pushingObject.CarMake];
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit46.png"] style:UIBarButtonItemStyleDone target:self action:@selector(pushSpecsDispute)];
        item.tintColor = [UIColor blackColor];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:NULL];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
        [self.navigationItem setRightBarButtonItem:item];
        
        detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        detailView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        detailView.view.alpha = 0.0;
        
        [detailView getCarToLoad:pushingObject sender:self];
        
        [UIView animateWithDuration:1 animations:^{
            [self addChildViewController:detailView];
            [self.view addSubview:detailView.view];
            [self.view sendSubviewToBack:detailView.view];
            [detailView didMoveToParentViewController:self];
            detailView.view.alpha = 1.0;
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            CGRect newFrame = [detailView.specsCollectionView convertRect:detailImageScroller.frame fromView:self.view];
            [detailView.specsCollectionView addSubview:detailImageScroller];
            [detailImageScroller setFrame:newFrame];
            [backButton setAction:@selector(revertToTopTensPage)];
            
            UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedDown:)];
            downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
            [detailImageScroller addGestureRecognizer:downSwipe];
            [detailView.specsCollectionView.panGestureRecognizer requireGestureRecognizerToFail:downSwipe];
            
            UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:detailView action:@selector(tappedImage:)];
            [detailImageScroller addGestureRecognizer:tapImage];
        });
    });
}

-(void)removeDownSwipe
{
    for (UIGestureRecognizer *recognizer in detailImageScroller.gestureRecognizers)
    {
        [detailImageScroller removeGestureRecognizer:recognizer];
    }
}

-(void)swipedDown:(UISwipeGestureRecognizer *)sender
{
    [self revertToTopTensPage];
}

-(void)revertToTopTensPage
{
    [UIView animateWithDuration:0.5 animations:^{
        [detailCell setFrame:initialCellFrame];
    }];
    
    CGRect frameInView = [self.view convertRect:detailImageScroller.frame fromView:detailView.view];
    [self.view addSubview:detailImageScroller];
    [detailImageScroller setFrame:frameInView];
    [detailImageScroller setFrame:initialScrollerFrame];
    [detailCell.cardView addSubview:detailImageScroller];
    [self removeDownSwipe];
    [detailCell lineViewSetUp];
    [detailCell setAlpha:1.0];
    [detailView.view setAlpha:0.0];
    [self.tableView setAlpha:1.0];
    
    [self setTitleLabelWithString:titleString];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:self.title];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [self.navigationItem setLeftBarButtonItems:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
    backButton.tintColor = [UIColor blackColor];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -9;
    [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit46.png"] style:UIBarButtonItemStyleDone target:self action:@selector(pushSpecsDispute)];
    item.tintColor = [UIColor blackColor];
    [self.navigationItem setRightBarButtonItem:item];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        CGRect cellFrameInTable = [self.tableView convertRect:detailCell.frame fromView:self.view];
        [detailCell setFrame:cellFrameInTable];
        [self.tableView addSubview:detailCell];
        
        [detailView didMoveToParentViewController:nil];
        [detailView.view removeFromSuperview];
        [detailView removeFromParentViewController];
    });
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setTitleLabelWithString:(NSString *)title
{
    [self setTitle:title];
}

- (UIImage*)resizeImage:(UIImage*)aImage reSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [aImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)pushSpecsDispute
{
    [self performSegueWithIdentifier:@"pushSpecsDispute" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

-(void)getTopTenID:(id)TopTenID;
{
    currentTopTen = TopTenID;
}

- (IBAction)unwindToTopTens:(UIStoryboardSegue *)segue
{
    [self revertToTopTensPage];
}

@end
