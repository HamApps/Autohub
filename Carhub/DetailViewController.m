//
//  DetailViewController.m
//  Carhub
//
//  Created by Christopher Clark on 7/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "DetailViewController.h"
#import "BackgroundLayer.h"
#import "AppDelegate.h"
#import "ModelViewController.h"
#import "FavoritesViewController.h"
#import "TopTensViewController.h"
#import "Model.h"
#import "ImageViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "SpecsCell.h"
#import "SWRevealViewController.h"
#import "CircleProgressBar.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "SDImageCache.h"
#import "NewMakesViewController.h"
#import "Currency.h"
#import "NewMakesViewController.h"
#import "TestViewController.h"
#import "NewTopTensViewController.h"
#import "SpecsCollectionCell.h"
#import "SpecsToolbarHeader.h"
#import "Make.h"
#import "UIImage+ImageEffects.h"
#import "FXBlurView.h"
#import "SearchModelController.h"
#import "SearchTabViewController.h"
#import <Google/Analytics.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize savedArray, currentCar, activityIndicator, isPlaying, hasCalled, shouldLoadImage, shouldAnimateCell, firstCar, secondCar, activityIndicator1, activityIndicator2, isplaying1, isplaying2, shouldRevertToDetail, specImageDetailCenter, currencySymbol, hpUnit, speedUnit, weightUnit, fuelEconomyUnit, cameFromMakes, cameFromTopTens, cameFromFavorites, specsCollectionView, borderView, initialBorderFrame, makeImageView, blurView, torqueUnit, shouldBeCompare, cellWidth, shouldBeDetail, makeImageView1, makeImageView2, cameFromModel, cameFromHome, cameFromSearchTab, cameFromSearchModel, detailImageScroller, avAudioPlayer, avAudioPlayer1, avAudioPlayer2, hasLoaded, hasLoaded1, hasLoaded2, exhaustButton1, exhaustButton2, makeImageContainer, shouldFadeMakeImage, specsHeaderView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark View/Initial Loading Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator1 = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator2 = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    specsCollectionView.dataSource = self;
    specsCollectionView.delegate = self;
    
    shouldBeDetail = YES;
    shouldFadeMakeImage = YES;
    cellWidth = specsCollectionView.frame.size.width/2;
    
    if(cameFromMakes)
    {
        NewMakesViewController *superView = (NewMakesViewController *)self.parentViewController;
        detailImageScroller = superView.detailImageScroller;
    }
    if(cameFromModel)
    {
        ModelViewController *superView = (ModelViewController *)self.parentViewController;
        detailImageScroller = superView.detailImageScroller;
    }
    if(cameFromTopTens)
    {
        NewTopTensViewController *superView = (NewTopTensViewController *)self.parentViewController;
        detailImageScroller = superView.detailImageScroller;
    }
    if(cameFromFavorites)
    {
        FavoritesViewController *superView = (FavoritesViewController *)self.parentViewController;
        detailImageScroller = superView.detailImageScroller;
    }
    if(cameFromSearchModel)
    {
        SearchModelController *superView = (SearchModelController *)self.parentViewController;
        detailImageScroller = superView.detailImageScroller;
    }
    if(cameFromSearchTab)
    {
        SearchTabViewController *superView = (SearchTabViewController *)self.parentViewController;
        detailImageScroller = superView.detailImageScroller;
    }
    
    if(detailImageScroller != nil)
    {
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedImage:)];
        [detailImageScroller addGestureRecognizer:tapImage];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setTitleLabelWithString:currentCar.CarMake andView:self];
    
    [specsCollectionView reloadData];
    
    CALayer *layer = borderView.layer;
    [layer setMasksToBounds:NO];
    [specsCollectionView.layer setMasksToBounds:NO];
    [layer setCornerRadius:8.0];
    layer.shadowOffset = CGSizeMake(-.2f, .2f);
    layer.shadowRadius = 1.5;
    layer.shadowOpacity = .5;
    
    specsCollectionView.backgroundColor = [UIColor clearColor];
    specsCollectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    initialBorderFrame = borderView.frame;
    
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)viewWillAppear:(BOOL)animated
{
    [specsCollectionView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [specsCollectionView reloadData];
    
    avAudioPlayer = nil;
    hasCalled = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == specsCollectionView)
    {
        float scrollViewHeight = scrollView.frame.size.height;
        float scrollContentSizeHeight = scrollView.contentSize.height;
        float scrollOffset = scrollView.contentOffset.y;
        
        CGPoint currentPosition = scrollView.contentOffset;
        
        if(currentPosition.y > 0)
        {
            [borderView setFrame:CGRectMake(7, initialBorderFrame.origin.y - currentPosition.y, borderView.frame.size.width, initialBorderFrame.size.height + currentPosition.y)];
        }
        
        if(currentPosition.y <= 0)
        {
            [borderView setFrame:CGRectMake(7, initialBorderFrame.origin.y - currentPosition.y, borderView.frame.size.width, initialBorderFrame.size.height - currentPosition.y)];
        }
        
        if (scrollOffset + scrollViewHeight >= scrollContentSizeHeight-2)
        {
            [borderView setFrame:CGRectMake(7, borderView.frame.origin.y, borderView.frame.size.width, borderView.frame.size.height - 20)];
        }
    }
}

-(void)setUpMakeBackgroundImage
{
    if([currentCar.RemoveLogo isEqualToNumber:[NSNumber numberWithInteger:1]])
        return;
    
    [UIImageView animateWithDuration:0.5 animations:^{
        [makeImageView1 sd_cancelCurrentImageLoad];
        [makeImageView2 sd_cancelCurrentImageLoad];
        [makeImageView1 setAlpha:0.0];
        [makeImageView2 setAlpha:0.0];
    }];
    
    blurView.blurRadius = 8;
    
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Make *makeToUse;
    for(int i=0; i<appdel.makeimageArray2.count; i++)
    {
        Make *currentMake = [appdel.makeimageArray2 objectAtIndex:i];
        if([currentCar.CarMake isEqualToString:currentMake.MakeName])
        {
            makeToUse = currentMake;
            break;
        }
    }
    
    NSURL *imageURL;
    if([makeToUse.MakeImageURL containsString:@"carno"])
        imageURL = [NSURL URLWithString:makeToUse.MakeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image2.php"]];
    else
        imageURL = [NSURL URLWithString:makeToUse.MakeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];
    
    [makeImageView sd_setImageWithURL:imageURL
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                 
                                 if(shouldFadeMakeImage)
                                 {
                                    [makeImageContainer setAlpha:0];
                                    [makeImageView setAlpha:0];
                                    [UIImageView animateWithDuration:0.5 animations:^{
                                        [makeImageView setAlpha:1];
                                        [makeImageContainer setAlpha:1];
                                        shouldFadeMakeImage = NO;
                                    }];
                                 }else{
                                     [makeImageView setAlpha:1];
                                 }
                             }];
}

-(void)setUpCompareMakeBackgroundImages
{
    [UIImageView animateWithDuration:0.5 animations:^{
        [makeImageView sd_cancelCurrentImageLoad];
        [makeImageView setAlpha:0.0];
    }];
    
    blurView.blurRadius = 8;
    
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Make *makeToUse1;
    Make *makeToUse2;
    
    for(int i=0; i<appdel.makeimageArray2.count; i++)
    {
        Make *currentMake = [appdel.makeimageArray2 objectAtIndex:i];
        if([firstCar.CarMake isEqualToString:currentMake.MakeName])
        {
            makeToUse1 = currentMake;
            break;
        }
    }
    
    for(int i=0; i<appdel.makeimageArray2.count; i++)
    {
        Make *currentMake = [appdel.makeimageArray2 objectAtIndex:i];
        if([secondCar.CarMake isEqualToString:currentMake.MakeName])
        {
            makeToUse2 = currentMake;
            break;
        }
    }
    
    if(makeToUse1 == makeToUse2)
    {
        [self setUpMakeBackgroundImage];
        return;
    }
    
    if([firstCar.RemoveLogo isEqualToNumber:[NSNumber numberWithInteger:0]])
    {
        NSURL *imageURL1;
        if([makeToUse1.MakeImageURL containsString:@"carno"])
            imageURL1 = [NSURL URLWithString:makeToUse1.MakeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image2.php"]];
        else
            imageURL1 = [NSURL URLWithString:makeToUse1.MakeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];
        
        [makeImageView1 sd_setImageWithURL:imageURL1
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                     
                                     [makeImageContainer setAlpha:0];
                                     [makeImageView1 setAlpha:0];
                                     [UIImageView animateWithDuration:0.5 animations:^{
                                         [makeImageView1 setAlpha:1];
                                         [makeImageContainer setAlpha:1];
                                     }];
                                     
                                 }];
    }
    
    if([secondCar.RemoveLogo isEqualToNumber:[NSNumber numberWithInteger:0]])
    {
        NSURL *imageURL2;
        if([makeToUse2.MakeImageURL containsString:@"carno"])
            imageURL2 = [NSURL URLWithString:makeToUse2.MakeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image2.php"]];
        else
            imageURL2 = [NSURL URLWithString:makeToUse2.MakeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];
        
        [makeImageView2 sd_setImageWithURL:imageURL2
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                     
                                     [makeImageContainer setAlpha:0];
                                     [makeImageView2 setAlpha:0];
                                     [UIImageView animateWithDuration:0.5 animations:^{
                                         [makeImageView2 setAlpha:1];
                                         [makeImageContainer setAlpha:1];
                                     }];
                                     
                                 }];
    }
}

-(IBAction)Website
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:currentCar.CarWebsite]];
}

