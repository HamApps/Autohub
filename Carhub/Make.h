//
//  Make.h
//  Carhub
//
//  Created by Christopher Clark on 7/19/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Make : NSObject

@property (strong, nonatomic) NSString * MakeName;
@property (strong, nonatomic) NSString * MakeImageURL;
@property (strong, nonatomic) NSString * MakeCountry;
@property (strong, nonatomic) NSNumber * ZoomScale;

#pragma mark -
#pragma mark Class Methods

- (id)initWithMakeName: (NSString *)mName andMakeImageURL: (NSString *)mImageURL andMakeCountry: (NSString *)mCountry andZoomScale: (NSNumber *)mZoomScale;

@end
