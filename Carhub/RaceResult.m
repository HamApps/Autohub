//
//  RaceResult.m
//  Carhub
//
//  Created by Christopher Clark on 10/10/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import "RaceResult.h"

@implementation RaceResult
@synthesize Position, Driver, Team, Time, BestLapTime, RaceClass, RaceID, Car, Country, Category, CarNumber, Driver2, Driver3, Excluded;

-(id)initWithPosition:(NSNumber *)nPosition andExcluded:(NSString *)nExcluded andDriver:(NSString *)nDriver andTeam:(NSString *)nTeam andCountry:(NSString *)nCountry andCar:(NSString *)nCar andTime:(NSString *)nTime andBestLapTime:(NSString *)nBestLapTime andRaceClass:(NSString *)nRaceClass andRaceID:(NSString *)nRaceID andDriver2:(NSString *)nDriver2 andDriver3:(NSString *)nDriver3 andCategory:(NSString *)nCategory andCarNumber:(NSString *)nCarNumber
{
    self = [super init];
    if (self)
    {
        Position = nPosition;
        Excluded = nExcluded;
        Driver = nDriver;
        Driver2 = nDriver2;
        Driver3 = nDriver3;
        Team = nTeam;
        Country = nCountry;
        Car = nCar;
        Time = nTime;
        BestLapTime = nBestLapTime;
        RaceClass = nRaceClass;
        RaceID = nRaceID;
        Category = nCategory;
        CarNumber = nCarNumber;
    }
    return self;
}

@end
