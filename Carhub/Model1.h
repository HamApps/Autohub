//
//  Model.h
//  Carhub
//
//  Created by Christopher Clark on 7/19/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model1 : NSObject

@property (strong, nonatomic) NSString * CarMake;
@property (strong, nonatomic) NSString * CarModel;
@property (strong, nonatomic) NSString * CarYearsMade;
@property (strong, nonatomic) NSString * CarPrice;
@property (strong, nonatomic) NSString * CarEngine;
@property (strong, nonatomic) NSString * CarTransmission;
@property (strong, nonatomic) NSString * CarDriveType;
@property (strong, nonatomic) NSString * CarHorsepower;
@property (strong, nonatomic) NSString * CarZeroToSixty;
@property (strong, nonatomic) NSString * CarTopSpeed;
@property (strong, nonatomic) NSString * CarWeight;
@property (strong, nonatomic) NSString * CarFuelEconomy;
@property (strong, nonatomic) NSString * CarImageURL;


#pragma mark -
#pragma mark Class Methods

- (id)initWithCarMake: (NSString *)cMake andCarModel: (NSString *)cModel andCarYearsMade: (NSString *)cYearsMade andCarPrice: (NSString *) cPrice andCarEngine: (NSString *)cEngine andCarTransmission: (NSString *)cTransmission andCarDriveType: (NSString *)cDriveType andCarHorsepower: (NSString *) cHorsepower andCarZeroToSixty: (NSString *)cZeroToSixty andCarTopSpeed: (NSString *)cTopSpeed andCarWeight: (NSString *)cWeight andCarFuelEconomy: (NSString *)cFuelEconomy andCarImageURL: (NSString *)cURL;

@end
