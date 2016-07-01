//
//  PageItemController.h
//  Carhub
//
//  Created by Christoper Clark on 11/6/15.
//  Copyright © 2015 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Race.h"
#import "CustomPageControl.h"

@interface PageItemController : UIViewController<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

// Item controller information
@property (nonatomic) NSUInteger itemIndex;
@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, strong) Race *currentRace;
@property (nonatomic, strong) NSMutableArray * currentRaceResultsArray;
@property (nonatomic, strong) NSMutableArray * currentRaceImagesArray;

// IBOutlets
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *raceImagesCV;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl1;

-(void)getRaceResults:(id)currentRaceID;

@end
