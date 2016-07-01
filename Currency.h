//
//  Currency.h
//  Carhub
//
//  Created by Christoper Clark on 6/25/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Currency : NSObject

@property (strong, nonatomic) NSString * CurrencyName;
@property (strong, nonatomic) NSNumber * CurrencyRate;

- (id)initWithCurrencyName: (NSString *)cName andCurrencyRate: (NSNumber *)cRate;

@end
