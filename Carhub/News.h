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
@property (strong, nonatomic) NSString * NewsDescription;
@property (strong, nonatomic) NSString * NewsArticle;


- (id)initWithNewsTitle:(NSString *)nTitle andNewsImageURL:(NSString *)nImageURL andNewsDescription:(NSString *)nDescription andNewsArticle:(NSString *)nArticle;

@end
