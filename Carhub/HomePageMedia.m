//
//  HomePageMedia.m
//  Carhub
//
//  Created by Christopher Clark on 10/17/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import "HomePageMedia.h"

@implementation HomePageMedia
@synthesize ImageURL, ImageURL2, ImageURL3, ImageURL4, Description, SpecLabel1, SpecLabel2, MediaType, SpecType1, SpecType2, CarHTML;

- (id)initWithImageURL:(NSString *)nImageURL andImageURL2:(NSString *)nImageURL2 andImageURL3:(NSString *)nImageURL3 andImageURL4:(NSString *)nImageURL4 andCarHTML:(NSString *)nCarHTML andDescription:(NSString *)nDescription andSpecType1:(NSString *)nSpecType1 andSpecLabel1:(NSString *)nSpecLabel1 andSpecType2:(NSString *)nSpecType2 andSpecLabel2:(NSString *)nSpecLabel2 andMediaType:(NSString *)nMediaType
{
    self = [super init];
    if (self)
    {
        ImageURL = nImageURL;
        ImageURL2 = nImageURL2;
        ImageURL3 = nImageURL3;
        ImageURL4 = nImageURL4;
        CarHTML = nCarHTML;
        Description = nDescription;
        SpecType1 = nSpecType1;
        SpecLabel1 = nSpecLabel1;
        SpecType2 = nSpecType2;
        SpecLabel2 = nSpecLabel2;
        MediaType = nMediaType;
    }
    return self;
}

@end
