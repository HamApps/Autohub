//
//  DetailViewController.h
//  Carhub
//
//  Created by Christopher Clark on 7/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface DetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *exhaustButton;
    IBOutlet UIImageView *imageview;
    IBOutlet UIScrollView * scroller;
    IBOutlet UITableView * SpecsTableView;
}

@property(nonatomic, strong) IBOutlet UILabel * CarYearsMadeLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarPriceLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarEngineLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarTransmissionLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarDriveTypeLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarHorsepowerLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarZeroToSixtyLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarTopSpeedLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarWeightLabel;
@property(nonatomic, strong) IBOutlet UILabel * CarFuelEconomyLabel;

@property (nonatomic) bool isPlaying;
@property (nonatomic, strong) NSMutableArray * savedArray;

@property(nonatomic, strong) Model * currentCar;

#pragma mark -
#pragma mark Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (bool)isSaved:(Model *)currentModel;
- (void)checkStar;
- (void)getModel:(id)modelObject;
- (void)setLabels;
-(IBAction)Website;

@end
