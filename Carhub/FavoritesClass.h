//
//  FavoritesClass.h
//  Carhub
//
//  Created by Christopher Clark on 8/24/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoritesClass : NSObject{
    NSMutableArray *favoritearray;
}
@property (nonatomic, retain)NSMutableArray *favoritearray;

+(FavoritesClass *) favoritecars;

@end
