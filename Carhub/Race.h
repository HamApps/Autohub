//
//  Race.h
//  Carhub
//
//  Created by Christopher Clark on 10/9/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Race : NSObject

@property (strong, nonatomic) NSString * RaceName;
@property (strong, nonatomic) NSString * SeasonRaceName;
@property (strong, nonatomic) NSString * RaceImageURL;
@property (strong, nonatomic) NSNumber * RaceZoomScale;
@property (strong, nonatomic) NSString * RaceType;
@property (strong, nonatomic) NSString * RaceSeason;
@property (strong, nonatomic) NSDate * RaceDate;
@property (strong, nonatomic) NSString * ResultsImageURL1;
@property (strong, nonatomic) NSString * ResultsImageURL2;
@property (strong, nonatomic) NSString * ResultsImageURL3;
@property (strong, nonatomic) NSString * ResultsImageURL4;

- (id)initWithRaceName:(NSString *)nName andSeasonRaceName:(NSString *)nSeasonRaceName andRaceImageURL:(NSString *)nImageURL andRaceZoomScale:(NSNumber *)nZoomScale andRaceType:(NSString *)nRaceType andRaceSeason:(NSString *)nRaceSeason andRaceDate:(NSDate *)nRaceDate andResultsImageURL1:(NSString *)nResultsImageURL1 andResultsImageURL2:(NSString *)nResultsImageURL2 andResultsImageURL3:(NSString *)nResultsImageURL3 andResultsImageURL4:(NSString *)nResultsImageURL4;

@end
