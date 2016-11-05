//
//  RaceSeason.m
//  Carhub
//
//  Created by Christoper Clark on 8/23/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "RaceSeason.h"

@implementation RaceSeason
@synthesize SeasonName, SeasonClass;

-(id)initWithSeasonName:(NSString *)nSeason andSeasonClass:(NSString *)nClass
{
    self = [super init];
    if (self)
    {
        SeasonName = nSeason;
        SeasonClass = nClass;
    }
    return self;
}

@end
