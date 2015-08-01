//
//  DetailViewController.m
//  Carhub
//
//  Created by Christopher Clark on 7/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "DetailViewController.h"
#import "BackgroundLayer.h"
#import "CompareViewController.h"
#import "AppDelegate.h"
#import "FavoritesViewController.h"
#import "TopTensViewController.h"
#import "Model.h"
#import "STKAudioPlayer.h"
#import "ImageViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SpecsCell.h"
#import "SWRevealViewController.h"

@interface DetailViewController ()

@end
STKAudioPlayer * audioPlayer;

@implementation DetailViewController

@synthesize CarYearsMadeLabel, CarPriceLabel, CarEngineLabel, CarTransmissionLabel, CarDriveTypeLabel, CarHorsepowerLabel, CarZeroToSixtyLabel, CarTopSpeedLabel, CarWeightLabel, isPlaying, CarFuelEconomyLabel, savedArray, currentCar;

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
    
    UIImage* tabBarBackground = [UIImage imageNamed:@"DarkerTabBarColor.png"];
    [toolbar setBackgroundImage:tabBarBackground forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    [toolbar setFrame:CGRectMake(0, 524, 320, 44)];
    
    SpecsTableView = [[UITableView alloc]init];
    SpecsTableView.dataSource = self;
    SpecsTableView.delegate = self;
    [SpecsTableView registerClass:[SpecsCell class] forCellReuseIdentifier:@"SpecsCell"];
    [SpecsTableView reloadData];
    [self.view addSubview:SpecsTableView];
    
    isPlaying = false;
    
    audioPlayer = [[STKAudioPlayer alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkStar) name:@"ChangeStar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(revertExhaustButton) name:@"RevertExhaustButton" object:nil];
    
    if([self isSaved:currentCar] == true)
        [saveButton setBackgroundImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
    else
        [saveButton setBackgroundImage:[UIImage imageNamed:@"outline-star-64.png"] forState:UIControlStateNormal];
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 720)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = [[currentCar.CarMake stringByAppendingString:@" "] stringByAppendingString:currentCar.CarModel];
    
    [imageview setAlpha:1.0];
    [imageview sd_setImageWithURL:[NSURL URLWithString:currentCar.CarImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image.php"]]];
    
    [self setLabels];
}

- (void)viewWillAppear:(BOOL)animated {
    isPlaying = false;
    if(!([currentCar.CarExhaust isEqual:@""]))
        [exhaustButton setBackgroundImage:[UIImage imageNamed:@"ExhaustIconPlay.png"] forState:UIControlStateNormal];
    else
        [exhaustButton setBackgroundImage:[UIImage imageNamed:@"ExhaustIconPlayFade4.png"] forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated {
    [audioPlayer stop];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SpecsCell";
    SpecsCell *cell = (SpecsCell *)[SpecsTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[SpecsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    cell.SpecName.text = @"Years Made";
    
    return cell;
}

-(IBAction)Sound{
    if(!([currentCar.CarExhaust isEqual:@""])){
    if(isPlaying == false){
    isPlaying = true;
    [exhaustButton setBackgroundImage:[UIImage imageNamed:@"ExhaustIconPause.png"] forState:UIControlStateNormal];
    [audioPlayer resume];
    NSString * soundurl = [@"http://www.pl0x.net/CarSounds/" stringByAppendingString:currentCar.CarExhaust];
    [audioPlayer play:soundurl];
    }else{
        isPlaying = false;
        [exhaustButton setBackgroundImage:[UIImage imageNamed:@"ExhaustIconPlay.png"] forState:UIControlStateNormal];
        [audioPlayer stop];
    }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)Save{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    savedArray = [[NSMutableArray alloc]init];
    NSData *retrievedData = [defaults objectForKey:@"savedArray"];
    NSArray *testArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
    if(testArray.count!=0)
        savedArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
    
    if([self isSaved:currentCar] == false){
        [saveButton setBackgroundImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
        [savedArray addObject:currentCar];
    }else{
        [saveButton setBackgroundImage:[UIImage imageNamed:@"outline-star-64.png"] forState:UIControlStateNormal];
        int index = -1;
        for(int i=0; i<savedArray.count; i++){
            Model * savedObject = [savedArray objectAtIndex:i];
            if([savedObject.CarFullName isEqualToString:currentCar.CarFullName])
                index = i;
        }
        if(index != -1)
            [savedArray removeObjectAtIndex:index];
    }
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:savedArray];
    [defaults setObject:arrayData forKey:@"savedArray"];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadRootViewControllerTable" object:nil];
}

- (bool)isSaved:(Model *)currentModel
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    savedArray = [[NSMutableArray alloc]init];
    NSData *retrievedData = [defaults objectForKey:@"savedArray"];
    NSArray *testArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
    if(testArray.count!=0)
        savedArray = [NSKeyedUnarchiver unarchiveObjectWithData:retrievedData];
    
    bool isThere = false;
    for(int i=0; i<savedArray.count; i++){
        Model * savedObject = [savedArray objectAtIndex:i];
        if([savedObject.CarFullName isEqualToString:currentCar.CarFullName])
            isThere = true;
    }
    return isThere;
}

- (void)checkStar
{
    if([self isSaved:currentCar] == false)
        [saveButton setBackgroundImage:[UIImage imageNamed:@"outline-star-64.png"] forState:UIControlStateNormal];
    else
        [saveButton setBackgroundImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
}

- (void)revertExhaustButton
{
    isPlaying = false;
    [exhaustButton setBackgroundImage:[UIImage imageNamed:@"ExhaustIconPlay.png"] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark Methods

- (void)getModel:(id)modelObject;
{
    currentCar = modelObject;
}

- (void)setLabels
{
    CarYearsMadeLabel.text = currentCar.CarYearsMade;
    CarPriceLabel.text = currentCar.CarPrice;
    CarEngineLabel.text = currentCar.CarEngine;
    CarTransmissionLabel.text= currentCar.CarTransmission;
    CarDriveTypeLabel.text = currentCar.CarDriveType;
    CarHorsepowerLabel.text = currentCar.CarHorsepower;
    CarZeroToSixtyLabel.text = currentCar.CarZeroToSixty;
    CarTopSpeedLabel.text = currentCar.CarTopSpeed;
    CarWeightLabel.text = currentCar.CarWeight;
    CarFuelEconomyLabel.text = currentCar.CarFuelEconomy;
}

 #pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"pushCompareView"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *firstCarData = [NSKeyedArchiver archivedDataWithRootObject:currentCar];
        [defaults setObject:firstCarData forKey:@"firstcar"];
    }
    if ([[segue identifier] isEqualToString:@"pushCompareView2"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *secondCarData = [NSKeyedArchiver archivedDataWithRootObject:currentCar];
        [defaults setObject:secondCarData forKey:@"secondcar"];
    }
    if ([[segue identifier] isEqualToString:@"pushimageview"])
    {
        //Get the object
        [[segue destinationViewController] getfirstModel:currentCar];
    }
}

-(IBAction)Website
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:currentCar.CarWebsite]];
}

@end