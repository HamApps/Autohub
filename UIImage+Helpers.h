//
//  UIImage+Helpers.h
//  Carhub
//
//  Created by Christopher Clark on 6/4/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Helpers)

+ (void) loadFromURL: (NSURL*) url callback:(void (^)(UIImage *image))callback;

@end