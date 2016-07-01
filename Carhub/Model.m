//
//  Model.m
//  Carhub
//
//  Created by Christopher Clark on 9/1/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "Model.h"

@implementation Model

@synthesize CarMake, CarModel, CarYearsMade, CarPrice, CarEngine, CarTransmission, CarDriveType, CarHorsepower, CarZeroToSixty, CarTopSpeed, CarWeight, CarFuelEconomy, CarImageURL, CarWebsite, CarFullName, CarHorsepowerHigh, CarHorsepowerLow, CarPriceHigh, CarPriceLow, CarZeroToSixtyHigh, CarZeroToSixtyLow, CarExhaust, CarFuelEconomyHigh, CarFuelEconomyLow, isClass, isSubclass, CarClass, CarSubclass, isModel, CarHTML, OffsetX, OffsetY, ZoomScale, CarWeightLow, CarWeightHigh, CarMSRP;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self CarMake] forKey:@"CarMake"];
    [aCoder encodeObject:[self CarModel] forKey:@"CarModel"];
    [aCoder encodeObject:[self CarYearsMade] forKey:@"CarYearsMade"];
    [aCoder encodeObject:[self CarMSRP] forKey:@"CarMSRP"];
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
    [aCoder encodeObject:[self CarWeightLow] forKey:@"CarWeightLow"];
    [aCoder encodeObject:[self CarWeightHigh] forKey:@"CarWeightHigh"];
    [aCoder encodeObject:[self CarFuelEconomy] forKey:@"CarFuelEconomy"];
    [aCoder encodeObject:[self CarFuelEconomyLow] forKey:@"CarFuelEconomyLow"];
    [aCoder encodeObject:[self CarFuelEconomyHigh] forKey:@"CarFuelEconomyHigh"];
    [aCoder encodeObject:[self CarImageURL] forKey:@"CarImageURL"];
    [aCoder encodeObject:[self CarFullName] forKey:@"CarFullName"];
    [aCoder encodeObject:[self CarExhaust] forKey:@"CarExhaust"];
    [aCoder encodeObject:[self CarHTML] forKey:@"CarHTML"];
    [aCoder encodeObject:[self isClass] forKey:@"isClass"];
    [aCoder encodeObject:[self isSubclass] forKey:@"isSubclass"];
    [aCoder encodeObject:[self isModel] forKey:@"isModel"];
    [aCoder encodeObject:[self CarClass] forKey:@"CarClass"];
    [aCoder encodeObject:[self CarSubclass] forKey:@"CarSubclass"];
    [aCoder encodeObject:[self ZoomScale] forKey:@"ZoomScale"];
    [aCoder encodeObject:[self OffsetX] forKey:@"OffsetX"];
    [aCoder encodeObject:[self OffsetY] forKey:@"OffsetY"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init])){
        self.CarMake = [aDecoder decodeObjectForKey:@"CarMake"];
        self.CarModel = [aDecoder decodeObjectForKey:@"CarModel"];
        self.CarYearsMade = [aDecoder decodeObjectForKey:@"CarYearsMade"];
        self.CarMSRP = [aDecoder decodeObjectForKey:@"CarMSRP"];
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
        self.CarWeightLow = [aDecoder decodeObjectForKey:@"CarWeightLow"];
        self.CarWeightHigh = [aDecoder decodeObjectForKey:@"CarWeightHigh"];
        self.CarFuelEconomy = [aDecoder decodeObjectForKey:@"CarFuelEconomy"];
        self.CarFuelEconomyLow = [aDecoder decodeObjectForKey:@"CarFuelEconomyLow"];
        self.CarFuelEconomyHigh = [aDecoder decodeObjectForKey:@"CarFuelEconomyHigh"];
        self.CarImageURL = [aDecoder decodeObjectForKey:@"CarImageURL"];
        self.CarFullName = [aDecoder decodeObjectForKey:@"CarFullName"];
        self.CarExhaust = [aDecoder decodeObjectForKey:@"CarExhaust"];
        self.CarHTML = [aDecoder decodeObjectForKey:@"CarHTML"];
        self.isClass = [aDecoder decodeObjectForKey:@"isClass"];
        self.isSubclass = [aDecoder decodeObjectForKey:@"isSubclass"];
        self.isModel = [aDecoder decodeObjectForKey:@"isModel"];
        self.CarClass = [aDecoder decodeObjectForKey:@"CarClass"];
        self.CarSubclass = [aDecoder decodeObjectForKey:@"CarSubclass"];
        self.ZoomScale = [aDecoder decodeObjectForKey:@"ZoomScale"];
        self.OffsetX = [aDecoder decodeObjectForKey:@"OffsetX"];
        self.OffsetY = [aDecoder decodeObjectForKey:@"OffsetY"];
    }
    return self;
}

