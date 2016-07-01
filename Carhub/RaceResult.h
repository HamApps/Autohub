//
//  RaceResult.h
//  Carhub
//
//  Created by Christopher Clark on 10/10/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RaceResult : NSObject

@property (strong, nonatomic) NSString * Position;
@property (strong, nonatomic) NSString * Driver;
@property (strong, nonatomic) NSString * Team;
@property (strong, nonatomic) NSString * Country;
@property (strong, nonatomic) NSString * Car;
@property (strong, nonatomic) NSString * Time;
@property (strong, nonatomic) NSString * BestLapTime;
@property (strong, nonatomic) NSString * RaceClass;
@property (strong, nonatomic) NSString * RaceID;

- (id)initWithPosition:(NSString *)nPosition andDriver:(NSString *)nDriver andTeam:(NSString *)nTeam andCountry:(NSString *)nCountry andCar:(NSString *)nCar andTime:(NSString *)nTime andBestLapTime:(NSString *)nBestLapTime andRaceClass:(NSString *)nRaceClass andRaceID:(NSString *)nRaceID;

@end
