//
//  CompareViewController2.h
//  Carhub
//
//  Created by Christopher Clark on 7/26/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface CompareViewController2 : UIViewController
{
    IBOutlet UIImageView *firstimageview;
    IBOutlet UIImageView *secondimageview;
    IBOutlet UIScrollView * scroller;
}

@property(nonatomic, strong) IBOutlet UILabel * CarMakeLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarModelLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarYearsMadeLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarPriceLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarEngineLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarTransmissionLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarDriveTypeLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarHorsepowerLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarZeroToSixtyLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarTopSpeedLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarWeightLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarFuelEconomyLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarTitleLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarMakeLabel2;
@property(nonatomic, strong) IBOutlet UILabel * CarModelLabel2;
@property(nonatomic, strong) IBOutlet UILabel * CarYearsMadeLabel2;
@property(nonatomic, strong) IBOutlet UILabel * CarPriceLabel2;
@property(nonatomic, strong) IBOutlet UILabel * CarEngineLabel2;
@property(nonatomic, strong) IBOutlet UILabel * CarTransmissionLabel2;
@property(nonatomic, strong) IBOutlet UILabel * CarDriveTypeLabel2;
@property(nonatomic, strong) IBOutlet UILabel * CarHorsepowerLabel2;
@property(nonatomic, strong) IBOutlet UILabel * CarZeroToSixtyLabel2;
@property(nonatomic, strong) IBOutlet UILabel * CarTopSpeedLabel2;
@property(nonatomic, strong) IBOutlet UILabel * CarWeightLabel2;
@property(nonatomic, strong) IBOutlet UILabel * CarFuelEconomyLabel2;
@property(nonatomic, strong) IBOutlet UILabel * CarTitleLabel2;

@property(nonatomic, strong) Model * firstCar;
@property(nonatomic, strong) Model * secondCar;

#pragma mark -
#pragma mark Methods
- (void)getfirstModel:(id)firstcarObject;
- (void)getsecondModel:(id)secondcarObject;
- (void)setLabels;
@end