#pragma mark Collection View Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        SpecsToolbarHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        specsHeaderView = headerView;
        
        exhaustButton1 = headerView.exhaustButton;
        exhaustButton2 = headerView.saveButton;

        if(shouldBeCompare)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setUpCompareMakeBackgroundImages];
            });
            
            [headerView.exhaustButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [headerView.compareButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [headerView.websiteButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [headerView.saveButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            
            [headerView.exhaustButton addTarget:self action:@selector(Sound1:) forControlEvents:UIControlEventTouchUpInside];
            [headerView.compareButton addTarget:self action:@selector(changeCar1) forControlEvents:UIControlEventTouchUpInside];
            [headerView.websiteButton addTarget:self action:@selector(changeCar2) forControlEvents:UIControlEventTouchUpInside];
            [headerView.saveButton addTarget:self action:@selector(Sound2:) forControlEvents:UIControlEventTouchUpInside];
            
            [headerView setCompareImagesWithFirstModel:firstCar andSecondModel:secondCar];
            [headerView.detailImageScroller setAlpha:0];
            [headerView.carNameLabel setAlpha:0];
            
            [headerView.firstCarNameLabel setText:firstCar.CarModel];
            [headerView.secondCarNameLabel setText:secondCar.CarModel];
            [headerView.firstCarNameLabel setAlpha:1];
            [headerView.secondCarNameLabel setAlpha:1];
            
            if(!isplaying1)
                [headerView.exhaustButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Play.png"]reSize:headerView.compareButton.frame.size] forState:UIControlStateNormal];
            [headerView.compareButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"ChangeCar1"]reSize:headerView.compareButton.frame.size] forState:UIControlStateNormal];
            [headerView.websiteButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"ChangeCar2"]reSize:headerView.compareButton.frame.size] forState:UIControlStateNormal];
            if(!isplaying2)
                [headerView.saveButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Play.png"]reSize:headerView.compareButton.frame.size] forState:UIControlStateNormal];
            
            if([firstCar.CarExhaust isEqualToString:@""])
                [headerView.exhaustButton setAlpha:.35];
            else if(!hasLoaded1)
            {
                [headerView.exhaustButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Circle.png"]reSize:headerView.compareButton.frame.size] forState:UIControlStateNormal];
                if(firstCar != NULL)
                    [headerView startExhaustLoadingWheel];
            }
            
            if([secondCar.CarExhaust isEqualToString:@""])
                [headerView.saveButton setAlpha:.35];
            else if(!hasLoaded2)
            {
                [headerView.saveButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Circle.png"]reSize:headerView.compareButton.frame.size] forState:UIControlStateNormal];
                if(secondCar != NULL)
                    [headerView startExhaustLoadingWheel2];
            }
        
            [headerView.exhaustLabel setText:@"Exhaust 1"];
            [headerView.compareLabel setText:@"Change Car 1"];
            [headerView.websiteLabel setText:@"Change Car 2"];
            [headerView.favoriteLabel setText:@"Exhaust 2"];
            
            UITapGestureRecognizer *tapImage1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedImage1:)];
            [headerView.pushCar1ImageButton addGestureRecognizer:tapImage1];
            UITapGestureRecognizer *tapImage2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedImage2:)];
            [headerView.pushCar2ImageButton addGestureRecognizer:tapImage2];
            
            [headerView bringSubviewToFront:headerView.pushCar2ImageButton];
            [headerView bringSubviewToFront:headerView.pushCar1ImageButton];
            
            for (UIGestureRecognizer *recognizer in headerView.pushDetailImageButton.gestureRecognizers)
                [headerView.pushDetailImageButton removeGestureRecognizer:recognizer];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(setUpMakeBackgroundImage) withObject:nil waitUntilDone:NO];

            
            [headerView.exhaustButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [headerView.compareButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [headerView.websiteButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [headerView.saveButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            
            [headerView.exhaustButton addTarget:self action:@selector(Sound:) forControlEvents:UIControlEventTouchUpInside];
            [headerView.compareButton addTarget:self action:@selector(Compare) forControlEvents:UIControlEventTouchUpInside];
            [headerView.websiteButton addTarget:self action:@selector(Website) forControlEvents:UIControlEventTouchUpInside];
            [headerView.saveButton addTarget:self action:@selector(Save) forControlEvents:UIControlEventTouchUpInside];
            
            if(!isPlaying)
                [headerView.exhaustButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Play.png"]reSize:headerView.compareButton.frame.size] forState:UIControlStateNormal];
            [headerView.compareButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Compare.png"]reSize:headerView.compareButton.frame.size] forState:UIControlStateNormal];
            [headerView.websiteButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Website.png"]reSize:headerView.compareButton.frame.size] forState:UIControlStateNormal];
            [headerView.saveButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Favorite.png"]reSize:headerView.compareButton.frame.size] forState:UIControlStateNormal];
            
            if([currentCar.CarExhaust isEqualToString:@""])
                [headerView.exhaustButton setAlpha:.35];
            else if(!hasLoaded)
            {
                [headerView.exhaustButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Circle.png"]reSize:headerView.exhaustButton.frame.size] forState:UIControlStateNormal];
                [headerView startExhaustLoadingWheel];
            }
            
            [headerView.exhaustLabel setText:@"Exhaust"];
            [headerView.compareLabel setText:@"Compare"];
            [headerView.websiteLabel setText:@"Website"];
            [headerView.favoriteLabel setText:@"Favorite"];
            
            if([self isSaved:currentCar] == true)
                [headerView.saveButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"FavoriteFilled.png"]reSize:headerView.compareButton.frame.size] forState:UIControlStateNormal];
            else
                [headerView.saveButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Favorite.png"]reSize:headerView.compareButton.frame.size] forState:UIControlStateNormal];
            
            [headerView.carNameLabel setText:currentCar.CarModel];
            [headerView.carNameLabel setAlpha:1];
            [headerView.firstCarNameLabel setAlpha:0];
            [headerView.secondCarNameLabel setAlpha:0];
            
            if(shouldLoadImage)
                [headerView setUpDetailCarImageWithModel:currentCar];
            
            [headerView.firstImageScroller setAlpha:0];
            [headerView.secondImageScroller setAlpha:0];
            
            UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedImage:)];
            [headerView.pushDetailImageButton addGestureRecognizer:tapImage];
            
            [headerView bringSubviewToFront:headerView.pushDetailImageButton];
            
            for (UIGestureRecognizer *recognizer in headerView.pushCar1ImageButton.gestureRecognizers)
                [headerView.pushCar1ImageButton removeGestureRecognizer:recognizer];
            for (UIGestureRecognizer *recognizer in headerView.pushCar2ImageButton.gestureRecognizers)
                [headerView.pushCar2ImageButton removeGestureRecognizer:recognizer];
        }
        reusableview = headerView;
    }
    
    if(reusableview == nil)
        reusableview = [[UICollectionReusableView alloc] init];
    
    return reusableview;
}

-(void)tappedImage:(UITapGestureRecognizer *)sender
{
    [self performSegueWithIdentifier:@"pushImageView" sender:self];
}

-(void)tappedImage1:(UITapGestureRecognizer *)sender
{
    [self performSegueWithIdentifier:@"pushImageView1" sender:self];
}

-(void)tappedImage2:(UITapGestureRecognizer *)sender
{
    [self performSegueWithIdentifier:@"pushImageView2" sender:self];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0.0;
    int height = [UIScreen mainScreen].bounds.size.height;

    if (height == 480) {
        cellHeight = 95;
    } else if (height == 568) {
        cellHeight = 95;
    } if (height == 667) {
        cellHeight = 112;
    } if (height == 736) {
        cellHeight = 124;
    }
    
    if(shouldBeDetail)
    {
        if(indexPath.row == 10 || indexPath.row == 11)
            return CGSizeMake(cellWidth, cellHeight+5);
    }
    else if(shouldBeCompare)
    {
        if(indexPath.row == 11)
            return CGSizeMake(cellWidth, cellHeight+5);
    }
    
    return CGSizeMake(cellWidth, cellHeight);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SpecsCell";
    SpecsCollectionCell *cell = [specsCollectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Model *leftCar;
    Model *rightCar;
    
    if(shouldBeCompare)
    {
        if(shouldAnimateCell == YES)
        {
            [self convertCellToCompare:cell];
        }
        else
            [self convertCellToCompareImmediate:cell];

        leftCar = firstCar;
        rightCar = secondCar;
    }
    else
    {
        if(shouldBeDetail)
        {
            if(shouldAnimateCell == YES)
                [self revertCellToDetail:cell];
            else
                [self revertCellToDetailImmediate:cell];
            
            leftCar = firstCar;
            rightCar = secondCar;
        }
        
        leftCar = currentCar;
        if(indexPath.row % 2 == 0)
        {
            [cell.middleCellDivider setAlpha:1];
            [cell.leftCellDivider setAlpha:1];
            [cell.rightCellDivider setAlpha:0];
        }
        else
        {
            [cell.rightCellDivider setAlpha:1];
            [cell.middleCellDivider setAlpha:0];
            [cell.leftCellDivider setAlpha:0];
        }
        
        if(indexPath.row == 10 || indexPath.row == 11)
        {
            [cell.rightCellDivider setAlpha:0];
            [cell.leftCellDivider setAlpha:0];
        }
    }
    
    if(indexPath.row == 0)
    {
        cell.specImage.image = [self resizeImage:[UIImage imageNamed:@"YearsMade.png"]reSize:cell.specImage.frame.size];
        cell.comparespecImage.image = [self resizeImage:[UIImage imageNamed:@"YearsMade.png"]reSize:cell.comparespecImage.frame.size];
        cell.specLabel.text = @"Years Made";
        cell.compareSpecLabel.text = @"Years Made";
        
        if(rightCar != NULL)
            cell.specValueLabel2.text = rightCar.CarYearsMade;
        else
            cell.specValueLabel2.text = @"";
        
        if(leftCar != NULL)
            cell.specValueLabel.text = leftCar.CarYearsMade;
        else
            cell.specValueLabel.text = @"";
    }
    if(indexPath.row == 1)
    {
        cell.specImage.image = [self resizeImage:[UIImage imageNamed:@"DriveType.png"]reSize:cell.specImage.frame.size];
        cell.comparespecImage.image = [self resizeImage:[UIImage imageNamed:@"DriveType.png"]reSize:cell.comparespecImage.frame.size];
        cell.specLabel.text = @"Drive Type";
        cell.compareSpecLabel.text = @"Drive Type";
        
        if(rightCar != NULL)
            cell.specValueLabel2.text = rightCar.CarDriveType;
        else
            cell.specValueLabel2.text = @"";
        
        if(leftCar != NULL)
            cell.specValueLabel.text = leftCar.CarDriveType;
        else
            cell.specValueLabel.text = @"";
        
    }
    if(indexPath.row == 2)
    {
        cell.specImage.image = [self resizeImage:[UIImage imageNamed:@"Price.png"]reSize:cell.specImage.frame.size];
        cell.comparespecImage.image = [self resizeImage:[UIImage imageNamed:@"Price.png"]reSize:cell.comparespecImage.frame.size];
        cell.specLabel.text = @"Starting MSRP";
        cell.compareSpecLabel.text = @"Starting MSRP";
        
        if(rightCar != NULL)
         {
             NSNumber *convertedMSRP = [self determineCarPrice:rightCar.CarMSRP];
             NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
             [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
             [numberFormatter setMaximumFractionDigits:0];
             NSString *msrpString = [numberFormatter stringFromNumber:convertedMSRP];
             NSString *finalMSRP = [currencySymbol stringByAppendingString:msrpString];
             
             if([msrpString  isEqualToString: @"0"])
                 cell.specValueLabel2.text = @"N/A";
             else
                 cell.specValueLabel2.text = finalMSRP;
         }
         else
             cell.specValueLabel2.text = @"";
        
        if(leftCar != NULL)
        {
            NSNumber *convertedMSRP = [self determineCarPrice:leftCar.CarMSRP];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
            [numberFormatter setMaximumFractionDigits:0];
            NSString *msrpString = [numberFormatter stringFromNumber:convertedMSRP];
            NSString *finalMSRP = [currencySymbol stringByAppendingString:msrpString];
            
            if([msrpString  isEqualToString: @"0"])
                cell.specValueLabel.text = @"N/A";
            else
                cell.specValueLabel.text = finalMSRP;
        }
        else
            cell.specValueLabel.text = @"";
    }
    if(indexPath.row == 3)
    {
        cell.specImage.image = [self resizeImage:[UIImage imageNamed:@"Price.png"]reSize:cell.specImage.frame.size];
        cell.comparespecImage.image = [self resizeImage:[UIImage imageNamed:@"Price.png"]reSize:cell.comparespecImage.frame.size];
        cell.specLabel.text = @"Market Value";
        cell.compareSpecLabel.text = @"Market Value";
        
        if(rightCar != NULL)
        {
            if([rightCar.CarPrice isEqualToString:@"N/A"] || ([rightCar.CarPriceLow isEqual:[NSNumber numberWithInt:0]] || [rightCar.CarPriceHigh isEqual:[NSNumber numberWithInt:0]]))
                cell.specValueLabel2.text = @"N/A";
            else
            {
                NSNumber *convertedPriceLow = [self determineCarPrice:rightCar.CarPriceLow];
                NSNumber *convertedPriceHigh = [self determineCarPrice:rightCar.CarPriceHigh];
                
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
                [numberFormatter setMaximumFractionDigits:0];
                
                NSString *priceLowString = [numberFormatter stringFromNumber:convertedPriceLow];
                NSString *priceHighString = [numberFormatter stringFromNumber:convertedPriceHigh];
                NSString *combinedPriceString = [[[currencySymbol stringByAppendingString:priceLowString]stringByAppendingString:@" - " ] stringByAppendingString:priceHighString];
                NSString *singlePriceString = [currencySymbol stringByAppendingString:priceLowString];
                
                if(![convertedPriceLow isEqual:convertedPriceHigh])
                    cell.specValueLabel2.text = combinedPriceString;
                else
                    cell.specValueLabel2.text = singlePriceString;
            }
        }
        else
            cell.specValueLabel2.text = @"";
        
        if(leftCar != NULL)
        {
            if([leftCar.CarPrice isEqualToString:@"N/A"] || ([leftCar.CarPriceLow isEqual:[NSNumber numberWithInt:0]] || [leftCar.CarPriceHigh isEqual:[NSNumber numberWithInt:0]]))
                cell.specValueLabel.text = @"N/A";
            else
            {
                NSNumber *convertedPriceLow = [self determineCarPrice:leftCar.CarPriceLow];
                NSNumber *convertedPriceHigh = [self determineCarPrice:leftCar.CarPriceHigh];
                
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
                [numberFormatter setMaximumFractionDigits:0];
                
                NSString *priceLowString = [numberFormatter stringFromNumber:convertedPriceLow];
                NSString *priceHighString = [numberFormatter stringFromNumber:convertedPriceHigh];
                NSString *combinedPriceString = [[[currencySymbol stringByAppendingString:priceLowString]stringByAppendingString:@" - " ] stringByAppendingString:priceHighString];
                NSString *singlePriceString = [currencySymbol stringByAppendingString:priceLowString];
                
                if(![convertedPriceLow isEqual:convertedPriceHigh])
                    cell.specValueLabel.text = combinedPriceString;
                else
                    cell.specValueLabel.text = singlePriceString;
            }
        }
        else
            cell.specValueLabel.text = @"";
    }
    if(indexPath.row == 4)
    {
        cell.specImage.image = [self resizeImage:[UIImage imageNamed:@"Engine.png"]reSize:cell.specImage.frame.size];
        cell.comparespecImage.image = [self resizeImage:[UIImage imageNamed:@"Engine.png"]reSize:cell.comparespecImage.frame.size];
        cell.specLabel.text = @"Engine";
        cell.compareSpecLabel.text = @"Engine";
        
        if(rightCar != NULL)
            cell.specValueLabel2.text = rightCar.CarEngine;
         else
             cell.specValueLabel2.text = @"";
        
        if(leftCar != NULL)
            cell.specValueLabel.text = leftCar.CarEngine;
        else
            cell.specValueLabel.text = @"";
    }
    if(indexPath.row == 5)
    {
        cell.specImage.image = [self resizeImage:[UIImage imageNamed:@"Transmission&Settings.png"]reSize:cell.specImage.frame.size];
        cell.comparespecImage.image = [self resizeImage:[UIImage imageNamed:@"Transmission&Settings.png"]reSize:cell.comparespecImage.frame.size];
        cell.specLabel.text = @"Transmission";
        cell.compareSpecLabel.text = @"Transmission";

        if(rightCar != NULL)
            cell.specValueLabel2.text = rightCar.CarTransmission;
         else
             cell.specValueLabel2.text = @"";
        if(leftCar != NULL)
            cell.specValueLabel.text = leftCar.CarTransmission;
        else
            cell.specValueLabel.text = @"";
    }
    if(indexPath.row == 6)
    {
        cell.specImage.image = [self resizeImage:[UIImage imageNamed:@"Horsepower.png"]reSize:cell.specImage.frame.size];
        cell.comparespecImage.image = [self resizeImage:[UIImage imageNamed:@"Horsepower.png"]reSize:cell.comparespecImage.frame.size];
        cell.specLabel.text = @"Power";
        cell.compareSpecLabel.text = @"Power";
        
        if(rightCar!= NULL)
         {
             if([rightCar.CarHorsepower isEqualToString:@"N/A"] || ([rightCar.CarHorsepowerLow isEqual:[NSNumber numberWithInt:0]] || [rightCar.CarHorsepowerHigh isEqual:[NSNumber numberWithInt:0]]))
                 cell.specValueLabel2.text = @"N/A";
             else
             {
                 NSNumber *convertedHPLow = [self determineHorsepower:rightCar.CarHorsepowerLow];
                 NSNumber *convertedHPHigh = [self determineHorsepower:rightCar.CarHorsepowerHigh];
         
                 convertedHPLow = [NSNumber numberWithInt:(int)roundf([convertedHPLow doubleValue])];
                 convertedHPHigh = [NSNumber numberWithInt:(int)roundf([convertedHPHigh doubleValue])];
         
                 NSString *hpLowString = [convertedHPLow stringValue];
                 NSString *hpHighString = [convertedHPHigh stringValue];
         
                 NSString *combinedHPString = [[[hpLowString stringByAppendingString:@" - " ] stringByAppendingString:hpHighString] stringByAppendingString:hpUnit];
                 NSString *singleHPString = [hpLowString stringByAppendingString:hpUnit];
         
                 if(![convertedHPLow isEqual:convertedHPHigh])
                     cell.specValueLabel2.text = combinedHPString;
                 else
                    cell.specValueLabel2.text = singleHPString;
             }
         }
         else
             cell.specValueLabel2.text = @"";
        if(leftCar != NULL)
        {
             if([leftCar.CarHorsepower isEqualToString:@"N/A"] || ([leftCar.CarHorsepowerLow isEqual:[NSNumber numberWithInt:0]] || [leftCar.CarHorsepowerHigh isEqual:[NSNumber numberWithInt:0]]))
                 cell.specValueLabel.text = @"N/A";
            else
            {
                NSNumber *convertedHPLow = [self determineHorsepower:leftCar.CarHorsepowerLow];
                NSNumber *convertedHPHigh = [self determineHorsepower:leftCar.CarHorsepowerHigh];
            
                convertedHPLow = [NSNumber numberWithInt:(int)roundf([convertedHPLow doubleValue])];
                convertedHPHigh = [NSNumber numberWithInt:(int)roundf([convertedHPHigh doubleValue])];
            
                NSString *hpLowString = [convertedHPLow stringValue];
                NSString *hpHighString = [convertedHPHigh stringValue];
            
                NSString *combinedHPString = [[[hpLowString stringByAppendingString:@" - " ] stringByAppendingString:hpHighString] stringByAppendingString:hpUnit];
                NSString *singleHPString = [hpLowString stringByAppendingString:hpUnit];
            
                if(![convertedHPLow isEqual:convertedHPHigh])
                    cell.specValueLabel.text = combinedHPString;
                else
                    cell.specValueLabel.text = singleHPString;
            }
        }
        else
            cell.specValueLabel.text = @"";
    }
    if(indexPath.row == 7)
    {
        cell.specImage.image = [self resizeImage:[UIImage imageNamed:@"Torque.png"]reSize:cell.specImage.frame.size];
        cell.comparespecImage.image = [self resizeImage:[UIImage imageNamed:@"Torque.png"]reSize:cell.comparespecImage.frame.size];
        cell.specLabel.text = @"Torque";
        cell.compareSpecLabel.text = @"Torque";
        
        if(rightCar != NULL)
        {
            if([rightCar.CarTorque isEqualToString:@"N/A"] || ([rightCar.CarTorqueLow isEqual:[NSNumber numberWithInt:0]] || [rightCar.CarTorqueHigh isEqual:[NSNumber numberWithInt:0]]))
                cell.specValueLabel2.text = @"N/A";
            else
            {
                NSNumber *convertedTorqueLow = [self determineTorque:rightCar.CarTorqueLow];
                NSNumber *convertedTorqueHigh = [self determineTorque:rightCar.CarTorqueHigh];
            
                convertedTorqueLow = [NSNumber numberWithInt:(int)roundf([convertedTorqueLow doubleValue])];
                convertedTorqueHigh = [NSNumber numberWithInt:(int)roundf([convertedTorqueHigh doubleValue])];
            
                NSString *torqueLowString = [convertedTorqueLow stringValue];
                NSString *torqueHighString = [convertedTorqueHigh stringValue];
            
                NSString *combinedTorqueString = [[[torqueLowString stringByAppendingString:@" - " ] stringByAppendingString:torqueHighString] stringByAppendingString:torqueUnit];
                NSString *singleTorqueString = [torqueLowString stringByAppendingString:torqueUnit];
            
                if(![convertedTorqueLow isEqual:convertedTorqueHigh])
                    cell.specValueLabel2.text = combinedTorqueString;
                else
                    cell.specValueLabel2.text = singleTorqueString;
            }
        }
        else
            cell.specValueLabel2.text = @"";
        
        if(leftCar != NULL)
        {
            if([leftCar.CarTorque isEqualToString:@"N/A"] || ([leftCar.CarTorqueLow isEqual:[NSNumber numberWithInt:0]] || [leftCar.CarTorqueHigh isEqual:[NSNumber numberWithInt:0]]))
                cell.specValueLabel.text = @"N/A";
            else
            {
                NSNumber *convertedTorqueLow = [self determineTorque:leftCar.CarTorqueLow];
                NSNumber *convertedTorqueHigh = [self determineTorque:leftCar.CarTorqueHigh];
            
                convertedTorqueLow = [NSNumber numberWithInt:(int)roundf([convertedTorqueLow doubleValue])];
                convertedTorqueHigh = [NSNumber numberWithInt:(int)roundf([convertedTorqueHigh doubleValue])];
            
                NSString *torqueLowString = [convertedTorqueLow stringValue];
                NSString *torqueHighString = [convertedTorqueHigh stringValue];
            
                NSString *combinedTorqueString = [[[torqueLowString stringByAppendingString:@" - " ] stringByAppendingString:torqueHighString] stringByAppendingString:torqueUnit];
                NSString *singleTorqueString = [torqueLowString stringByAppendingString:torqueUnit];
            
                if(![convertedTorqueLow isEqual:convertedTorqueHigh])
                    cell.specValueLabel.text = combinedTorqueString;
                else
                    cell.specValueLabel.text = singleTorqueString;
            }
        }
        else
            cell.specValueLabel.text = @"";
    }
    if(indexPath.row == 8)
    {
        cell.specImage.image = [self resizeImage:[UIImage imageNamed:@"0-60.png"]reSize:cell.specImage.frame.size];
        cell.comparespecImage.image = [self resizeImage:[UIImage imageNamed:@"0-60.png"]reSize:cell.comparespecImage.frame.size];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([[defaults objectForKey:@"Top Speed"] isEqualToString:@"MPH"])
        {
            cell.specLabel.text = @"0-60 Time";
            cell.compareSpecLabel.text = @"0-60 Time";
        }
        else
        {
            cell.specLabel.text = @"0-100 Time";
            cell.compareSpecLabel.text = @"0-100 Time";
        }
        
        if(rightCar != NULL)
        {
            if([rightCar.CarZeroToSixty isEqualToString:@""])
                cell.specValueLabel2.text = @"N/A";
            else
                cell.specValueLabel2.text = rightCar.CarZeroToSixty;
        }
         else
             cell.specValueLabel2.text = @"";
        
        if(leftCar != NULL)
        {
            if([leftCar.CarZeroToSixty isEqualToString:@""])
                cell.specValueLabel.text = @"N/A";
            else
                cell.specValueLabel.text = leftCar.CarZeroToSixty;
        }
        else
            cell.specValueLabel.text = @"";
    }
    if(indexPath.row == 9)
    {
        cell.specImage.image = [self resizeImage:[UIImage imageNamed:@"TopSpeed.png"]reSize:cell.specImage.frame.size];
        cell.comparespecImage.image = [self resizeImage:[UIImage imageNamed:@"TopSpeed.png"]reSize:cell.comparespecImage.frame.size];
        cell.specLabel.text = @"Top Speed";
        cell.compareSpecLabel.text = @"Top Speed";
        
        if(rightCar != NULL)
         {
             if([rightCar.CarTopSpeed isEqualToString:@"N/A"])
                 cell.specValueLabel2.text = @"N/A";
             else
             {
                 if([rightCar.CarTopSpeedLow isEqualToString:@""] || [rightCar.CarTopSpeedHigh isEqualToString:@""])
                 {
                     NSNumber *convertedSpeed = [self determineSpeed:[NSNumber numberWithDouble:[rightCar.CarTopSpeed doubleValue]]];
                     convertedSpeed = [NSNumber numberWithInt:(int)roundf([convertedSpeed doubleValue])];
                     NSString *topSpeedString = [convertedSpeed stringValue];
                     topSpeedString = [topSpeedString stringByAppendingString:speedUnit];
                     cell.specValueLabel2.text = topSpeedString;
                 }
                 else
                 {
                     NSNumber *convertedSpeedLow = [self determineSpeed:[NSNumber numberWithDouble:[rightCar.CarTopSpeedLow doubleValue]]];
                     NSNumber *convertedSpeedHigh = [self determineSpeed:[NSNumber numberWithDouble:[rightCar.CarTopSpeedHigh doubleValue]]];
                     
                     NSString *speedLowString;
                     NSString *speedHighString;
                     
                     convertedSpeedLow = [NSNumber numberWithInt:(int)roundf([convertedSpeedLow doubleValue])];
                     convertedSpeedHigh = [NSNumber numberWithInt:(int)roundf([convertedSpeedHigh doubleValue])];
                     speedLowString = [convertedSpeedLow stringValue];
                     speedHighString = [convertedSpeedHigh stringValue];
                     
                     NSString *combinedSpeedString = [[[speedLowString stringByAppendingString:@" - " ] stringByAppendingString:speedHighString] stringByAppendingString:speedUnit];
                     NSString *singleSpeedString = [speedLowString stringByAppendingString:speedUnit];
                     
                     if(![convertedSpeedLow isEqual:convertedSpeedHigh])
                         cell.specValueLabel2.text = combinedSpeedString;
                     else
                         cell.specValueLabel2.text = singleSpeedString;
                 }
             }
         }
         else
             cell.specValueLabel2.text = @"";
        if(leftCar != NULL)
        {
            if([leftCar.CarTopSpeed isEqualToString:@"N/A"])
                cell.specValueLabel.text = @"N/A";
            else
            {
                if([leftCar.CarTopSpeedLow isEqualToString:@""] || [leftCar.CarTopSpeedHigh isEqualToString:@""])
                {
                    NSNumber *convertedSpeed = [self determineSpeed:[NSNumber numberWithDouble:[leftCar.CarTopSpeed doubleValue]]];
                    convertedSpeed = [NSNumber numberWithInt:(int)roundf([convertedSpeed doubleValue])];
                    NSString *topSpeedString = [convertedSpeed stringValue];
                    topSpeedString = [topSpeedString stringByAppendingString:speedUnit];
                    cell.specValueLabel.text = topSpeedString;
                }
                else
                {
                    NSNumber *convertedSpeedLow = [self determineSpeed:[NSNumber numberWithDouble:[leftCar.CarTopSpeedLow doubleValue]]];
                    NSNumber *convertedSpeedHigh = [self determineSpeed:[NSNumber numberWithDouble:[leftCar.CarTopSpeedHigh doubleValue]]];
                    
                    NSString *speedLowString;
                    NSString *speedHighString;
                    
                    convertedSpeedLow = [NSNumber numberWithInt:(int)roundf([convertedSpeedLow doubleValue])];
                    convertedSpeedHigh = [NSNumber numberWithInt:(int)roundf([convertedSpeedHigh doubleValue])];
                    speedLowString = [convertedSpeedLow stringValue];
                    speedHighString = [convertedSpeedHigh stringValue];
                    
                    NSString *combinedSpeedString = [[[speedLowString stringByAppendingString:@" - " ] stringByAppendingString:speedHighString] stringByAppendingString:speedUnit];
                    NSString *singleSpeedString = [speedLowString stringByAppendingString:speedUnit];
                    
                    if(![convertedSpeedLow isEqual:convertedSpeedHigh])
                        cell.specValueLabel.text = combinedSpeedString;
                    else
                        cell.specValueLabel.text = singleSpeedString;
                }
            }
        }
        else
            cell.specValueLabel.text = @"";
    }
    if(indexPath.row == 10)
    {
        cell.specImage.image = [self resizeImage:[UIImage imageNamed:@"FuelEconomy.png"]reSize:cell.specImage.frame.size];
        cell.comparespecImage.image = [self resizeImage:[UIImage imageNamed:@"FuelEconomy.png"]reSize:cell.comparespecImage.frame.size];
        cell.specLabel.text = @"Fuel Economy";
        cell.compareSpecLabel.text = @"Fuel Economy";
        
        if(rightCar != NULL)
        {
            if([rightCar.CarFuelEconomy isEqualToString:@"N/A"] || ([rightCar.CarFuelEconomyLow isEqual:[NSNumber numberWithInt:0]] || [rightCar.CarFuelEconomyHigh isEqual:[NSNumber numberWithInt:0]]))
                cell.specValueLabel2.text = @"N/A";
            else
            {
                NSNumber *convertedFELow = [self determineFuelEconomy:rightCar.CarFuelEconomyLow];
                NSNumber *convertedFEHigh = [self determineFuelEconomy:rightCar.CarFuelEconomyHigh];
         
                NSString *FELowString;
                NSString *FEHighString;
         
                if([fuelEconomyUnit isEqualToString:@" L/100 km"])
                {
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setPositiveFormat:@"0.##"];
                
                    FELowString = [numberFormatter stringFromNumber:convertedFELow];
                    FEHighString = [numberFormatter stringFromNumber:convertedFEHigh];
                }
                else
                {
                    convertedFELow = [NSNumber numberWithInt:(int)roundf([convertedFELow doubleValue])];
                    convertedFEHigh = [NSNumber numberWithInt:(int)roundf([convertedFEHigh doubleValue])];
                    FELowString = [convertedFELow stringValue];
                    FEHighString = [convertedFEHigh stringValue];
                }
                NSString *combinedFEString = [[[FELowString stringByAppendingString:@" - " ] stringByAppendingString:FEHighString] stringByAppendingString:fuelEconomyUnit];
                NSString *singleFEString = [FELowString stringByAppendingString:fuelEconomyUnit];
            
                if(![convertedFELow isEqual:convertedFEHigh])
                    cell.specValueLabel2.text = combinedFEString;
                else
                    cell.specValueLabel2.text = singleFEString;
            }
        }
        else
            cell.specValueLabel2.text = @"";
        
        if(leftCar != NULL)
        {
            if([leftCar.CarFuelEconomy isEqualToString:@"N/A"] || ([leftCar.CarFuelEconomyLow isEqual:[NSNumber numberWithInt:0]] || [leftCar.CarFuelEconomyHigh isEqual:[NSNumber numberWithInt:0]]))
                cell.specValueLabel.text = @"N/A";
            else
            {
                NSNumber *convertedFELow = [self determineFuelEconomy:leftCar.CarFuelEconomyLow];
                NSNumber *convertedFEHigh = [self determineFuelEconomy:leftCar.CarFuelEconomyHigh];
            
                NSString *FELowString;
                NSString *FEHighString;
            
                if([fuelEconomyUnit isEqualToString:@" L/100 km"])
                {
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setPositiveFormat:@"0.##"];
                
                    FELowString = [numberFormatter stringFromNumber:convertedFELow];
                    FEHighString = [numberFormatter stringFromNumber:convertedFEHigh];
                }
                else
                {
                    convertedFELow = [NSNumber numberWithInt:(int)roundf([convertedFELow doubleValue])];
                    convertedFEHigh = [NSNumber numberWithInt:(int)roundf([convertedFEHigh doubleValue])];
                    FELowString = [convertedFELow stringValue];
                    FEHighString = [convertedFEHigh stringValue];
                }
                NSString *combinedFEString = [[[FELowString stringByAppendingString:@" - " ] stringByAppendingString:FEHighString] stringByAppendingString:fuelEconomyUnit];
                NSString *singleFEString = [FELowString stringByAppendingString:fuelEconomyUnit];
                
                if(![convertedFELow isEqual:convertedFEHigh])
                    cell.specValueLabel.text = combinedFEString;
                else
                    cell.specValueLabel.text = singleFEString;
            }
        }
        else
            cell.specValueLabel.text = @"";
    }
    if(indexPath.row == 11)
    {
        cell.specImage.image = [self resizeImage:[UIImage imageNamed:@"Weight.png"]reSize:cell.specImage.frame.size];
        cell.comparespecImage.image = [self resizeImage:[UIImage imageNamed:@"Weight.png"]reSize:cell.comparespecImage.frame.size];
        cell.specLabel.text = @"Weight";
        cell.compareSpecLabel.text = @"Weight";
        
        if(rightCar != NULL)
        {
            if([rightCar.CarWeight isEqualToString:@"N/A"] || ([rightCar.CarWeightLow isEqual:[NSNumber numberWithInt:0]] || [rightCar.CarWeightHigh isEqual:[NSNumber numberWithInt:0]]))
                cell.specValueLabel2.text = @"N/A";
            else
            {
                NSNumber *convertedWeightLow = [self determineWeight:rightCar.CarWeightLow];
                NSNumber *convertedWeightHigh = [self determineWeight:rightCar.CarWeightHigh];
            
                convertedWeightLow = [NSNumber numberWithInt:(int)roundf([convertedWeightLow doubleValue])];
                convertedWeightHigh = [NSNumber numberWithInt:(int)roundf([convertedWeightHigh doubleValue])];
            
                NSString *weightLowString = [convertedWeightLow stringValue];
                NSString *weightHighString = [convertedWeightHigh stringValue];
            
                NSString *combinedWeightString = [[[weightLowString stringByAppendingString:@" - " ] stringByAppendingString:weightHighString] stringByAppendingString:weightUnit];
                NSString *singleWeightString = [weightLowString stringByAppendingString:weightUnit];
            
                if(![convertedWeightLow isEqual:convertedWeightHigh])
                    cell.specValueLabel2.text = combinedWeightString;
                else
                    cell.specValueLabel2.text = singleWeightString;
            }
        }
        else
            cell.specValueLabel2.text = @"";
        
        if(leftCar != NULL)
        {
            if([leftCar.CarWeight isEqualToString:@"N/A"] || ([leftCar.CarWeightLow isEqual:[NSNumber numberWithInt:0]] || [leftCar.CarWeightHigh isEqual:[NSNumber numberWithInt:0]]))
                cell.specValueLabel.text = @"N/A";
            else
            {
                NSNumber *convertedWeightLow = [self determineWeight:leftCar.CarWeightLow];
                NSNumber *convertedWeightHigh = [self determineWeight:leftCar.CarWeightHigh];
            
                convertedWeightLow = [NSNumber numberWithInt:(int)roundf([convertedWeightLow doubleValue])];
                convertedWeightHigh = [NSNumber numberWithInt:(int)roundf([convertedWeightHigh doubleValue])];
            
                NSString *weightLowString = [convertedWeightLow stringValue];
                NSString *weightHighString = [convertedWeightHigh stringValue];
            
                NSString *combinedWeightString = [[[weightLowString stringByAppendingString:@" - " ] stringByAppendingString:weightHighString] stringByAppendingString:weightUnit];
                NSString *singleWeightString = [weightLowString stringByAppendingString:weightUnit];
            
                if(![convertedWeightLow isEqual:convertedWeightHigh])
                    cell.specValueLabel.text = combinedWeightString;
                else
                    cell.specValueLabel.text = singleWeightString;
            }
        }
        else
            cell.specValueLabel.text = @"";
    }
    
    return cell;
}

-(NSNumber *)determineFuelEconomy:(NSNumber *)mpgValue
{
    NSNumber *convertedFuelEconomy = mpgValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![[defaults objectForKey:@"Fuel Economy"] isEqualToString:@"MPG US"])
    {
        if([[defaults objectForKey:@"Fuel Economy"] isEqualToString:@"MPG UK"])
        {
            convertedFuelEconomy = [NSNumber numberWithDouble:([convertedFuelEconomy doubleValue]*1.20095)];
            fuelEconomyUnit = @" MPG UK";
        }
        if([[defaults objectForKey:@"Fuel Economy"] isEqualToString:@"L/100 km"])
        {
            convertedFuelEconomy = [NSNumber numberWithDouble:(235.22/[convertedFuelEconomy doubleValue])];
            fuelEconomyUnit = @" L/100 km";
        }
    }
    else
        fuelEconomyUnit = @" MPG US";
    
    return convertedFuelEconomy;
}

-(NSNumber *)determineWeight:(NSNumber *)lbsValue
{
    NSNumber *convertedWeight = lbsValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![[defaults objectForKey:@"Weight"] isEqualToString:@"lbs"])
    {
        convertedWeight = [NSNumber numberWithDouble:([convertedWeight doubleValue]*0.453592)];
        weightUnit = @" kg";
    }
    else
        weightUnit = @" lbs";
    
    return convertedWeight;
}

-(NSNumber *)determineSpeed:(NSNumber *)mphValue
{
    NSNumber *convertedSpeed = mphValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![[defaults objectForKey:@"Top Speed"] isEqualToString:@"MPH"])
    {
        convertedSpeed = [NSNumber numberWithDouble:([convertedSpeed doubleValue]*1.60934)];
        speedUnit = @" km/h";
    }
    else
        speedUnit = @" MPH";
    
    return convertedSpeed;
}

