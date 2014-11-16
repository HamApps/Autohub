//
//  Model.m
//  Carhub
//
//  Created by Christopher Clark on 9/1/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "Model.h"

@implementation Model
@synthesize CarMake, CarModel, CarYearsMade, CarPrice, CarEngine, CarTransmission, CarDriveType, CarHorsepower, CarZeroToSixty, CarTopSpeed, CarWeight, CarFuelEconomy, CarImageURL, CarWebsite;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil){
        self.CarMake = [aDecoder decodeObjectForKey:@"CarMake"];
        self.CarModel = [aDecoder decodeObjectForKey:@"CarModel"];
        self.CarYearsMade = [aDecoder decodeObjectForKey:@"CarYearsMade"];
        self.CarPrice = [aDecoder decodeObjectForKey:@"CarPrice"];
        self.CarEngine = [aDecoder decodeObjectForKey:@"CarEngine"];
        self.CarTransmission = [aDecoder decodeObjectForKey:@"CarTransmission"];
        self.CarDriveType = [aDecoder decodeObjectForKey:@"CarDriveType"];
        self.CarHorsepower = [aDecoder decodeObjectForKey:@"CarHorsepower"];
        self.CarZeroToSixty = [aDecoder decodeObjectForKey:@"CarZeroToSixty"];
        self.CarTopSpeed = [aDecoder decodeObjectForKey:@"CarTopSpeed"];
        self.CarWeight = [aDecoder decodeObjectForKey:@"CarWeight"];
        self.CarFuelEconomy = [aDecoder decodeObjectForKey:@"CarFuelEconomy"];
        self.CarImageURL = [aDecoder decodeObjectForKey:@"CarImageURL"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self CarMake] forKey:@"CarMake"];
    [aCoder encodeObject:[self CarModel] forKey:@"CarModel"];
    [aCoder encodeObject:[self CarYearsMade] forKey:@"CarYearsMade"];
    [aCoder encodeObject:[self CarPrice] forKey:@"CarPrice"];
    [aCoder encodeObject:[self CarEngine] forKey:@"CarEngine"];
    [aCoder encodeObject:[self CarTransmission] forKey:@"CarTransmission"];
    [aCoder encodeObject:[self CarDriveType] forKey:@"CarDriveType"];
    [aCoder encodeObject:[self CarHorsepower] forKey:@"CarHorsepower"];
    [aCoder encodeObject:[self CarZeroToSixty] forKey:@"CarZeroToSixty"];
    [aCoder encodeObject:[self CarTopSpeed] forKey:@"CarTopSpeed"];
    [aCoder encodeObject:[self CarWeight] forKey:@"CarWeight"];
    [aCoder encodeObject:[self CarFuelEconomy] forKey:@"CarFuelEconomy"];
    [aCoder encodeObject:[self CarImageURL] forKey:@"CarImageURL"];
}

- (id)initWithCarMake:(NSString *)cMake andCarModel:(NSString *)cModel andCarYearsMade:(NSString *)cYearsMade andCarPrice:(NSString *)cPrice andCarEngine:(NSString *)cEngine andCarTransmission:(NSString *)cTransmission andCarDriveType:(NSString *)cDriveType andCarHorsepower:(NSString *)cHorsepower andCarZeroToSixty:(NSString *)cZeroToSixty andCarTopSpeed:(NSString *)cTopSpeed andCarWeight:(NSString *)cWeight andCarFuelEconomy:(NSString *)cFuelEconomy andCarImageURL:(NSString *)cURL andCarWebsite:(NSString *)cWebsite
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
        CarWebsite = cWebsite;
        
    }
    
    return self;
}

@end
