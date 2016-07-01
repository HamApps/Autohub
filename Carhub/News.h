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
@property (strong, nonatomic) NSString * NewsArticleURL;
@property (strong, nonatomic) NSString * NewsImageURL1;
@property (strong, nonatomic) NSString * NewsImage1Position;
@property (strong, nonatomic) NSNumber * NewsImage1YPosition;
@property (strong, nonatomic) NSNumber * NewsImage1Width;
@property (strong, nonatomic) NSString * NewsImageURL2;
@property (strong, nonatomic) NSString * NewsImage2Position;
@property (strong, nonatomic) NSNumber * NewsImage2YPosition;
@property (strong, nonatomic) NSNumber * NewsImage2Width;
@property (strong, nonatomic) NSString * NewsImageURL3;
@property (strong, nonatomic) NSString * NewsImage3Position;
@property (strong, nonatomic) NSNumber * NewsImage3YPosition;
@property (strong, nonatomic) NSNumber * NewsImage3Width;
@property (strong, nonatomic) NSString * NewsImageURL4;
@property (strong, nonatomic) NSString * NewsImage4Position;
@property (strong, nonatomic) NSNumber * NewsImage4YPosition;
@property (strong, nonatomic) NSNumber * NewsImage4Width;
@property (strong, nonatomic) NSString * NewsImageURL5;
@property (strong, nonatomic) NSString * NewsImage5Position;
@property (strong, nonatomic) NSNumber * NewsImage5YPosition;
@property (strong, nonatomic) NSNumber * NewsImage5Width;


- (id)initWithNewsTitle:(NSString *)nTitle andNewsImageURL:(NSString *)nImageURL andNewsVideoID:(NSString *)nVideoID andNewsDescription:(NSString *)nDescription andNewsArticle:(NSString *)nArticle andNewsDate:(NSString *)nDate andNewsAuthor:(NSString *)nAuthor andNewsArticleURL:(NSString *) nArticleURL andNewsImageURL1:(NSString *)nImageURL1 andNewsImage1Position:(NSString *)nImage1Position andNewsImage1YPosition:(NSNumber *)nImage1YPosition andNewsImage1Width:(NSNumber *)nImage1Width andNewsImageURL2:(NSString *)nImageURL2 andNewsImage2Position:(NSString *)nImage2Position andNewsImage2YPosition:(NSNumber *)nImage2YPosition andNewsImage2Width:(NSNumber *)nImage2Width andNewsImageURL3:(NSString *)nImageURL3 andNewsImage3Position:(NSString *)nImage3Position andNewsImage3YPosition:(NSNumber *)nImage3YPosition andNewsImage3Width:(NSNumber *)nImage3Width andNewsImageURL4:(NSString *)nImageURL4 andNewsImage4Position:(NSString *)nImage4Position andNewsImage4YPosition:(NSNumber *)nImage4YPosition andNewsImage4Width:(NSNumber *)nImage4Width andNewsImageURL5:(NSString *)nImageURL5 andNewsImage5Position:(NSString *)nImage5Position andNewsImage5YPosition:(NSNumber *)nImage5YPosition andNewsImage5Width:(NSNumber *)nImage5Width;

@end