-(NSNumber *)determineCarPrice:(NSNumber *)usdPrice
{
    NSNumber *convertedPrice = usdPrice;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *exchangeName;
    Currency *savedCurrency;
    
    if(![[defaults objectForKey:@"Currency"] isEqualToString:@"($) US Dollar"])
    {
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"($) Argentinian Peso"])
        {
            exchangeName = @"USD/ARS";
            currencySymbol = @"($)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"($) Australian Dollar"])
        {
            exchangeName = @"USD/AUD";
            currencySymbol = @"($)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(R$) Brazilian Real"])
        {
            exchangeName = @"USD/BRL";
            currencySymbol = @"(R$)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(£) British Pound"])
        {
            exchangeName = @"USD/GBP";
            currencySymbol = @"(£)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"($) Canadian Dollar"])
        {
            exchangeName = @"USD/CAD";
            currencySymbol = @"($)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"($) Chilean Peso"])
        {
            exchangeName = @"USD/CLP";
            currencySymbol = @"($)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(¥) Chinese Yuan"])
        {
            exchangeName = @"USD/CNY";
            currencySymbol = @"(¥)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(Kč) Czech Koruna"])
        {
            exchangeName = @"USD/CZK";
            currencySymbol = @"(Kč)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(kr.) Danish Krone"])
        {
            exchangeName = @"USD/DKK";
            currencySymbol = @"(kr.)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(RD$) Dominican Peso"])
        {
            exchangeName = @"USD/DOP";
            currencySymbol = @"(RD$)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(£) Egyptian Pound"])
        {
            exchangeName = @"USD/EGP";
            currencySymbol = @"(£)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(€) European Euro"])
        {
            exchangeName = @"USD/EUR";
            currencySymbol = @"(€)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"($) Hong Kong Dollar"])
        {
            exchangeName = @"USD/HKD";
            currencySymbol = @"($)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(Ft) Hungarian Forint"])
        {
            exchangeName = @"USD/HUF";
            currencySymbol = @"(Ft)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(INR) Indian Rupee"])
        {
            exchangeName = @"USD/INR";
            currencySymbol = @"(INR)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(Rp) Indonesian Rupiah"])
        {
            exchangeName = @"USD/IDR";
            currencySymbol = @"(Rp)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(₪) Israeli New Shekel"])
        {
            exchangeName = @"USD/ILS";
            currencySymbol = @"(₪)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(¥) Japanese Yen"])
        {
            exchangeName = @"USD/JPY";
            currencySymbol = @"(¥)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(RM) Malaysian Ringgit"])
        {
            exchangeName = @"USD/MYR";
            currencySymbol = @"(RM)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"($) Mexican Peso"])
        {
            exchangeName = @"USD/MXN";
            currencySymbol = @"($)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"($) New Zealand Dollar"])
        {
            exchangeName = @"USD/NZD";
            currencySymbol = @"($)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(kr) Norwegian Krone"])
        {
            exchangeName = @"USD/NOK";
            currencySymbol = @"(kr)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(Rs) Pakistani Rupee"])
        {
            exchangeName = @"USD/PKR";
            currencySymbol = @"(Rs)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(zł) Polish Zloty"])
        {
            exchangeName = @"USD/PLN";
            currencySymbol = @"(zł)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(руб) Russian Ruble"])
        {
            exchangeName = @"USD/RUB";
            currencySymbol = @"(руб)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"($) Singapore Dollar"])
        {
            exchangeName = @"USD/SGD";
            currencySymbol = @"($)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(R) South African Rand"])
        {
            exchangeName = @"USD/ZAR";
            currencySymbol = @"(R)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(₩) South Korean Won"])
        {
            exchangeName = @"USD/KRW";
            currencySymbol = @"(₩)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(kr) Swedish Kronor"])
        {
            exchangeName = @"USD/SEK";
            currencySymbol = @"(kr)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(CHF) Swiss Franc"])
        {
            exchangeName = @"USD/CHF";
            currencySymbol = @"(CHF)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(NT$) Taiwanese New Dollar"])
        {
            exchangeName = @"USD/TWD";
            currencySymbol = @"(NT$)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(฿) Thai Baht"])
        {
            exchangeName = @"USD/THB";
            currencySymbol = @"(฿)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(TRY) Turkish New Lira"])
        {
            exchangeName = @"USD/TRY";
            currencySymbol = @"(TRY)";
        }
        if([[defaults objectForKey:@"Currency"] isEqualToString:@"(AED) UAE Dirham"])
        {
            exchangeName = @"USD/AED";
            currencySymbol = @"(AED)";
        }
        
        for(int i=0; i<appdel.currencyArray.count; i++)
        {
            Currency *currentCurrency = [appdel.currencyArray objectAtIndex:i];
            if([currentCurrency.CurrencyName isEqualToString:exchangeName])
            {
                savedCurrency = currentCurrency;
            }
        }
        double exchangeRate = [savedCurrency.CurrencyRate doubleValue];
        convertedPrice = [NSNumber numberWithDouble: exchangeRate * [usdPrice doubleValue]];
    }
    else
        currencySymbol = @"($)";
    return convertedPrice;
}

