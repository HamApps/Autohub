//
//  SearchViewController.h
//  Carhub
//
//  Created by Christopher Clark on 8/22/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface SearchViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
    IBOutlet UIScrollView * scroller;
    NSArray *PriceData;
}


@property (nonatomic, strong) NSMutableArray * jsonArray;
@property (nonatomic, strong) NSMutableArray * carArray;
@property (nonatomic, strong) NSMutableArray * finalArray;
@property (nonatomic, strong) NSArray * testArray;

@property (nonatomic, strong) NSMutableArray * ModelArray;
@property (nonatomic, strong) NSMutableArray * appdelmodeljsonArray;

@property (nonatomic, retain) NSArray * PriceArray1;
@property (nonatomic, retain) NSArray * EngineArray1;
@property (nonatomic, retain) NSArray * EngineDisArray1;
@property (nonatomic, retain) NSArray * TransmissionArray1;
@property (nonatomic, retain) NSArray * DriveTypeArray1;
@property (nonatomic, retain) NSArray * HorsepowerArray1;
@property (nonatomic, retain) NSArray * ZerotoSixtyArray1;

@property (nonatomic, retain) NSArray * finalModelArray;

@property (nonatomic, strong) NSString *cModel;

//- (IBAction):UsePredicates;
- (IBAction) UseModelPredicates;

@property (weak, nonatomic) IBOutlet UIPickerView *Pricepicker;
@property (weak, nonatomic) IBOutlet UIPickerView *enginePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *enginedisPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *transmissionPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *driveTypePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *horsepowerPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *zeroToSixtyPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *MakePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *ModelPicker;

@property (strong, nonatomic) NSPredicate *PricePredicate;
@property (strong, nonatomic) NSPredicate *EnginePredicate;
@property (strong, nonatomic) NSPredicate *TransmissionPredicate;
@property (strong, nonatomic) NSPredicate *DriveTypePredicate;
@property (strong, nonatomic) NSPredicate *HorsepowerPredicate;
@property (strong, nonatomic) NSPredicate *ZeroToSixtyPredicate;
@property (strong, nonatomic) NSPredicate *MakePredicate;
@property (strong, nonatomic) NSPredicate *ModelPredicate;


@property (nonatomic, strong) IBOutlet UILabel * OutputLabel;
@property (retain, nonatomic) NSArray *PriceData;
@property (retain, nonatomic) NSArray *EngineData;
@property (retain, nonatomic) NSArray *EngineDisData;
@property (retain, nonatomic) NSArray *TransmissionData;
@property (retain, nonatomic) NSArray *DriveTypeData;
@property (retain, nonatomic) NSArray *HorsepowerData;
@property (retain, nonatomic) NSArray *ZeroToSixtyData;
@property (retain, nonatomic) NSArray *MakeData;

@property (nonatomic, strong) NSMutableArray * makejsonArray;
@property (nonatomic, strong) NSMutableArray * makeimageArray;
@property (nonatomic, strong) NSArray * AlphabeticalArray;

- (void) retrieveMakeImageData;
- (void) retrieveData;
- (void) setModels;
- (void) UsePredicates;

@end
