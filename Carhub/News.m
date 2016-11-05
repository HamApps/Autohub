//
//  News.m
//  Carhub
//
//  Created by Christopher Clark on 8/22/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "News.h"

@implementation News
@synthesize NewsImageURL, NewsTitle, NewsDescription, NewsArticle, NewsDate, NewsAuthor, NewsVideoID, NewsImageURL1, NewsImageURL2, NewsImageURL3, NewsImageURL4, NewsImageURL5, NewsImage1Caption, NewsImage2Caption, NewsImage3Caption, NewsImage4Caption, NewsImage5Caption;

- (id)initWithNewsTitle:(NSString *)nTitle andNewsImageURL:(NSString *)nImageURL andNewsVideoID:(NSString *)nVideoID andNewsDescription:(NSString *)nDescription andNewsArticle:(NSString *)nArticle andNewsDate:(NSString *)nDate andNewsAuthor:(NSString *)nAuthor andNewsImageURL1:(NSString *)nImageURL1 andNewsImageURL2:(NSString *)nImageURL2 andNewsImageURL3:(NSString *)nImageURL3 andNewsImageURL4:(NSString *)nImageURL4 andNewsImageURL5:(NSString *)nImageURL5 andNewsImage1Caption:(NSString *)nImage1Caption andNewsImage2Caption:(NSString *)nImage2Caption andNewsImage3Caption:(NSString *)nImage3Caption andNewsImage4Caption:(NSString *)nImage4Caption andNewsImage5Caption:(NSString *)nImage5Caption
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
        NewsImageURL1 = nImageURL1;
        NewsImageURL2 = nImageURL2;
        NewsImageURL3 = nImageURL3;
        NewsImageURL4 = nImageURL4;
        NewsImageURL5 = nImageURL5;
        NewsImage1Caption = nImage1Caption;
        NewsImage2Caption = nImage2Caption;
        NewsImage3Caption = nImage3Caption;
        NewsImage4Caption = nImage4Caption;
        NewsImage5Caption = nImage5Caption;
    }
    return self;
}
@end
