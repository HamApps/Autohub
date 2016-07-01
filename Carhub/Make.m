//
//  Make.m
//  Carhub
//
//  Created by Christopher Clark on 7/19/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "Make.h"

@implementation Make
@synthesize MakeName, MakeImageURL, MakeCountry;

- (id)initWithMakeName:(NSString *)mName andMakeImageURL:(NSString *)mImageURL andMakeCountry:(NSString *)mCountry
{
    self = [super init];
    if (self)
    {
        MakeName = mName;
        MakeImageURL = mImageURL;
        MakeCountry = mCountry;
    }
    return self;
}

@end

