//
//  ImageViewController.m
//  Carhub
//
//  Created by Christopher Clark on 7/27/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{ return imageview;}

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

    scrollView.maximumZoomScale = 3.0; scrollView.minimumZoomScale = 0.6; scrollView.clipsToBounds = YES; scrollView.delegate = self; [scrollView addSubview:imageview];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *identifier = [[[NSString stringWithFormat:@"%@", _currentCar.CarMake]stringByAppendingString:@" "]stringByAppendingString:_currentCar.CarModel];
    NSData *imagedata = [defaults objectForKey:identifier];
    imageview.image = [UIImage imageWithData:imagedata];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getfirstModel:(id)firstcarObject;
{
    _currentCar = firstcarObject;
}
- (void)getsecondModel:(id)secondcarObject1;
{
    _currentCar = secondcarObject1;
}

/*
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    No Navigation on this page right now.
}
*/

@end
