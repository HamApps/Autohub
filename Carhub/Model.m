//
//  Model.m
//  Carhub
//
//  Created by Christopher Clark on 9/1/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "Model.h"

@implementation Model

@synthesize CarMake, CarModel, CarYearsMade, CarPrice, CarEngine, CarTransmission, CarDriveType, CarHorsepower, CarZeroToSixty, CarTopSpeed, CarWeight, CarFuelEconomy, CarImageURL, CarWebsite, CarFullName, CarHorsepowerHigh, CarHorsepowerLow, CarPriceHigh, CarPriceLow, CarZeroToSixtyHigh, CarZeroToSixtyLow;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self CarMake] forKey:@"CarMake"];
    [aCoder encodeObject:[self CarModel] forKey:@"CarModel"];
    [aCoder encodeObject:[self CarYearsMade] forKey:@"CarYearsMade"];
    [aCoder encodeObject:[self CarPrice] forKey:@"CarPrice"];
    [aCoder encodeObject:[self CarPriceLow] forKey:@"CarPriceLow"];
    [aCoder encodeObject:[self CarPriceHigh] forKey:@"CarPriceHigh"];
    [aCoder encodeObject:[self CarEngine] forKey:@"CarEngine"];
    [aCoder encodeObject:[self CarTransmission] forKey:@"CarTransmission"];
    [aCoder encodeObject:[self CarDriveType] forKey:@"CarDriveType"];
    [aCoder encodeObject:[self CarHorsepower] forKey:@"CarHorsepower"];
    [aCoder encodeObject:[self CarHorsepowerLow] forKey:@"CarHorsepowerLow"];
    [aCoder encodeObject:[self CarHorsepowerHigh] forKey:@"CarHorsepowerHigh"];
    [aCoder encodeObject:[self CarZeroToSixty] forKey:@"CarZeroToSixty"];
    [aCoder encodeObject:[self CarZeroToSixtyLow] forKey:@"CarZeroToSixtyLow"];
    [aCoder encodeObject:[self CarZeroToSixtyHigh] forKey:@"CarZeroToSixtyHigh"];
    [aCoder encodeObject:[self CarTopSpeed] forKey:@"CarTopSpeed"];
    [aCoder encodeObject:[self CarWeight] forKey:@"CarWeight"];
    [aCoder encodeObject:[self CarFuelEconomy] forKey:@"CarFuelEconomy"];
    [aCoder encodeObject:[self CarImageURL] forKey:@"CarImageURL"];
    [aCoder encodeObject:[self CarFullName] forKey:@"CarFullName"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init])){
        self.CarMake = [aDecoder decodeObjectForKey:@"CarMake"];
        self.CarModel = [aDecoder decodeObjectForKey:@"CarModel"];
        self.CarYearsMade = [aDecoder decodeObjectForKey:@"CarYearsMade"];
        self.CarPrice = [aDecoder decodeObjectForKey:@"CarPrice"];
        self.CarPriceLow = [aDecoder decodeObjectForKey:@"CarPriceLow"];
        self.CarPriceHigh = [aDecoder decodeObjectForKey:@"CarPriceHigh"];
        self.CarEngine = [aDecoder decodeObjectForKey:@"CarEngine"];
        self.CarTransmission = [aDecoder decodeObjectForKey:@"CarTransmission"];
        self.CarDriveType = [aDecoder decodeObjectForKey:@"CarDriveType"];
        self.CarHorsepower = [aDecoder decodeObjectForKey:@"CarHorsepower"];
        self.CarHorsepowerLow = [aDecoder decodeObjectForKey:@"CarHorsepowerLow"];
        self.CarHorsepowerHigh = [aDecoder decodeObjectForKey:@"CarHorsepowerHigh"];
        self.CarZeroToSixty = [aDecoder decodeObjectForKey:@"CarZeroToSixty"];
        self.CarZeroToSixtyLow = [aDecoder decodeObjectForKey:@"CarZeroToSixtyLow"];
        self.CarZeroToSixtyHigh = [aDecoder decodeObjectForKey:@"CarZeroToSixtyHigh"];
        self.CarTopSpeed = [aDecoder decodeObjectForKey:@"CarTopSpeed"];
        self.CarWeight = [aDecoder decodeObjectForKey:@"CarWeight"];
        self.CarFuelEconomy = [aDecoder decodeObjectForKey:@"CarFuelEconomy"];
        self.CarImageURL = [aDecoder decodeObjectForKey:@"CarImageURL"];
        self.CarFullName = [aDecoder decodeObjectForKey:@"CarFullName"];
    }
    return self;
}

- (id)initWithCarMake:(NSString *)cMake andCarModel:(NSString *)cModel andCarYearsMade:(NSString *)cYearsMade andCarPrice:(NSString *)cPrice andCarPriceLow:(NSNumber *)cPriceLow andCarPriceHigh:(NSNumber *)cPriceHigh andCarEngine:(NSString *)cEngine andCarTransmission:(NSString *)cTransmission andCarDriveType:(NSString *)cDriveType andCarHorsepower:(NSString *)cHorsepower andCarHorsepowerLow:(NSNumber *)cHorsepowerLow andCarHorsepowerHigh:(NSNumber *)cHorsepowerHigh andCarZeroToSixty:(NSString *)cZeroToSixty andCarZeroToSixtyLow:(NSNumber *)cZeroToSixtyLow andCarZeroToSixtyHigh:(NSNumber *)cZeroToSixtyHigh andCarTopSpeed:(NSString *)cTopSpeed andCarWeight:(NSString *)cWeight andCarFuelEconomy:(NSString *)cFuelEconomy andCarImageURL:(NSString *)cURL andCarWebsite:(NSString *)cWebsite andCarFullName:(NSString *)cFullName{
    self = [super init];
    if (self)
    {
        CarMake = cMake;
        CarModel = cModel;
        CarYearsMade = cYearsMade;
        CarPrice = cPrice;
        CarPriceLow = cPriceLow;
        CarPriceHigh = cPriceHigh;
        CarEngine = cEngine;
        CarTransmission = cTransmission;
        CarDriveType = cDriveType;
        CarHorsepower = cHorsepower;
        CarHorsepowerLow = cHorsepowerLow;
        CarHorsepowerHigh = cHorsepowerHigh;
        CarZeroToSixty = cZeroToSixty;
        CarZeroToSixtyLow = cZeroToSixtyLow;
        CarZeroToSixtyHigh = cZeroToSixtyHigh;
        CarTopSpeed = cTopSpeed;
        CarWeight = cWeight;
        CarFuelEconomy = cFuelEconomy;
        CarImageURL = cURL;
        CarWebsite = cWebsite;
        CarFullName = cFullName;
    }
    return self;
}

@end
