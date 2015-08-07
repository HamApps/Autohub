//
//  DisputeInfoViewController.m
//  Carhub
//
//  Created by Christopher Clark on 7/26/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "DisputeInfoViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"

@interface DisputeInfoViewController ()

@end

@implementation DisputeInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
    
    self.barButton.target = self.revealViewController;
    self.barButton.action = @selector(revealToggle:);
    
    self.title = @"Info Dispute";
    // Do any additional setup after loading the view.
    [self.myTextView setReturnKeyType:UIReturnKeyDone];
    self.myTextView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)emailButton:(id)sender {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
    [mailController setMailComposeDelegate:self];
    NSString *email = @"hamapplications@gmail.com";
    NSArray *emailArray = [[NSArray alloc]initWithObjects:email, nil];
    NSString *message = [[self myTextView]text];
    [mailController setMessageBody:message isHTML:NO];
    [mailController setToRecipients:emailArray];
    [mailController setSubject:@"SPECS DISPUTE"];
    [self presentViewController:mailController animated:YES completion:nil];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self myTextView]resignFirstResponder];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
