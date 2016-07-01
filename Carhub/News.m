//
//  News.m
//  Carhub
//
//  Created by Christopher Clark on 8/22/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "News.h"

@implementation News
@synthesize NewsImageURL, NewsTitle, NewsDescription, NewsArticle, NewsDate, NewsAuthor, NewsArticleURL, NewsVideoID, NewsImageURL1, NewsImage1Width, NewsImage1Position, NewsImage1YPosition, NewsImageURL2, NewsImageURL3, NewsImageURL4, NewsImageURL5, NewsImage2Width, NewsImage3Width, NewsImage4Width, NewsImage5Width, NewsImage2Position, NewsImage3Position, NewsImage4Position, NewsImage5Position, NewsImage2YPosition, NewsImage3YPosition, NewsImage4YPosition, NewsImage5YPosition;

- (id)initWithNewsTitle:(NSString *)nTitle andNewsImageURL:(NSString *)nImageURL andNewsVideoID:(NSString *)nVideoID andNewsDescription:(NSString *)nDescription andNewsArticle:(NSString *)nArticle andNewsDate:(NSString *)nDate andNewsAuthor:(NSString *)nAuthor andNewsArticleURL:(NSString *)nArticleURL andNewsImageURL1:(NSString *)nImageURL1 andNewsImage1Position:(NSString *)nImage1Position andNewsImage1YPosition:(NSNumber *)nImage1YPosition andNewsImage1Width:(NSNumber *)nImage1Width andNewsImageURL2:(NSString *)nImageURL2 andNewsImage2Position:(NSString *)nImage2Position andNewsImage2YPosition:(NSNumber *)nImage2YPosition andNewsImage2Width:(NSNumber *)nImage2Width andNewsImageURL3:(NSString *)nImageURL3 andNewsImage3Position:(NSString *)nImage3Position andNewsImage3YPosition:(NSNumber *)nImage3YPosition andNewsImage3Width:(NSNumber *)nImage3Width andNewsImageURL4:(NSString *)nImageURL4 andNewsImage4Position:(NSString *)nImage4Position andNewsImage4YPosition:(NSNumber *)nImage4YPosition andNewsImage4Width:(NSNumber *)nImage4Width andNewsImageURL5:(NSString *)nImageURL5 andNewsImage5Position:(NSString *)nImage5Position andNewsImage5YPosition:(NSNumber *)nImage5YPosition andNewsImage5Width:(NSNumber *)nImage5Width
{
    self = [super init];
    if (self)
    {
        NewsTitle = nTitle;
        NewsImageURL = nImageURL;
        NewsVideoID = nVideoID;
        NewsDescription = nDescription;
        NewsArticle = nArticle;
        NewsDate = nDate;
        NewsAuthor = nAuthor;
        NewsArticleURL = nArticleURL;
        NewsImageURL1 = nImageURL1;
        NewsImage1Position = nImage1Position;
        NewsImage1YPosition = nImage1YPosition;
        NewsImage1Width = nImage1Width;
        NewsImageURL2 = nImageURL2;
        NewsImage2Position = nImage2Position;
        NewsImage2YPosition = nImage2YPosition;
        NewsImage2Width = nImage2Width;
        NewsImageURL3 = nImageURL3;
        NewsImage3Position = nImage3Position;
        NewsImage3YPosition = nImage3YPosition;
        NewsImage3Width = nImage3Width;
        NewsImageURL4 = nImageURL4;
        NewsImage4Position = nImage4Position;
        NewsImage4YPosition = nImage4YPosition;
        NewsImage4Width = nImage4Width;
        NewsImageURL5 = nImageURL5;
        NewsImage5Position = nImage5Position;
        NewsImage5YPosition = nImage5YPosition;
        NewsImage5Width = nImage5Width;
    }
    return self;
}
@end
