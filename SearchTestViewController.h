//
//  SearchTestViewController.h
//  Carhub
//
//  Created by Christoper Clark on 11/24/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTestViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView * scroller;

@property (nonatomic, retain) UIView *pickerViewPopup;
@property (nonatomic, retain) UIPickerView *picker;
@property (nonatomic, retain) UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UIButton *btnOutlet;
@property (weak, nonatomic) IBOutlet UIButton *btnOutlet2;
@property (weak, nonatomic) IBOutlet UIButton *btnOutlet3;
@property (weak, nonatomic) IBOutlet UIButton *btnOutlet4;
@property (weak, nonatomic) IBOutlet UIButton *btnOutlet5;
@property (weak, nonatomic) IBOutlet UIButton *btnOutlet6;
@property (weak, nonatomic) IBOutlet UIButton *btnOutlet7;
@property (weak, nonatomic) IBOutlet UIButton *btnOutlet8;
@property (weak, nonatomic) IBOutlet UIButton *btnOutlet9;

@property (nonatomic, strong) NSArray * priceData;
@property (nonatomic, strong) NSArray * engineData;
@property (nonatomic, strong) NSArray * transmissionData;
@property (nonatomic, strong) NSArray * driveTypeData;
@property (nonatomic, strong) NSArray * horsepowerData;
@property (nonatomic, strong) NSArray * zeroToSixtyData;
@property (nonatomic, strong) NSArray * fuelEconomyData;
@property (nonatomic, strong) NSArray * currentSpecArray;

- (IBAction)btnAction:(id)sender;
- (IBAction)btnAction2:(id)sender;
- (IBAction)btnAction3:(id)sender;
- (IBAction)btnAction4:(id)sender;
- (IBAction)btnAction5:(id)sender;
- (IBAction)btnAction6:(id)sender;
- (IBAction)btnAction7:(id)sender;
- (IBAction)btnAction8:(id)sender;
- (IBAction)btnAction9:(id)sender;

@property (strong, nonatomic) NSPredicate *PricePredicate;
@property (strong, nonatomic) NSPredicate *EnginePredicate;
@property (strong, nonatomic) NSPredicate *TransmissionPredicate;
@property (strong, nonatomic) NSPredicate *DriveTypePredicate;
@property (strong, nonatomic) NSPredicate *HorsepowerPredicate;
@property (strong, nonatomic) NSPredicate *ZeroToSixtyPredicate;
@property (strong, nonatomic) NSPredicate *FEPredicate;
@property (strong, nonatomic) NSPredicate *MakePredicate;
@property (strong, nonatomic) NSPredicate *ModelPredicate;

@property (nonatomic, strong) NSMutableArray * initialModelArray;
@property (nonatomic, strong) NSMutableArray * makeArray;
@property (nonatomic, strong) NSMutableArray * ModelArray;
@property (nonatomic, strong) NSArray * finalModelArray;
@property (nonatomic, strong) NSArray * pricePredicateArray;
@property (nonatomic, strong) NSArray * enginePredicateArray;
@property (nonatomic, strong) NSArray * transmissionPredicateArray;
@property (nonatomic, strong) NSArray * driveTypePredicateArray;
@property (nonatomic, strong) NSArray * horsepowerPredicateArray;
@property (nonatomic, strong) NSArray * zeroToSixtyPredicateArray;
@property (nonatomic, strong) NSArray * fuelEconomyPredicateArray;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@end