- (id)initWithCarMake:(NSString *)cMake andCarModel:(NSString *)cModel andCarYearsMade:(NSString *)cYearsMade andCarMSRP:(NSNumber *)cMSRP andCarPrice:(NSString *)cPrice andCarPriceLow:(NSNumber *)cPriceLow andCarPriceHigh:(NSNumber *)cPriceHigh andCarEngine:(NSString *)cEngine andCarTransmission:(NSString *)cTransmission andCarDriveType:(NSString *)cDriveType andCarHorsepower:(NSString *)cHorsepower andCarHorsepowerLow:(NSNumber *)cHorsepowerLow andCarHorsepowerHigh:(NSNumber *)cHorsepowerHigh andCarZeroToSixty:(NSString *)cZeroToSixty andCarZeroToSixtyLow:(NSNumber *)cZeroToSixtyLow andCarZeroToSixtyHigh:(NSNumber *)cZeroToSixtyHigh andCarTopSpeed:(NSString *)cTopSpeed andCarWeight:(NSString *)cWeight andCarWeightLow:(NSNumber *)cWeightLow andCarWeightHigh:(NSNumber *)cWeightHigh andCarFuelEconomy:(NSString *)cFuelEconomy andCarFuelEconomyLow:(NSNumber *)cFuelEconomyLow andCarFuelEconomyHigh:(NSNumber *)cFuelEconomyHigh andCarImageURL:(NSString *)cURL andCarWebsite:(NSString *)cWebsite andCarFullName:(NSString *)cFullName andCarExhaust:(NSString *)cExhaust andCarHTML:(NSString *)cHTML andisClass:(NSNumber *)cisClass andisSubclass:(NSNumber *)cisSubClass andisModel:(NSNumber *)cisModel andCarClass:(NSString *)cCarClass andCarSubclass:(NSString *)cCarSubclass andZoomScale:(NSNumber *)cZoomScale andOffsetX:(NSNumber *)cOffsetX andOffsetY:(NSNumber *)cOffsetY
{
    self = [super init];
    if (self)
    {
        CarMake = cMake;
        CarModel = cModel;
        CarYearsMade = cYearsMade;
        CarMSRP = cMSRP;
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
        CarWeightLow = cWeightLow;
        CarWeightHigh = cWeightHigh;
        CarFuelEconomy = cFuelEconomy;
        CarFuelEconomyLow = cFuelEconomyLow;
        CarFuelEconomyHigh = cFuelEconomyHigh;
        CarImageURL = cURL;
        CarWebsite = cWebsite;
        CarFullName = cFullName;
        CarExhaust = cExhaust;
        CarHTML = cHTML;
        isClass = cisClass;
        isSubclass = cisSubClass;
        isModel = cisModel;
        CarClass = cCarClass;
        CarSubclass = cCarSubclass;
        ZoomScale = cZoomScale;
        OffsetX = cOffsetX;
        OffsetY = cOffsetY;
    }
    return self;
}

@end
