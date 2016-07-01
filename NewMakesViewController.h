//
//  NewMakesViewController.h
//  Carhub
//
//  Created by Christoper Clark on 1/23/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "Make.h"
#import "Model.h"
#import "DetailViewController.h"
#import "CarViewCell.h"

@interface NewMakesViewController : UIViewController<iCarouselDataSource, iCarouselDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *upperView;
@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) IBOutlet UIImageView *circleScroller;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButton;

@property (nonatomic, strong) NSMutableArray * makeimageArray;

@property (nonatomic, strong) NSMutableArray * appdelmodelArray;
@property (nonatomic, strong) NSMutableArray * ModelArray;
@property (nonatomic, strong) NSArray * searchArray;
@property (nonatomic, strong) NSArray * AlphabeticalArray;
@property (nonatomic, strong) Make * currentMake;
@property (nonatomic, strong) Model *pushingObject;
@property (nonatomic, strong) NSString * currentClass;
@property (nonatomic, strong) NSString * currentSubclass;

@property (nonatomic, strong) DetailViewController *detailView;
@property (nonatomic, strong) CarViewCell *detailCell;
@property (nonatomic, strong) CarViewCell *cellToSlide;

@property (nonatomic, strong) UIImageView *detailImageView;

@property CGRect initialCellFrame;
@property CGRect initialCellFrame2;

-(void)revertToMakesPage;

@end
