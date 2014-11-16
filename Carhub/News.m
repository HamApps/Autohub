//
//  News.m
//  Carhub
//
//  Created by Christopher Clark on 8/22/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "News.h"

@implementation News
@synthesize NewsImageURL, NewsTitle, NewsDescription, NewsArticle;

- (id)initWithNewsTitle:(NSString *)nTitle andNewsImageURL:(NSString *)nImageURL andNewsDescription:(NSString *)nDescription andNewsArticle:(NSString *)nArticle;
{
    self = [super init];
    if (self)
    {
        NewsTitle = nTitle;
        NewsImageURL = nImageURL;
        NewsDescription = nDescription;
        NewsArticle = nArticle;
    }
    
    return self;
}

@end
