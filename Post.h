//
//  Post.h
//  Carhub
//
//  Created by Christopher Clark on 9/12/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (strong, nonatomic) NSNumber * upCount;
@property (strong, nonatomic) NSNumber * downCount;
@property (strong, nonatomic) NSString * postImageURL;
@property (strong, nonatomic) NSString * postDescription;
@property (strong, nonatomic) NSString * postTitle;

- (id)initWithupCount:(NSNumber *)uCount anddownCount:(NSNumber *)dCount andpostImageURL:(NSString *)pImageURL andpostDescription:(NSString *)pDescription andpostTitle:(NSString *)pTitle;

@end
