//
//  TopTens.m
//  Carhub
//
//  Created by Christopher Clark on 2/15/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "TopTens.h"

@implementation TopTens
@synthesize CarName,CarRank,CarValue, CarURL, TopTenType;

- (id)initWithCarRank:(NSString *)nRank andCarName:(NSString *)nName andCarValue:(NSString *)nValue andCarURL:(NSString *)nURL andTopTenType:(NSString *)nType;
{
    self = [super init];
    if (self)
    {
        CarRank=nRank;
        CarName = nName;
        CarValue = nValue;
        CarURL = nURL;
        TopTenType = nType;
    }
    return self;
}

@end
