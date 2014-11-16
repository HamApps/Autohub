//
//  Model1.m
//  Carhub
//
//  Created by Christopher Clark on 8/31/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "Model1.h"

@implementation Model1
@synthesize CarMake, CarModel, CarYearsMade, CarPrice, CarEngine, CarTransmission, CarDriveType, CarHorsepower, CarZeroToSixty, CarTopSpeed, CarWeight, CarFuelEconomy, CarImageURL;

- (id)initWithCarMake:(NSString *)cMake andCarModel:(NSString *)cModel andCarYearsMade:(NSString *)cYearsMade andCarPrice:(NSString *)cPrice andCarEngine:(NSString *)cEngine andCarTransmission:(NSString *)cTransmission andCarDriveType:(NSString *)cDriveType andCarHorsepower:(NSString *)cHorsepower andCarZeroToSixty:(NSString *)cZeroToSixty andCarTopSpeed:(NSString *)cTopSpeed andCarWeight:(NSString *)cWeight andCarFuelEconomy:(NSString *)cFuelEconomy andCarImageURL:(NSString *)cURL
{
    self = [super init];
    if (self)
    {
        CarMake = cMake;
        CarModel = cModel;
        CarYearsMade = cYearsMade;
        CarPrice = cPrice;
        CarEngine = cEngine;
        CarTransmission = cTransmission;
        CarDriveType = cDriveType;
        CarHorsepower = cHorsepower;
        CarZeroToSixty = cZeroToSixty;
        CarTopSpeed = cTopSpeed;
        CarWeight = cWeight;
        CarFuelEconomy = cFuelEconomy;
        CarImageURL = cURL;
        
    }
    
    return self;
}

@end
