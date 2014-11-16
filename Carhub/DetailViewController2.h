//
//  DetailViewController2.h
//  Carhub
//
//  Created by Christopher Clark on 7/26/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

/*
 @interface ViewController : UIViewController <ADBannerViewDelegate>
 @end
 */
@interface DetailViewController2 : UIViewController
{
    IBOutlet UIImageView *imageview;
    IBOutlet UIScrollView * scroller;
}
@property(nonatomic, strong) IBOutlet UITextField * YearsMade;
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
@property(nonatomic, strong) IBOutlet UILabel * allLabels;
@property(nonatomic, strong) IBOutlet UILabel * priceLabels;
@property(nonatomic, strong) IBOutlet UILabel * engineLabels;
@property(nonatomic, strong) IBOutlet UILabel * drivetypeLabels;
@property(nonatomic, strong) IBOutlet UILabel * horsepowerLabels;
@property(nonatomic, strong) IBOutlet UILabel * zerotosixtyLabels;
@property(nonatomic, strong) IBOutlet UILabel * topspeedLabels;
@property(nonatomic, strong) IBOutlet UILabel * weightLabels;
@property(nonatomic, strong) IBOutlet UILabel * fueleconomyLabels;
@property(nonatomic, strong) IBOutlet UILabel * transmissionLabels;

@property(nonatomic, strong) Model * currentCar;

#pragma mark -
#pragma mark Methods

- (void)getfirstModel:(id)firstcarObject3;
@property(nonatomic, strong) Model * firstCar3;
@property(nonatomic, strong) Model * secondCar3;

- (void)getModel:(id)modelObject;
- (void)setLabels;
-(IBAction)Website;
@end
