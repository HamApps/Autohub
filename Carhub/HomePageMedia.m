//
//  HomePageMedia.m
//  Carhub
//
//  Created by Christopher Clark on 10/17/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import "HomePageMedia.h"

@implementation HomePageMedia
@synthesize ImageURL, ImageURL2, ImageURL3, ImageURL4, Description, SpecLabel1, SpecLabel2, MediaType, SpecType1, SpecType2, CarHTML, ZoomScale, RaceDate, ZoomScale2, ZoomScale3, ZoomScale4, FullCarModel;

- (id)initWithImageURL:(NSString *)nImageURL andZoomScale:(NSNumber *)nZoomScale andZoomScale2:(NSNumber *)nZoomScale2 andZoomScale3:(NSNumber *)nZoomScale3 andZoomScale4:(NSNumber *)nZoomScale4 andImageURL2:(NSString *)nImageURL2 andImageURL3:(NSString *)nImageURL3 andImageURL4:(NSString *)nImageURL4 andCarHTML:(NSString *)nCarHTML andFullCarModel:(NSString *)nFullCarModel andDescription:(NSString *)nDescription andRaceDate:(NSString *)nRaceDate andSpecType1:(NSString *)nSpecType1 andSpecLabel1:(NSString *)nSpecLabel1 andSpecType2:(NSString *)nSpecType2 andSpecLabel2:(NSString *)nSpecLabel2 andMediaType:(NSString *)nMediaType
{
    self = [super init];
    if (self)
    {
        ImageURL = nImageURL;
        ZoomScale = nZoomScale;
        ZoomScale2 = nZoomScale2;
        ZoomScale3 = nZoomScale3;
        ZoomScale4 = nZoomScale4;
        ImageURL2 = nImageURL2;
        ImageURL3 = nImageURL3;
        ImageURL4 = nImageURL4;
        CarHTML = nCarHTML;
        FullCarModel = nFullCarModel;
        Description = nDescription;
        RaceDate = nRaceDate;
        SpecType1 = nSpecType1;
        SpecLabel1 = nSpecLabel1;
        SpecType2 = nSpecType2;
        SpecLabel2 = nSpecLabel2;
        MediaType = nMediaType;
    }
    return self;
}

@end
