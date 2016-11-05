//
//  Race.m
//  Carhub
//
//  Created by Christopher Clark on 10/9/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import "Race.h"

@implementation Race
@synthesize RaceImageURL, RaceName, RaceType, ResultsImageURL1, ResultsImageURL2, ResultsImageURL3, ResultsImageURL4, RaceSeason, RaceDate, RaceZoomScale, SeasonRaceName;

-(id)initWithRaceName:(NSString *)nName andSeasonRaceName:(NSString *)nSeasonRaceName andRaceImageURL:(NSString *)nImageURL andRaceZoomScale:(NSNumber *)nZoomScale andRaceType:(NSString *)nRaceType andRaceSeason:(NSString *)nRaceSeason andRaceDate:(NSDate *)nRaceDate andResultsImageURL1:(NSString *)nResultsImageURL1 andResultsImageURL2:(NSString *)nResultsImageURL2 andResultsImageURL3:(NSString *)nResultsImageURL3 andResultsImageURL4:(NSString *)nResultsImageURL4
{
    self = [super init];
    if (self)
    {
        RaceName = nName;
        SeasonRaceName = nSeasonRaceName;
        RaceImageURL = nImageURL;
        RaceZoomScale = nZoomScale;
        RaceType = nRaceType;
        RaceSeason = nRaceSeason;
        RaceDate = nRaceDate;
        ResultsImageURL1 =nResultsImageURL1;
        ResultsImageURL2 =nResultsImageURL2;
        ResultsImageURL3 =nResultsImageURL3;
        ResultsImageURL4 =nResultsImageURL4;
    }
    return self;
}
@end
