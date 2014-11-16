//
//  ImageViewController.h
//  Carhub
//
//  Created by Christopher Clark on 7/27/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface ImageViewController : UIViewController<UIScrollViewDelegate>{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView* imageview;
}
@property(nonatomic, strong) Model * firstCar4;

- (void)getfirstModel:(id)firstcarObject;

@end