-(NSNumber *)determineHorsepower:(NSNumber *)hpValue
{
    NSNumber *convertedHP = hpValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![[defaults objectForKey:@"Horsepower"] isEqualToString:@"hp"])
    {
        if([[defaults objectForKey:@"Horsepower"] isEqualToString:@"PS"])
        {
            convertedHP = [NSNumber numberWithDouble:([convertedHP doubleValue]*1.01387)];
            hpUnit = @" PS";
        }
        if([[defaults objectForKey:@"Horsepower"] isEqualToString:@"kW"])
        {
            convertedHP = [NSNumber numberWithDouble:([convertedHP doubleValue]*0.7457)];
            hpUnit = @" kW";
        }
    }
    else
        hpUnit = @" hp";
    
    return convertedHP;
}

-(NSNumber *)determineTorque:(NSNumber *)lbFootValue
{
    NSNumber *convertedTorque = lbFootValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![[defaults objectForKey:@"Torque"] isEqualToString:@"lb·ft"])
    {
        if([[defaults objectForKey:@"Torque"] isEqualToString:@"N·m"])
        {
            convertedTorque = [NSNumber numberWithDouble:([convertedTorque doubleValue]*1.3558179)];
            torqueUnit = @" N·m";
        }
    }
    else
        torqueUnit = @" lb·ft";
    
    return convertedTorque;
}

