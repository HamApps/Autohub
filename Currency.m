//
//  Currency.m
//  Carhub
//
//  Created by Christoper Clark on 6/25/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "Currency.h"

@implementation Currency

@synthesize CurrencyName, CurrencyRate;

- (id)initWithCurrencyName:(NSString *)cName andCurrencyRate:(NSNumber *)cRate
{
    self = [super init];
    if (self)
    {
        CurrencyName = cName;
        CurrencyRate = cRate;
    }
    return self;
}

@end
