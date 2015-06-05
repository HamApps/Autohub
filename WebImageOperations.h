//
//  WebImageOperations.h
//  Carhub
//
//  Created by Christopher Clark on 6/4/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebImageOperations : NSObject
+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage;

@end
