//
//  FavoritesClass.m
//  Carhub
//
//  Created by Christopher Clark on 8/24/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "FavoritesClass.h"

@implementation FavoritesClass
{
    
}

@synthesize  favoritearray;

+(FavoritesClass *)favoritecars
{
    static FavoritesClass * single=nil;
    
    @synchronized(self)
    {
        if(!single)
        {
            single = [[FavoritesClass alloc]init];
        }
    }
    return single;
}

@end
