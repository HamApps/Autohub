//
//  RaceType.h
//  Carhub
//
//  Created by Christopher Clark on 9/21/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RaceType : NSObject

@property (strong, nonatomic) NSString * RaceTypeString;
@property (strong, nonatomic) NSString * TypeImageURL;


- (id)initWithRaceType:(NSString *)nType andTypeImageURL:(NSString *)nImageURL;

@end