#pragma mark Exhaust Methods

-(void)setUpAVAudioPlayer
{
    if(currentCar != NULL)
    {
        NSString * soundurl = [@"http://www.pl0x.net/CarSounds/" stringByAppendingString:currentCar.CarExhaust];
        NSURL *url = [NSURL URLWithString:soundurl];
        NSData *soundData = [NSData dataWithContentsOfURL:url];
        NSError *error = nil;
        avAudioPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:&error];
        avAudioPlayer.delegate = self;
        
        if (error)
            NSLog(@"error creating player: %@", [error localizedDescription]);
        
        if (avAudioPlayer)
            [avAudioPlayer prepareToPlay];
        
        if(shouldBeDetail)
        {
            hasLoaded = YES;
            [self performSelectorOnMainThread:@selector(stopActivityIndicator) withObject:self waitUntilDone:false];
            [exhaustButton1 setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Play.png"]reSize:exhaustButton1.frame.size] forState:UIControlStateNormal];
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            [exhaustButton1.layer addAnimation:transition forKey:nil];
        }
    }
}

-(void)setUpAVAudioPlayer1
{
    if(firstCar != NULL)
    {
        NSString * soundurl = [@"http://www.pl0x.net/CarSounds/" stringByAppendingString:firstCar.CarExhaust];
        NSURL *url = [NSURL URLWithString:soundurl];
        NSData *soundData = [NSData dataWithContentsOfURL:url];
        NSError *error = nil;
        avAudioPlayer1 = [[AVAudioPlayer alloc] initWithData:soundData error:&error];
        avAudioPlayer1.delegate = self;
        
        if (error)
            NSLog(@"error creating player: %@", [error localizedDescription]);
        
        if (avAudioPlayer1)
            [avAudioPlayer1 prepareToPlay];
        
        if(shouldBeCompare)
        {
            hasLoaded1 = YES;
            [self performSelectorOnMainThread:@selector(stopActivityIndicator1) withObject:self waitUntilDone:false];
            [exhaustButton1 setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Play.png"]reSize:exhaustButton1.frame.size] forState:UIControlStateNormal];
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            [exhaustButton1.layer addAnimation:transition forKey:nil];
        }
    }
}

-(void)setUpAVAudioPlayer2
{
    if(secondCar != NULL)
    {
        NSString * soundurl = [@"http://www.pl0x.net/CarSounds/" stringByAppendingString:secondCar.CarExhaust];
        NSURL *url = [NSURL URLWithString:soundurl];
        NSData *soundData = [NSData dataWithContentsOfURL:url];
        NSError *error = nil;
        avAudioPlayer2 = [[AVAudioPlayer alloc] initWithData:soundData error:&error];
        avAudioPlayer2.delegate = self;
        
        if (error)
            NSLog(@"error creating player: %@", [error localizedDescription]);
        
        if (avAudioPlayer2)
            [avAudioPlayer2 prepareToPlay];
        
        if(shouldBeCompare)
        {
            hasLoaded2 = YES;
            [self performSelectorOnMainThread:@selector(stopActivityIndicator2) withObject:self waitUntilDone:false];
            [exhaustButton2 setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Play.png"]reSize:exhaustButton1.frame.size] forState:UIControlStateNormal];
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            [exhaustButton1.layer addAnimation:transition forKey:nil];
        }
    }
}

-(void)stopActivityIndicator
{
    [specsHeaderView.exhaustActivityIndicator1 stopAnimating];
}

-(void)stopActivityIndicator1
{
    [specsHeaderView.exhaustActivityIndicator1 stopAnimating];
}

-(void)stopActivityIndicator2
{
    [specsHeaderView.exhaustActivityIndicator2 stopAnimating];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(player == avAudioPlayer)
        isPlaying = NO;
    if(player == avAudioPlayer1)
        isplaying1 = NO;
    if(player == avAudioPlayer2)
        isplaying2 = NO;
    
    [specsCollectionView reloadData];
}

-(void)Sound:(id)sender
{
    if(!([currentCar.CarExhaust isEqual:@""]))
    {
        if (!avAudioPlayer.isPlaying)
        {
            isPlaying = YES;
            UIButton *exhaustButton = sender;
            [exhaustButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Pause.png"]reSize:exhaustButton.frame.size] forState:UIControlStateNormal];
            [avAudioPlayer play];
        }
        else
        {
            isPlaying = NO;
            UIButton *exhaustButton = sender;
            [exhaustButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Play.png"]reSize:exhaustButton.frame.size] forState:UIControlStateNormal];
            [avAudioPlayer pause];
        }
    }
}

-(void)Sound1:(id)sender
{
    if(!([firstCar.CarExhaust isEqual:@""]))
    {
        if (!avAudioPlayer1.isPlaying)
        {
            isplaying1 = YES;
            UIButton *exhaustButton = sender;
            [exhaustButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Pause.png"]reSize:exhaustButton.frame.size] forState:UIControlStateNormal];
            [avAudioPlayer1 play];
        }
        else
        {
            isplaying1 = NO;
            UIButton *exhaustButton = sender;
            [exhaustButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Play.png"]reSize:exhaustButton.frame.size] forState:UIControlStateNormal];
            [avAudioPlayer1 pause];
        }
    }
}

-(void)Sound2:(id)sender
{
    if(!([secondCar.CarExhaust isEqual:@""]))
    {
        if (!avAudioPlayer2.isPlaying)
        {
            isplaying2 = YES;
            UIButton *exhaustButton = sender;
            [exhaustButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Pause.png"]reSize:exhaustButton.frame.size] forState:UIControlStateNormal];
            [avAudioPlayer2 play];
        }
        else
        {
            isplaying2 = NO;
            UIButton *exhaustButton = sender;
            [exhaustButton setBackgroundImage:[self resizeImage:[UIImage imageNamed:@"Play.png"]reSize:exhaustButton.frame.size] forState:UIControlStateNormal];
            [avAudioPlayer2 pause];
        }
    }
}

-(void)startLoadingWheelWithCenter:(CGPoint)center
{
    activityIndicator.center = center;
    activityIndicator.transform = CGAffineTransformMakeScale(0.75, 0.75);
    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.color = [UIColor blackColor];
    [self.specsCollectionView addSubview:activityIndicator];
    [activityIndicator startAnimating];
}

-(void)startLoadingWheel1WithCenter:(CGPoint)center
{
    activityIndicator1.center = center;
    activityIndicator1.transform = CGAffineTransformMakeScale(0.75, 0.75);
    activityIndicator1.hidesWhenStopped = YES;
    activityIndicator1.color = [UIColor blackColor];
    [self.specsCollectionView addSubview:activityIndicator1];
    [activityIndicator1 startAnimating];
}

-(void)startLoadingWheel2WithCenter:(CGPoint)center
{
    activityIndicator2.center = center;
    activityIndicator2.transform = CGAffineTransformMakeScale(0.75, 0.75);
    activityIndicator2.hidesWhenStopped = YES;
    activityIndicator2.color = [UIColor blackColor];
    [self.specsCollectionView addSubview:activityIndicator2];
    [activityIndicator2 startAnimating];
}

#pragma mark Save Favorite Car Methods

-(IBAction)Save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    savedArray = [[NSMutableArray alloc]init];
    NSData *retrievedData = [defaults objectForKey:@"savedArray"];
    NSArray *testArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
    if(testArray.count!=0)
        savedArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
    
    if([self isSaved:currentCar] == false){
        [savedArray addObject:currentCar];
    }else{
        int index = -1;
        for(int i=0; i<savedArray.count; i++){
            Model * savedObject = [savedArray objectAtIndex:i];
            if([savedObject.CarFullName isEqualToString:currentCar.CarFullName])
                index = i;
        }
        if(index != -1)
            [savedArray removeObjectAtIndex:index];
    }
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:savedArray];
    [defaults setObject:arrayData forKey:@"savedArray"];
    [defaults synchronize];
    
    [specsCollectionView reloadData];
}

- (bool)isSaved:(Model *)currentModel
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    savedArray = [[NSMutableArray alloc]init];
    NSData *retrievedData = [defaults objectForKey:@"savedArray"];
    NSArray *testArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
    if(testArray.count!=0)
        savedArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
    
    bool isThere = false;
    for(int i=0; i<savedArray.count; i++){
        Model * savedObject = [savedArray objectAtIndex:i];
        if([savedObject.CarFullName isEqualToString:currentCar.CarFullName])
            isThere = true;
    }
    return isThere;
}

#pragma mark - Navigation

-(void)convertCellToCompare:(SpecsCollectionCell *)cell
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SpecsCollectionCell animateWithDuration:0.5 animations:^{
            [cell.comparespecImage setAlpha:1];
            [cell.compareSpecLabel setAlpha:1];
            [cell.middleCellDivider setAlpha:1];
            [cell.leftCellDivider setAlpha:1];
            [cell.rightCellDivider setAlpha:1];
            [cell.rightCellDivider setFrame:CGRectMake(cell.frame.size.width/2, cell.rightCellDivider.frame.origin.y, cell.rightCellDivider.frame.size.width, cell.rightCellDivider.frame.size.width)];
        
            [cell.specValueLabel2 setAlpha:1];
            [cell setNeedsDisplay];
            [cell layoutIfNeeded];
        }];
    });
}

