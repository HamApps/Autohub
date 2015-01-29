//
//  MakeViewControllerwAds.m
//  Carhub
//
//  Created by Christopher Clark on 1/28/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "MakeViewControllerwAds.h"
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

@interface MakeViewControllerwAds ()

@end

@implementation MakeViewControllerwAds
@synthesize makeimageArray, currentMake, modelArray, appdelmodelArray;

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
    [self makeAppDelModelArray];
    self.title = @"Makes";
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"whiteback.jpg"]];
}

- (void)didReceiveMemoryWarning
{
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
    [defaults setObject:[NSString stringWithFormat:@"%i", makeimageArray.count] forKey:@"count"];
    
    //NSLog([defaults objectForKey:urlIdentifier]);
    
    if([[defaults objectForKey:@"count"] integerValue] == [[NSString stringWithFormat:@"%i", makeimageArray.count] integerValue])
    {
        cell.MakeImageView.image = [UIImage imageWithData:imagedata];
        //[UIImageView beginAnimations:nil context:NULL];
        //[UIImageView setAnimationDuration:.75];
        [cell.MakeImageView setAlpha:1.0];
        //[UIImageView commitAnimations];
        NSLog(@"first loop");
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
                            NSLog(@"second loop");
                            
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Get the new view controller using [seguedestinationviewcontroller]
    if ([[segue identifier] isEqualToString:@"pushModelView"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
        [[segue destinationViewController] getmodelarray:modelArray];
        
        NSIndexPath * indexPath = [self.collectionView indexPathForCell:sender];
        Make * makeobject = [makeimageArray objectAtIndex:indexPath.row];
        //Make * modelobject = currentMake;
        [[segue destinationViewController] getMake:makeobject];
    }
}

- (void) makeAppDelModelArray;
{
    appdelmodelArray = [[NSMutableArray alloc]init];
    makeimageArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"appdelarray2: %@", appdel.modelArray);
    [appdelmodelArray addObjectsFromArray:appdel.modelArray];
    NSLog(@"appdelarray3: %@", appdelmodelArray);
    
    makeimageArray = [[NSMutableArray alloc]init];
    [makeimageArray addObjectsFromArray:appdel.makeimageArray2];
}

@end
