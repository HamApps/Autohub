//
//  PostViewController.m
//  Carhub
//
//  Created by Christopher Clark on 9/12/15.
//  Copyright (c) 2015 Ham Applications. All rights reserved.
//

#import "PostViewController.h"

@interface PostViewController ()

@end

@implementation PostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) inputPost:(NSString *) title withDescription:(NSString *) description
{
    if (title !=nil && description != nil)
    {
        NSMutableString *postString = [NSMutableString stringWithString:kPostURL];
        
        [postString appendString:[NSString stringWithFormat:@"?%@=%d", kUpCount, 0]];
        [postString appendString:[NSString stringWithFormat:@"&%@=%d", kDownCount, 0]];
        [postString appendString:[NSString stringWithFormat:@"&%@=%@", kPostImageURL, @""]];
        [postString appendString:[NSString stringWithFormat:@"&%@=%@", kDescription, description]];
        [postString appendString:[NSString stringWithFormat:@"&%@=%@", kTitle, title]];
        
        [postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:postString]];
        [request setHTTPMethod:@"POST"];
        
        postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        
        
    }
}

-(IBAction)postToDatabase:(id)sender
{
    [self inputPost:titleTextField.text withDescription:descriptionTextView.text];
    [descriptionTextView resignFirstResponder];
    titleTextField.text = nil;
    descriptionTextView.text = nil;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end