-(void)convertCellToCompareImmediate:(SpecsCollectionCell *)cell
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell.comparespecImage setAlpha:1];
        [cell.compareSpecLabel setAlpha:1];
        [cell.middleCellDivider setAlpha:1];
        [cell.leftCellDivider setAlpha:1];
        [cell.rightCellDivider setAlpha:1];
        [cell.rightCellDivider setFrame:CGRectMake(cell.frame.size.width/2, cell.rightCellDivider.frame.origin.y, cell.rightCellDivider.frame.size.width, cell.rightCellDivider.frame.size.width)];
        
        NSIndexPath *indexPath = [specsCollectionView indexPathForCell:cell];
        
        if(indexPath.row == 11)
        {
            [cell.rightCellDivider setAlpha:0];
            [cell.leftCellDivider setAlpha:0];
        }
        
        [cell.specValueLabel2 setAlpha:1];
        [cell setNeedsDisplay];
        [cell layoutIfNeeded];
    });
}

-(void)revertCellToDetail:(SpecsCollectionCell *)cell
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SpecsCollectionCell animateWithDuration:0.5 animations:^{
            
            cell.specImage.frame = cell.initialSpecImageFrame;
            cell.specLabel.frame = cell.initialSpecLabelFrame;
            cell.rightCellDivider.frame = cell.initialRightDividerFrame;
            
            [cell.specValueLabel2 setAlpha:0];
            [cell setNeedsDisplay];
            [cell layoutIfNeeded];
        }];
    });
}

