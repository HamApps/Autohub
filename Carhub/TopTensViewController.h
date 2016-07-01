//
//  TopTensViewController.h
//  Carhub
//
//  Created by Ethan Esval on 7/23/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface TopTensViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton * zeroToSixtyButton;
@property (strong, nonatomic) IBOutlet UIButton * topSpeedButton;
@property (strong, nonatomic) IBOutlet UIButton * nurburgringButton;
@property (strong, nonatomic) IBOutlet UIButton * nExpensiveButton;
@property (strong, nonatomic) IBOutlet UIButton * auctionExpensiveButton;
@property (strong, nonatomic) IBOutlet UIButton * fuelEconomyButton;
@property (strong, nonatomic) IBOutlet UIButton * horsepowerButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@end

