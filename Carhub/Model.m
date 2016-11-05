//
//  Model.m
//  Carhub
//
//  Created by Christopher Clark on 9/1/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "Model.h"

@implementation Model

@synthesize CarMake, CarModel, CarYearsMade, CarPrice, CarEngine, CarTransmission, CarDriveType, CarHorsepower, CarZeroToSixty, CarTopSpeed, CarWeight, CarFuelEconomy, CarImageURL, CarWebsite, CarFullName, CarHorsepowerHigh, CarHorsepowerLow, CarPriceHigh, CarPriceLow, CarZeroToSixtyHigh, CarZeroToSixtyLow, CarExhaust, CarFuelEconomyHigh, CarFuelEconomyLow, isClass, isSubclass, CarClass, CarSubclass, isModel, CarHTML, ZoomScale, CarWeightLow, CarWeightHigh, CarMSRP, CarTorque, CarTorqueLow, CarTorqueHigh, isStyle, CarStyle, CarTopSpeedLow, CarTopSpeedHigh, CarPrimaryKey, RemoveLogo, ShouldFlipEvox;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self CarPrimaryKey] forKey:@"CarPrimaryKey"];
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
    [aCoder encodeObject:[self CarTorque] forKey:@"CarTorque"];
    [aCoder encodeObject:[self CarTorqueLow] forKey:@"CarTorqueLow"];
    [aCoder encodeObject:[self CarTorqueHigh] forKey:@"CarTorqueHigh"];
    [aCoder encodeObject:[self CarZeroToSixty] forKey:@"CarZeroToSixty"];
    [aCoder encodeObject:[self CarZeroToSixtyLow] forKey:@"CarZeroToSixtyLow"];
    [aCoder encodeObject:[self CarZeroToSixtyHigh] forKey:@"CarZeroToSixtyHigh"];
    [aCoder encodeObject:[self CarTopSpeed] forKey:@"CarTopSpeed"];
    [aCoder encodeObject:[self CarTopSpeedLow] forKey:@"CarTopSpeedLow"];
    [aCoder encodeObject:[self CarTopSpeedHigh] forKey:@"CarTopSpeedHigh"];
    [aCoder encodeObject:[self CarWeight] forKey:@"CarWeight"];
    [aCoder encodeObject:[self CarWeightLow] forKey:@"CarWeightLow"];
    [aCoder encodeObject:[self CarWeightHigh] forKey:@"CarWeightHigh"];
    [aCoder encodeObject:[self CarFuelEconomy] forKey:@"CarFuelEconomy"];
    [aCoder encodeObject:[self CarFuelEconomyLow] forKey:@"CarFuelEconomyLow"];
    [aCoder encodeObject:[self CarFuelEconomyHigh] forKey:@"CarFuelEconomyHigh"];
    [aCoder encodeObject:[self CarImageURL] forKey:@"CarImageURL"];
    [aCoder encodeObject:[self CarWebsite] forKey:@"CarWebsite"];
    [aCoder encodeObject:[self CarFullName] forKey:@"CarFullName"];
    [aCoder encodeObject:[self CarExhaust] forKey:@"CarExhaust"];
    [aCoder encodeObject:[self CarHTML] forKey:@"CarHTML"];
    [aCoder encodeObject:[self ShouldFlipEvox] forKey:@"ShouldFlipEvox"];
    [aCoder encodeObject:[self isClass] forKey:@"isClass"];
    [aCoder encodeObject:[self isSubclass] forKey:@"isSubclass"];
    [aCoder encodeObject:[self isStyle] forKey:@"isStyle"];
    [aCoder encodeObject:[self isModel] forKey:@"isModel"];
    [aCoder encodeObject:[self CarClass] forKey:@"CarClass"];
    [aCoder encodeObject:[self CarSubclass] forKey:@"CarSubclass"];
    [aCoder encodeObject:[self CarStyle] forKey:@"CarStyle"];
    [aCoder encodeObject:[self RemoveLogo] forKey:@"RemoveLogo"];
    [aCoder encodeObject:[self ZoomScale] forKey:@"ZoomScale"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init])){
        self.CarPrimaryKey = [aDecoder decodeObjectForKey:@"CarPrimaryKey"];
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
        self.CarTorque = [aDecoder decodeObjectForKey:@"CarTorque"];
        self.CarTorqueLow = [aDecoder decodeObjectForKey:@"CarTorqueLow"];
        self.CarTorqueHigh = [aDecoder decodeObjectForKey:@"CarTorqueHigh"];
        self.CarZeroToSixty = [aDecoder decodeObjectForKey:@"CarZeroToSixty"];
        self.CarZeroToSixtyLow = [aDecoder decodeObjectForKey:@"CarZeroToSixtyLow"];
        self.CarZeroToSixtyHigh = [aDecoder decodeObjectForKey:@"CarZeroToSixtyHigh"];
        self.CarTopSpeed = [aDecoder decodeObjectForKey:@"CarTopSpeed"];
        self.CarTopSpeedLow = [aDecoder decodeObjectForKey:@"CarTopSpeedLow"];
        self.CarTopSpeedHigh = [aDecoder decodeObjectForKey:@"CarTopSpeedHigh"];
        self.CarWeight = [aDecoder decodeObjectForKey:@"CarWeight"];
        self.CarWeightLow = [aDecoder decodeObjectForKey:@"CarWeightLow"];
        self.CarWeightHigh = [aDecoder decodeObjectForKey:@"CarWeightHigh"];
        self.CarFuelEconomy = [aDecoder decodeObjectForKey:@"CarFuelEconomy"];
        self.CarFuelEconomyLow = [aDecoder decodeObjectForKey:@"CarFuelEconomyLow"];
        self.CarFuelEconomyHigh = [aDecoder decodeObjectForKey:@"CarFuelEconomyHigh"];
        self.CarImageURL = [aDecoder decodeObjectForKey:@"CarImageURL"];
        self.CarWebsite = [aDecoder decodeObjectForKey:@"CarWebsite"];
        self.CarFullName = [aDecoder decodeObjectForKey:@"CarFullName"];
        self.CarExhaust = [aDecoder decodeObjectForKey:@"CarExhaust"];
        self.CarHTML = [aDecoder decodeObjectForKey:@"CarHTML"];
        self.ShouldFlipEvox = [aDecoder decodeObjectForKey:@"ShouldFlipEvox"];
        self.isClass = [aDecoder decodeObjectForKey:@"isClass"];
        self.isSubclass = [aDecoder decodeObjectForKey:@"isSubclass"];
        self.isStyle = [aDecoder decodeObjectForKey:@"isStyle"];
        self.isModel = [aDecoder decodeObjectForKey:@"isModel"];
        self.CarClass = [aDecoder decodeObjectForKey:@"CarClass"];
        self.CarSubclass = [aDecoder decodeObjectForKey:@"CarSubclass"];
        self.CarStyle = [aDecoder decodeObjectForKey:@"CarStyle"];
        self.RemoveLogo = [aDecoder decodeObjectForKey:@"RemoveLogo"];
        self.ZoomScale = [aDecoder decodeObjectForKey:@"ZoomScale"];
    }
    return self;
}

