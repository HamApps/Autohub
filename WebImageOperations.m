//
//  WebImageOperations.m
//  Carhub
//
//  Created by Christopher Clark on 6/4/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "WebImageOperations.h"
#import <QuartzCore/QuartzCore.h>

@implementation WebImageOperations

+ (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("com.myapp.processsmagequeue", NULL);
    dispatch_async(downloadQueue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(callerQueue, ^{
            processImage(imageData);
        });
    });
}

@end