-(void)revertCellToDetailImmediate:(SpecsCollectionCell *)cell
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
            cell.specImage.frame = cell.initialSpecImageFrame;
            cell.specLabel.frame = cell.initialSpecLabelFrame;
            cell.rightCellDivider.frame = cell.initialRightDividerFrame;
        
            [cell.specValueLabel2 setAlpha:0];
            [cell setNeedsDisplay];
            [cell layoutIfNeeded];
    });
}

-(IBAction)Compare
{
    [avAudioPlayer pause];
    avAudioPlayer.currentTime = 0;
    [activityIndicator removeFromSuperview];
    isPlaying = NO;
    
    if(shouldAnimateCell)
        return;
    shouldAnimateCell = YES;
    [self saveAndGetCars];
    
    [specsCollectionView performBatchUpdates:^{
        cellWidth = cellWidth*2;
        
    }completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            shouldBeCompare = YES;
            shouldBeDetail = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [specsCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            [specsCollectionView layoutIfNeeded];
        });
    });
    
    if(cameFromMakes)
    {
        NewMakesViewController *superView = (NewMakesViewController *)self.parentViewController;
        
        [UILabel animateWithDuration:.5 animations:^{
            [superView.detailImageScroller setAlpha:0.0];
        }];
    }
    if(cameFromModel)
    {
        ModelViewController *superView = (ModelViewController *)self.parentViewController;
        
        [UILabel animateWithDuration:.5 animations:^{
            [superView.detailImageScroller setAlpha:0.0];
        }];
    }
    if(cameFromTopTens)
    {
        NewTopTensViewController *superView = (NewTopTensViewController *)self.parentViewController;
        
        [UILabel animateWithDuration:.5 animations:^{
            [superView.detailImageScroller setAlpha:0.0];
        }];
    }
    if(cameFromFavorites)
    {
        FavoritesViewController *superView = (FavoritesViewController *)self.parentViewController;
        
        [UILabel animateWithDuration:.5 animations:^{
            [superView.detailImageScroller setAlpha:0.0];
        }];
    }
    if(cameFromSearchModel)
    {
        SearchModelController *superView = (SearchModelController *)self.parentViewController;
        
        [UILabel animateWithDuration:.5 animations:^{
            [superView.detailImageScroller setAlpha:0.0];
        }];
    }
    if(cameFromSearchTab)
    {
        SearchTabViewController *superView = (SearchTabViewController *)self.parentViewController;
        
        [UILabel animateWithDuration:.5 animations:^{
            [superView.detailImageScroller setAlpha:0.0];
        }];
    }
    
    if(![self.parentViewController isMemberOfClass:[UINavigationController class]])
    {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:@selector(revertToDetailView)];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.parentViewController.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
        [self setTitleLabelWithString:@"Compare" andView:self.parentViewController];
    }
    else
    {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:@selector(revertToDetailView)];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
        [self setTitleLabelWithString:@"Compare" andView:self];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        shouldAnimateCell = NO;
    });
}

