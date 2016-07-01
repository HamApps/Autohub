//
//  SearchViewController.h
//  Carhub
//
//  Created by Christopher Clark on 8/22/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface SearchViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnOutlet;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnOutlet2;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet UIButton *btnOutlet3;
@property (weak, nonatomic) IBOutlet UITableView *tableView3;
@property (weak, nonatomic) IBOutlet UIButton *btnOutlet4;
@property (weak, nonatomic) IBOutlet UITableView *tableView4;
@property (weak, nonatomic) IBOutlet UIButton *btnOutlet5;
@property (weak, nonatomic) IBOutlet UITableView *tableView5;
@property (weak, nonatomic) IBOutlet UIButton *btnOutlet6;
@property (weak, nonatomic) IBOutlet UITableView *tableView6;
@property (weak, nonatomic) IBOutlet UIButton *btnOutlet7;
@property (weak, nonatomic) IBOutlet UITableView *tableView7;

@property (nonatomic, strong) NSArray * priceData;
@property (nonatomic, strong) NSArray * engineData;
@property (nonatomic, strong) NSArray * transmissionData;
@property (nonatomic, strong) NSArray * driveTypeData;
@property (nonatomic, strong) NSArray * horsepowerData;
@property (nonatomic, strong) NSArray * zeroToSixtyData;
@property (nonatomic, strong) NSArray * fuelEconomyData;
@property (nonatomic, strong) NSArray * tableViewArray;

- (IBAction)btnAction:(id)sender;
- (IBAction)btnAction2:(id)sender;
- (IBAction)btnAction3:(id)sender;
- (IBAction)btnAction4:(id)sender;
- (IBAction)btnAction5:(id)sender;
- (IBAction)btnAction6:(id)sender;
- (IBAction)btnAction7:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView * scroller;

@property (nonatomic, strong) NSMutableArray * specsArray;
@property (nonatomic, strong) NSMutableArray * carArray;
@property (nonatomic, strong) NSMutableArray * finalArray;
@property (nonatomic, strong) NSArray * testArray;

@property (nonatomic, strong) NSMutableArray * ModelArray;

@property (nonatomic, retain) NSArray * PriceArray1;
@property (nonatomic, retain) NSArray * EngineArray1;
@property (nonatomic, retain) NSArray * EngineDisArray1;
@property (nonatomic, retain) NSArray * TransmissionArray1;
@property (nonatomic, retain) NSArray * DriveTypeArray1;
@property (nonatomic, retain) NSArray * HorsepowerArray1;
@property (nonatomic, retain) NSArray * ZerotoSixtyArray1;
@property (nonatomic, retain) NSArray * FuelEconomyArray1;

@property (nonatomic, retain) NSArray * finalModelArray;

@property (nonatomic, strong) NSString *cModel;

- (IBAction) UseModelPredicates;

@property (weak, nonatomic) IBOutlet UIPickerView *Pricepicker;
@property (weak, nonatomic) IBOutlet UIPickerView *enginePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *transmissionPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *driveTypePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *horsepowerPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *zeroToSixtyPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *FuelEconomyPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *MakePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *ModelPicker;

@property (strong, nonatomic) NSPredicate *PricePredicate;
@property (strong, nonatomic) NSPredicate *EnginePredicate;
@property (strong, nonatomic) NSPredicate *TransmissionPredicate;
@property (strong, nonatomic) NSPredicate *DriveTypePredicate;
@property (strong, nonatomic) NSPredicate *HorsepowerPredicate;
@property (strong, nonatomic) NSPredicate *ZeroToSixtyPredicate;
@property (strong, nonatomic) NSPredicate *FEPredicate;
@property (strong, nonatomic) NSPredicate *MakePredicate;
@property (strong, nonatomic) NSPredicate *ModelPredicate;

@property (nonatomic, strong) NSMutableArray * makeimageArray;
@property (nonatomic, strong) NSArray * AlphabeticalArray;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

- (void) setModels;
- (void) UsePredicates;

@end
