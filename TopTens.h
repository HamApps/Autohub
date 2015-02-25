//
//  TopTens.h
//  Carhub
//
//  Created by Christopher Clark on 2/15/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopTens : NSObject

@property (strong, nonatomic) NSString * CarRank;
@property (strong, nonatomic) NSString * CarName;
@property (strong, nonatomic) NSString * CarValue;
@property (strong, nonatomic) NSString * CarURL;
@property (strong, nonatomic) NSString * TopTenType;

- (id)initWithCarRank:(NSString *)nRank andCarName:(NSString *)nName andCarValue:(NSString *)nValue andCarURL:(NSString *)nURL andTopTenType:(NSString *)nType;

@end
