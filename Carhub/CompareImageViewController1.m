//
//  CompareImageViewController1.m
//  Carhub
//
//  Created by Christopher Clark on 7/27/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "CompareImageViewController1.h"

@interface CompareImageViewController1 ()

@end

@implementation CompareImageViewController1

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

    imageview.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString:_firstCar4.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]]];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getfirstModel:(id)firstcarObject1;
{
    _firstCar4 = firstcarObject1;
}
- (void)getsecondModel:(id)secondcarObject1;
{
    _firstCar4 = secondcarObject1;
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

@end
