//
//  Model.h
//  Carhub
//
//  Created by Christopher Clark on 9/1/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject <NSCoding>

@property (strong, nonatomic) NSString * CarMake;
@property (strong, nonatomic) NSString * CarModel;
@property (strong, nonatomic) NSString * CarYearsMade;
@property (strong, nonatomic) NSNumber * CarMSRP;
@property (strong, nonatomic) NSString * CarPrice;
@property (strong, nonatomic) NSNumber * CarPriceLow;
@property (strong, nonatomic) NSNumber * CarPriceHigh;
@property (strong, nonatomic) NSString * CarEngine;
@property (strong, nonatomic) NSString * CarTransmission;
@property (strong, nonatomic) NSString * CarDriveType;
@property (strong, nonatomic) NSString * CarHorsepower;
@property (strong, nonatomic) NSNumber * CarHorsepowerLow;
@property (strong, nonatomic) NSNumber * CarHorsepowerHigh;
@property (strong, nonatomic) NSString * CarZeroToSixty;
@property (strong, nonatomic) NSNumber * CarZeroToSixtyLow;
@property (strong, nonatomic) NSNumber * CarZeroToSixtyHigh;
@property (strong, nonatomic) NSString * CarTopSpeed;
@property (strong, nonatomic) NSString * CarWeight;
@property (strong, nonatomic) NSNumber * CarWeightLow;
@property (strong, nonatomic) NSNumber * CarWeightHigh;
@property (strong, nonatomic) NSString * CarFuelEconomy;
@property (strong, nonatomic) NSNumber * CarFuelEconomyLow;
@property (strong, nonatomic) NSNumber * CarFuelEconomyHigh;
@property (strong, nonatomic) NSString * CarImageURL;
@property (strong, nonatomic) NSString * CarWebsite;
@property (strong, nonatomic) NSString * CarFullName;
@property (strong, nonatomic) NSString * CarExhaust;
@property (strong, nonatomic) NSString * CarHTML;
@property (strong, nonatomic) NSNumber * isClass;
@property (strong, nonatomic) NSNumber * isSubclass;
@property (strong, nonatomic) NSNumber * isModel;
@property (strong, nonatomic) NSString * CarClass;
@property (strong, nonatomic) NSString * CarSubclass;
@property (strong, nonatomic) NSNumber * ZoomScale;
@property (strong, nonatomic) NSNumber * OffsetX;
@property (strong, nonatomic) NSNumber * OffsetY;

#pragma mark -
#pragma mark Class Methods

- (id)initWithCarMake: (NSString *)cMake andCarModel: (NSString *)cModel andCarYearsMade: (NSString *)cYearsMade andCarMSRP: (NSNumber *)cMSRP andCarPrice: (NSString *) cPrice andCarPriceLow: (NSNumber *) cPriceLow andCarPriceHigh: (NSNumber *) cPriceHigh andCarEngine: (NSString *)cEngine andCarTransmission: (NSString *)cTransmission andCarDriveType: (NSString *)cDriveType andCarHorsepower: (NSString *) cHorsepower andCarHorsepowerLow: (NSNumber *) cHorsepowerLow andCarHorsepowerHigh: (NSNumber *) cHorsepowerHigh andCarZeroToSixty: (NSString *)cZeroToSixty andCarZeroToSixtyLow: (NSNumber *) cZeroToSixtyLow andCarZeroToSixtyHigh: (NSNumber *) cZeroToSixtyHigh andCarTopSpeed: (NSString *)cTopSpeed andCarWeight: (NSString *)cWeight andCarWeightLow: (NSNumber *) cWeightLow andCarWeightHigh: (NSNumber *) cWeightHigh andCarFuelEconomy: (NSString *)cFuelEconomy andCarFuelEconomyLow: (NSNumber *)cFuelEconomyLow andCarFuelEconomyHigh: (NSNumber *)cFuelEconomyHigh andCarImageURL: (NSString *)cURL andCarWebsite: (NSString *)cWebsite andCarFullName: (NSString *)cFullName andCarExhaust: (NSString *)cExhaust andCarHTML: (NSString *)cHTML andisClass: (NSNumber *)cisClass andisSubclass: (NSNumber *)cisSubClass andisModel: (NSNumber *)cisModel andCarClass: (NSString *)cCarClass andCarSubclass: (NSString *)cCarSubclass andZoomScale: (NSNumber *)cZoomScale andOffsetX: (NSNumber *)cOffsetX andOffsetY: (NSNumber *)cOffsetY;

@end
