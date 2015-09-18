//
//  Post.m
//  Carhub
//
//  Created by Christopher Clark on 9/12/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "Post.h"

@implementation Post
@synthesize upCount, downCount, postDescription, postImageURL, postTitle;

- (id)initWithupCount:(NSNumber *)uCount anddownCount:(NSNumber *)dCount andpostImageURL:(NSString *)pImageURL andpostDescription:(NSString *)pDescription andpostTitle:(NSString *)pTitle;
{
self = [super init];
if (self)
{
    upCount = uCount;
    downCount = dCount;
    postImageURL = pImageURL;
    postDescription = pDescription;
    postTitle = pTitle;
}

return self;
}


@end
