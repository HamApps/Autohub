//
//  CustomPageControl.h
//  Carhub
//
//  Created by Christoper Clark on 1/5/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPageControl : UIPageControl
{
    UIImage* activeImage;
    UIImage* inactiveImage;
}
@property BOOL hasLoaded;

@end
