//
//  RaceResult.h
//  Carhub
//
//  Created by Christopher Clark on 10/10/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RaceResult : NSObject

@property (strong, nonatomic) NSNumber * Position;
@property (strong, nonatomic) NSString * Excluded;
@property (strong, nonatomic) NSString * Driver;
@property (strong, nonatomic) NSString * Driver2;
@property (strong, nonatomic) NSString * Driver3;
@property (strong, nonatomic) NSString * Category;
@property (strong, nonatomic) NSString * Team;
@property (strong, nonatomic) NSString * Country;
@property (strong, nonatomic) NSString * Car;
@property (strong, nonatomic) NSString * Time;
@property (strong, nonatomic) NSString * BestLapTime;
@property (strong, nonatomic) NSString * RaceClass;
@property (strong, nonatomic) NSString * RaceID;
@property (strong, nonatomic) NSString * CarNumber;

- (id)initWithPosition:(NSNumber *)nPosition andExcluded:(NSString *)nExcluded andDriver:(NSString *)nDriver andTeam:(NSString *)nTeam andCountry:(NSString *)nCountry andCar:(NSString *)nCar andTime:(NSString *)nTime andBestLapTime:(NSString *)nBestLapTime andRaceClass:(NSString *)nRaceClass andRaceID:(NSString *)nRaceID andDriver2:(NSString *)nDriver2 andDriver3:(NSString *)nDriver3 andCategory:(NSString *)nCategory andCarNumber:(NSString *)nCarNumber;

@end