-(void)changeCar1
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:@"Makes Layout Preference"]isEqualToString:@"Grid"])
        [self performSegueWithIdentifier:@"changeCar1Trad" sender:self];
    else
        [self performSegueWithIdentifier:@"changeCar1" sender:self];
}

-(void)changeCar2
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:@"Makes Layout Preference"]isEqualToString:@"Grid"])
        [self performSegueWithIdentifier:@"changeCar2Trad" sender:self];
    else
        [self performSegueWithIdentifier:@"changeCar2" sender:self];}

-(void)revertToDetailView
{
    avAudioPlayer1 = nil;
    avAudioPlayer2 = nil;
    hasLoaded1 = NO;
    hasLoaded2 = NO;
    [activityIndicator1 removeFromSuperview];
    [activityIndicator2 removeFromSuperview];
    isplaying1 = NO;
    isplaying2 = NO;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[currentCar.CarFullName stringByAppendingString:@" Specs"]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    shouldAnimateCell = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [specsCollectionView performBatchUpdates:^{
            cellWidth = cellWidth/2;
            
        }completion:nil];
        
    });
    
    shouldBeCompare = NO;
    shouldBeDetail = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [specsCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [specsCollectionView layoutIfNeeded];
    });
    
    if(cameFromMakes)
    {
        NewMakesViewController *superView = (NewMakesViewController *)self.parentViewController;
        
        [UILabel animateWithDuration:.5 animations:^{
            [superView.detailImageScroller setAlpha:1.0];
        }];
        [self setTitleLabelWithString:currentCar.CarMake andView:self.parentViewController];
    }
    else if(cameFromModel)
    {
        ModelViewController *superView = (ModelViewController *)self.parentViewController;
        
        [UILabel animateWithDuration:.5 animations:^{
            [superView.detailImageScroller setAlpha:1.0];
        }];
        [self setTitleLabelWithString:currentCar.CarMake andView:self.parentViewController];
    }
    else if(cameFromTopTens)
    {
        NewTopTensViewController *superView = (NewTopTensViewController *)self.parentViewController;
        
        [UILabel animateWithDuration:.5 animations:^{
            [superView.detailImageScroller setAlpha:1.0];
        }];
        [self setTitleLabelWithString:currentCar.CarMake andView:self.parentViewController];
    }
    else if(cameFromFavorites)
    {
        FavoritesViewController *superView = (FavoritesViewController *)self.parentViewController;
        
        [UILabel animateWithDuration:.5 animations:^{
            [superView.detailImageScroller setAlpha:1.0];
        }];
        [self setTitleLabelWithString:currentCar.CarMake andView:self.parentViewController];
    }
    else if(cameFromSearchModel)
    {
        SearchModelController *superView = (SearchModelController *)self.parentViewController;
        
        [UILabel animateWithDuration:.5 animations:^{
            [superView.detailImageScroller setAlpha:1.0];
        }];
        [self setTitleLabelWithString:currentCar.CarMake andView:self.parentViewController];
    }
    else if(cameFromSearchTab)
    {
        SearchTabViewController *superView = (SearchTabViewController *)self.parentViewController;
        
        [UILabel animateWithDuration:.5 animations:^{
            [superView.detailImageScroller setAlpha:1.0];
        }];
        [self setTitleLabelWithString:currentCar.CarMake andView:self.parentViewController];
    }
    else
        [self setTitleLabelWithString:currentCar.CarMake andView:self];
    
    self.parentViewController.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftBarButtonItems = nil;
    
    if(cameFromMakes)
    {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self.parentViewController action:@selector(revertToMakesPage)];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.parentViewController.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    }
    else if(cameFromTopTens)
    {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:@selector(unwindToTopTens)];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.parentViewController.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    }
    else if(cameFromFavorites)
    {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:@selector(unwindToFavorites)];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.parentViewController.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    }
    else if(cameFromModel)
    {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self.parentViewController action:@selector(revertToModelsPage)];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.parentViewController.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    }
    else if(cameFromSearchModel)
    {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self.parentViewController action:@selector(revertToSearchModelPage)];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.parentViewController.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    }
    else if(cameFromSearchTab)
    {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self.parentViewController action:@selector(revertToSearchTabPage)];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.parentViewController.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    }
    else
    {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:@selector(unwindToHomeVC)];
        backButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -9;
        [self.parentViewController.navigationItem setLeftBarButtonItems:@[negativeSpacer, backButton]];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        shouldAnimateCell = NO;
    });
}

-(void)unwindToHomeVC
{
    [self performSegueWithIdentifier:@"unwindToHomeVC" sender:self];
}

-(void)unwindToTopTens
{
    [self performSegueWithIdentifier:@"unwindToTopTens" sender:self];
}

-(void)unwindToFavorites
{
    [self performSegueWithIdentifier:@"unwindToFavorites" sender:self];
}

-(void)unwindToModel
{
    [self performSegueWithIdentifier:@"unwindToModelVC" sender:self];
}

-(void)saveAndGetCars
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *savedFirstCarData = [defaults objectForKey:@"firstcar"];
    NSData *savedSecondCarData = [defaults objectForKey:@"secondcar"];
    
    NSData *currentCarData = [NSKeyedArchiver archivedDataWithRootObject:currentCar];

    if(savedFirstCarData == NULL)
    {
        firstCar = currentCar;
        [defaults setObject:currentCarData forKey:@"firstcar"];
        
        NSData *secondCarData = [defaults objectForKey:@"secondcar"];
        secondCar = [NSKeyedUnarchiver unarchiveObjectWithData:secondCarData];
    }
    else
    if(savedSecondCarData == NULL)
    {
        secondCar = currentCar;
        [defaults setObject:currentCarData forKey:@"secondcar"];
        
        NSData *firstCarData = [defaults objectForKey:@"firstcar"];
        firstCar = [NSKeyedUnarchiver unarchiveObjectWithData:firstCarData];
    }
    else
    {
        firstCar = currentCar;
        [defaults setObject:currentCarData forKey:@"firstcar"];
        
        NSData *secondCarData = [defaults objectForKey:@"secondcar"];
        secondCar = [NSKeyedUnarchiver unarchiveObjectWithData:secondCarData];
    }
    if(firstCar != NULL)
        [self performSelectorInBackground:@selector(setUpAVAudioPlayer1) withObject:nil];
    if(secondCar != NULL)
        [self performSelectorInBackground:@selector(setUpAVAudioPlayer2) withObject:nil];
}

-(void)setTitleLabelWithString:(NSString *)titleString andView:(UIViewController *)view
{
    [view setTitle:titleString];
    if([titleString isEqualToString:@"Compare"])
    {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Compare"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
}

- (UIImage*)resizeImage:(UIImage*)aImage reSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [aImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"changeCar1"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"firstcar"];
        [[segue destinationViewController]setUpUnwindToCompare];
    }
    if ([[segue identifier] isEqualToString:@"changeCar1Trad"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"firstcar"];
        [[segue destinationViewController]setUpUnwindToCompare];
    }
    if ([[segue identifier] isEqualToString:@"changeCar2"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"secondcar"];
        [[segue destinationViewController]setUpUnwindToCompare];
    }
    if ([[segue identifier] isEqualToString:@"changeCar2Trad"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"secondcar"];
        [[segue destinationViewController]setUpUnwindToCompare];
    }
    if ([[segue identifier] isEqualToString:@"pushImageView"])
    {
        [[segue destinationViewController] getModel:currentCar];
    }
    if ([[segue identifier] isEqualToString:@"pushImageView1"])
    {
        [[segue destinationViewController] getModel:firstCar];
    }
    if ([[segue identifier] isEqualToString:@"pushImageView2"])
    {
        [[segue destinationViewController] getModel:secondCar];
    }
}

#pragma mark Setup Methods

- (void)getModel:(id)modelObject
{
    shouldLoadImage = YES;
    currentCar = modelObject;
}

-(void)getCarToLoad:(id)modelObject sender:(id)sender
{
    currentCar = modelObject;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self performSelectorInBackground:@selector(setUpAVAudioPlayer) withObject:nil];
    });
    
    if([sender isKindOfClass:[NewTopTensViewController class]])
    {
        cameFromTopTens = YES;
    }
    if([sender isKindOfClass:[FavoritesViewController class]])
    {
        cameFromFavorites = YES;
    }
    if([sender isKindOfClass:[NewMakesViewController class]])
    {
        cameFromMakes = YES;
    }
    if([sender isKindOfClass:[ModelViewController class]])
    {
        cameFromModel = YES;
    }
    if([sender isKindOfClass:[SearchModelController class]])
    {
        cameFromSearchModel = YES;
    }
    if([sender isKindOfClass:[SearchTabViewController class]])
    {
        cameFromSearchTab = YES;
    }
    if([sender isKindOfClass:[TestViewController class]])
    {
        cameFromHome = YES;
        shouldLoadImage = YES;
    }
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:[currentCar.CarFullName stringByAppendingString:@" Specs"]];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

-(void)pushSpecsDispute
{
    [self performSegueWithIdentifier:@"pushSpecsDispute" sender:self];
}

- (IBAction)unwindToCompareVC:(UIStoryboardSegue *)segue
{
    
}

@end
