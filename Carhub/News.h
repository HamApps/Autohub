//
//  News.h
//  Carhub
//
//  Created by Christopher Clark on 8/22/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (strong, nonatomic) NSString * NewsTitle;
@property (strong, nonatomic) NSString * NewsImageURL;
@property (strong, nonatomic) NSString * NewsVideoID;
@property (strong, nonatomic) NSString * NewsDescription;
@property (strong, nonatomic) NSString * NewsArticle;
@property (strong, nonatomic) NSString * NewsDate;
@property (strong, nonatomic) NSString * NewsAuthor;
@property (strong, nonatomic) NSString * NewsImageURL1;
@property (strong, nonatomic) NSString * NewsImage1Caption;
@property (strong, nonatomic) NSString * NewsImageURL2;
@property (strong, nonatomic) NSString * NewsImage2Caption;
@property (strong, nonatomic) NSString * NewsImageURL3;
@property (strong, nonatomic) NSString * NewsImage3Caption;
@property (strong, nonatomic) NSString * NewsImageURL4;
@property (strong, nonatomic) NSString * NewsImage4Caption;
@property (strong, nonatomic) NSString * NewsImageURL5;
@property (strong, nonatomic) NSString * NewsImage5Caption;


- (id)initWithNewsTitle:(NSString *)nTitle andNewsImageURL:(NSString *)nImageURL andNewsVideoID:(NSString *)nVideoID andNewsDescription:(NSString *)nDescription andNewsArticle:(NSString *)nArticle andNewsDate:(NSString *)nDate andNewsAuthor:(NSString *)nAuthor andNewsImageURL1:(NSString *)nImageURL1 andNewsImageURL2:(NSString *)nImageURL2 andNewsImageURL3:(NSString *)nImageURL3 andNewsImageURL4:(NSString *)nImageURL4 andNewsImageURL5:(NSString *)nImageURL5 andNewsImage1Caption:(NSString *) nImage1Caption andNewsImage2Caption:(NSString *) nImage2Caption andNewsImage3Caption:(NSString *) nImage3Caption andNewsImage4Caption:(NSString *) nImage4Caption andNewsImage5Caption:(NSString *) nImage5Caption;

@end

