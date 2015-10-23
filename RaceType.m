//
//  RaceType.m
//  Carhub
//
//  Created by Christopher Clark on 9/21/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "RaceType.h"

@implementation RaceType
@synthesize RaceTypeString, TypeImageURL;

-(id)initWithRaceType:(NSString *)nType andTypeImageURL:(NSString *)nImageURL
{
    self = [super init];
    if (self)
    {
        RaceTypeString = nType;
        TypeImageURL = nImageURL;
    }
    return self;
}

@end
