//
//  SettingsCell.h
//  Carhub
//
//  Created by Christoper Clark on 6/23/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsCell : UITableViewCell<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UILabel *settingLabel;
@property (nonatomic, strong) IBOutlet UIImageView *settingImage;
@property (nonatomic, strong) UITableView *cellTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

-(void)scrollTableToCurrentIndex;

@end
