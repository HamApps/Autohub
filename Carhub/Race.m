//
//  Race.m
//  Carhub
//
//  Created by Christopher Clark on 10/9/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import "Race.h"

@implementation Race
@synthesize RaceImageURL, RaceName, RaceType, ResultsImageURL1, ResultsImageURL2, ResultsImageURL3, ResultsImageURL4;

-(id)initWithRaceName:(NSString *)nName andTypeImageURL:(NSString *)nImageURL andRaceType:(NSString *)nRaceType andResultsImageURL1:(NSString *)nResultsImageURL1 andResultsImageURL2:(NSString *)nResultsImageURL2 andResultsImageURL3:(NSString *)nResultsImageURL3 andResultsImageURL4:(NSString *)nResultsImageURL4
{
    self = [super init];
    if (self)
    {
        RaceName = nName;
        RaceImageURL = nImageURL;
        RaceType = nRaceType;
        ResultsImageURL1 =nResultsImageURL1;
        ResultsImageURL2 =nResultsImageURL2;
        ResultsImageURL3 =nResultsImageURL3;
        ResultsImageURL4 =nResultsImageURL4;
    }
    return self;
}
@end
