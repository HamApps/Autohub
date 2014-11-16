//
//  Make.m
//  Carhub
//
//  Created by Christopher Clark on 7/19/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "Make.h"

@implementation Make
@synthesize MakeName, MakeImageURL;

- (id)initWithMakeName:(NSString *)mName andMakeImageURL:(NSString *)mImageURL
{
    self = [super init];
    if (self)
    {
        MakeName = mName;
        MakeImageURL = mImageURL;
    }
    
    return self;
}

@end

