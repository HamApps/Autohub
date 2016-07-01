//
//  DisputeInfoViewController.h
//  Carhub
//
//  Created by Christopher Clark on 7/26/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface DisputeInfoViewController : UIViewController<MFMailComposeViewControllerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *myTextView;
- (IBAction)emailButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@property (strong, nonatomic) IBOutlet UIButton *instagramButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;

@end
