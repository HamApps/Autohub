//
//  PostViewController.h
//  Carhub
//
//  Created by Christopher Clark on 9/12/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPostURL @"http://pl0x.net/PostDatasheet.php"
#define kUpCount @"upCount"
#define kDownCount @"downCount"
#define kPostImageURL @"postImage"
#define kTitle @"postTitle"
#define kDescription @"postDescription"

@interface PostViewController : UIViewController{
    IBOutlet UITextField *titleTextField;
    IBOutlet UITextView *descriptionTextView;
    NSURLConnection *postConnection;
}
- (IBAction)postToDatabase:(id)sender;

@end
