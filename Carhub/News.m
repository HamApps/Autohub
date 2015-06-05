//
//  News.m
//  Carhub
//
//  Created by Christopher Clark on 8/22/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "News.h"

@implementation News
@synthesize NewsImageURL, NewsTitle, NewsDescription, NewsArticle, NewsDate, NewsArticleURL;

- (id)initWithNewsTitle:(NSString *)nTitle andNewsImageURL:(NSString *)nImageURL andNewsDescription:(NSString *)nDescription andNewsArticle:(NSString *)nArticle andNewsDate:(NSString *)nDate andNewsArticleURL:(NSString *)nArticleURL;
{
    self = [super init];
    if (self)
    {
        NewsTitle = nTitle;
        NewsImageURL = nImageURL;
        NewsDescription = nDescription;
        NewsArticle = nArticle;
        NewsDate = nDate;
        NewsArticleURL = nArticleURL;
    }
    
    return self;
}

@end