- (id)initWithCarPrimaryKey:(NSNumber *)cPrimaryKey andCarMake:(NSString *)cMake andCarModel:(NSString *)cModel andCarYearsMade:(NSString *)cYearsMade andCarMSRP:(NSNumber *)cMSRP andCarPrice:(NSString *)cPrice andCarPriceLow:(NSNumber *)cPriceLow andCarPriceHigh:(NSNumber *)cPriceHigh andCarEngine:(NSString *)cEngine andCarTransmission:(NSString *)cTransmission andCarDriveType:(NSString *)cDriveType andCarHorsepower:(NSString *)cHorsepower andCarHorsepowerLow:(NSNumber *)cHorsepowerLow andCarHorsepowerHigh:(NSNumber *)cHorsepowerHigh andCarTorque:(NSString *)cTorque andCarTorqueLow:(NSNumber *)cTorqueLow andCarTorqueHigh:(NSNumber *)cTorqueHigh andCarZeroToSixty:(NSString *)cZeroToSixty andCarZeroToSixtyLow:(NSNumber *)cZeroToSixtyLow andCarZeroToSixtyHigh:(NSNumber *)cZeroToSixtyHigh andCarTopSpeed:(NSString *)cTopSpeed andCarTopSpeedLow:(NSString *)cTopSpeedLow andCarTopSpeedHigh:(NSString *)cTopSpeedHigh andCarWeight:(NSString *)cWeight andCarWeightLow:(NSNumber *)cWeightLow andCarWeightHigh:(NSNumber *)cWeightHigh andCarFuelEconomy:(NSString *)cFuelEconomy andCarFuelEconomyLow:(NSNumber *)cFuelEconomyLow andCarFuelEconomyHigh:(NSNumber *)cFuelEconomyHigh andCarImageURL:(NSString *)cURL andCarWebsite:(NSString *)cWebsite andCarFullName:(NSString *)cFullName andCarExhaust:(NSString *)cExhaust andCarHTML:(NSString *)cHTML andShouldFlipEvox:(NSString *)cShouldFlipEvox andisClass:(NSNumber *)cisClass andisSubclass:(NSNumber *)cisSubClass andisModel:(NSNumber *)cisModel andisStyle:(NSNumber *)cisStyle andCarClass:(NSString *)cCarClass andCarSubclass:(NSString *)cCarSubclass andCarStyle:(NSString *)cCarStyle andRemoveLogo:(NSNumber *)cRemoveLogo andZoomScale:(NSNumber *)cZoomScale
{
    self = [super init];
    if (self)
    {
        CarPrimaryKey = cPrimaryKey;
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
        CarTorque = cTorque;
        CarTorqueLow = cTorqueLow;
        CarTorqueHigh = cTorqueHigh;
        CarZeroToSixty = cZeroToSixty;
        CarZeroToSixtyLow = cZeroToSixtyLow;
        CarZeroToSixtyHigh = cZeroToSixtyHigh;
        CarTopSpeed = cTopSpeed;
        CarTopSpeedLow = cTopSpeedLow;
        CarTopSpeedHigh = cTopSpeedHigh;
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
        ShouldFlipEvox = cShouldFlipEvox;
        isClass = cisClass;
        isSubclass = cisSubClass;
        isStyle = cisStyle;
        isModel = cisModel;
        CarClass = cCarClass;
        CarSubclass = cCarSubclass;
        CarStyle = cCarStyle;
        RemoveLogo = cRemoveLogo;
        ZoomScale = cZoomScale;
    }
    return self;
}

@end
