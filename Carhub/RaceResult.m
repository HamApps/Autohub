//
//  RaceResult.m
//  Carhub
//
//  Created by Christopher Clark on 10/10/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import "RaceResult.h"

@implementation RaceResult
@synthesize Position, Driver, Team, Time, BestLapTime, RaceClass, RaceID, Car, Country;

-(id)initWithPosition:(NSString *)nPosition andDriver:(NSString *)nDriver andTeam:(NSString *)nTeam andCountry:(NSString *)nCountry andCar:(NSString *)nCar andTime:(NSString *)nTime andBestLapTime:(NSString *)nBestLapTime andRaceClass:(NSString *)nRaceClass andRaceID:(NSString *)nRaceID
{
    self = [super init];
    if (self)
    {
        Position = nPosition;
        Driver = nDriver;
        Team = nTeam;
        Country = nCountry;
        Car = nCar;
        Time = nTime;
        BestLapTime = nBestLapTime;
        RaceClass = nRaceClass;
        RaceID = nRaceID;
    }
    return self;
}

@end
