//
//  RaceSeason.h
//  Carhub
//
//  Created by Christoper Clark on 8/23/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RaceSeason : NSObject

@property (strong, nonatomic) NSString * SeasonName;
@property (strong, nonatomic) NSString * SeasonClass;

- (id)initWithSeasonName:(NSString *)nSeason andSeasonClass:(NSString *)nClass;

@end
