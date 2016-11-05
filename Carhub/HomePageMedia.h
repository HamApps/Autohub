//
//  HomePageMedia.h
//  Carhub
//
//  Created by Christopher Clark on 10/17/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageMedia : NSObject

@property (strong, nonatomic) NSString * ImageURL;
@property (strong, nonatomic) NSNumber * ZoomScale;
@property (strong, nonatomic) NSNumber * ZoomScale2;
@property (strong, nonatomic) NSNumber * ZoomScale3;
@property (strong, nonatomic) NSNumber * ZoomScale4;
@property (strong, nonatomic) NSString * ImageURL2;
@property (strong, nonatomic) NSString * ImageURL3;
@property (strong, nonatomic) NSString * ImageURL4;
@property (strong, nonatomic) NSString * CarHTML;
@property (strong, nonatomic) NSString * FullCarModel;
@property (strong, nonatomic) NSString * Description;
@property (strong, nonatomic) NSString * RaceDate;
@property (strong, nonatomic) NSString * SpecType1;
@property (strong, nonatomic) NSString * SpecLabel1;
@property (strong, nonatomic) NSString * SpecType2;
@property (strong, nonatomic) NSString * SpecLabel2;
@property (strong, nonatomic) NSString * MediaType;

- (id)initWithImageURL:(NSString *)nImageURL andZoomScale: (NSNumber *)nZoomScale andZoomScale2: (NSNumber *)nZoomScale2 andZoomScale3: (NSNumber *)nZoomScale3 andZoomScale4: (NSNumber *)nZoomScale4 andImageURL2:(NSString *)nImageURL2 andImageURL3:(NSString *)nImageURL3 andImageURL4:(NSString *)nImageURL4 andCarHTML:(NSString *)nCarHTML andFullCarModel:(NSString *)nFullCarModel andDescription:(NSString *)nDescription andRaceDate:(NSString *)nRaceDate andSpecType1:(NSString *)nSpecType1 andSpecLabel1:(NSString *)nSpecLabel1 andSpecType2:(NSString *)nSpecType2 andSpecLabel2:(NSString *)nSpecLabel2 andMediaType:(NSString *)nMediaType;

@end
