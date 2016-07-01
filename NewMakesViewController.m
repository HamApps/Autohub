//
//  NewMakesViewController.m
//  Carhub
//
//  Created by Christoper Clark on 1/23/16.
//  Copyright © 2016 Ham Applications. All rights reserved.
//

#import "NewMakesViewController.h"
#import "AppDelegate.h"
#import "Make.h"
#import "Model.h"
#import "UIImageView+WebCache.h"
#import "CarViewCell.h"
#import "ModelViewController.h"
#import "SWRevealViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "DetailViewController.h"

@interface NewMakesViewController ()

@end

@implementation NewMakesViewController
@synthesize makeimageArray, circleScroller, appdelmodelArray, ModelArray, currentMake, currentClass, currentSubclass, searchArray, pushingObject, lineView, upperView, detailView, detailCell, detailImageView, initialCellFrame, cellToSlide, initialCellFrame2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeAppDelMakeArray];
    [self makeAppDelModelArray];
    
    self.title = @"Makes";
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
    
    [self setUpSlideToolBar];
    
    self.carousel.type = iCarouselTypeRotary;
    // Do any additional setup after loading the view.
    [self.carousel reloadData];
    [self.carousel setCurrentItemIndex:0];
    
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    
    //Add slider line
    lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 176.5, self.view.bounds.size.width-20, 1.0)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.upperView addSubview:lineView];
    [upperView bringSubviewToFront:circleScroller];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:@"Makes Layout Preference"]isEqualToString:@"Grid"])
    {
        NSLog(@"traditional");
        [self performSegueWithIdentifier:@"pushTradMakesInstant" sender:self];
    }
    
    detailView.view.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height-65, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height+65);
    detailView.SpecsTableView.frame = CGRectMake(detailView.SpecsTableView.frame.origin.x, detailView.SpecsTableView.frame.origin.x, detailView.SpecsTableView.frame.size.width, detailView.view.frame.size.height);
}

-(void)setUpSlideToolBar
{
    self.barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"lines7.png"] style:UIBarButtonItemStyleDone target:self.revealViewController action:@selector(revealToggle:)];
    self.barButton.tintColor = [UIColor blackColor];
    [self.navigationItem setLeftBarButtonItem:self.barButton];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    NSLog(@"count: %lu", (unsigned long)self.makeimageArray.count);
    return self.makeimageArray.count;
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    currentMake = [self.makeimageArray objectAtIndex:index];
    
    //create new view if no view is available for recycling
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        view.contentMode = UIViewContentModeCenter;

        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 200.0f, 100.0f)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"MavenProRegular" size:25];
        label.tag = 1;
        [view addSubview:label];
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    
    UIImageView *makeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, 200.0f, 90.0f)];
    __weak UIImageView *makeImageView2 = makeImageView;
    UIImageView *flagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(87.5, 25, 30.0f, 30.0f)];
    [flagImageView setCenter:CGPointMake(view.center.x, flagImageView.center.y)];
    makeImageView.contentMode = UIViewContentModeScaleAspectFit;
    flagImageView.contentMode = UIViewContentModeScaleAspectFit;

    [view addSubview:makeImageView];
    [view addSubview:flagImageView];
    
    NSURL *imageURL;
    if([currentMake.MakeImageURL containsString:@"carno"])
        imageURL = [NSURL URLWithString:currentMake.MakeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/image2.php"]];
    else
        imageURL = [NSURL URLWithString:currentMake.MakeImageURL relativeToURL:[NSURL URLWithString:@"http://pl0x.net/CarPictures/"]];

    [makeImageView setImageWithURL:imageURL
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageurl){
                                      [makeImageView2 setAlpha:0.0];
                                      [UIImageView animateWithDuration:0.5 animations:^{
                                          [makeImageView2 setAlpha:1.0];
                                      }];
                                  }
                usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    if ([currentMake.MakeCountry isEqualToString:@"America"])
        [flagImageView setImage:[UIImage imageNamed:@"united-states.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Czech"])
        [flagImageView setImage:[UIImage imageNamed:@"czech-republic.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Britain"])
        [flagImageView setImage:[UIImage imageNamed:@"united-kingdom.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Japan"])
        [flagImageView setImage:[UIImage imageNamed:@"japan.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Australia"])
        [flagImageView setImage:[UIImage imageNamed:@"australia.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Denmark"])
        [flagImageView setImage:[UIImage imageNamed:@"denmark.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"France"])
        [flagImageView setImage:[UIImage imageNamed:@"france.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Germany"])
        [flagImageView setImage:[UIImage imageNamed:@"germany.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Italy"])
        [flagImageView setImage:[UIImage imageNamed:@"italy.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Korea"])
        [flagImageView setImage:[UIImage imageNamed:@"south-korea.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Netherlands"])
        [flagImageView setImage:[UIImage imageNamed:@"netherlands.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Spain"])
        [flagImageView setImage:[UIImage imageNamed:@"spain.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Sweden"])
        [flagImageView setImage:[UIImage imageNamed:@"sweden.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"UAE"])
        [flagImageView setImage:[UIImage imageNamed:@"united-arab-emirates.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Russia"])
        [flagImageView setImage:[UIImage imageNamed:@"russia.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Austria"])
        [flagImageView setImage:[UIImage imageNamed:@"austria.png"]];
    if ([currentMake.MakeCountry isEqualToString:@"Romania"])
        [flagImageView setImage:[UIImage imageNamed:@"romania.png"]];

    
    label.text = currentMake.MakeName;
    
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 0;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 200.0f, 150.0f)];
        //2((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
        view.contentMode = UIViewContentModeCenter;
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:25.0f];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = (index == 0)? @"[": @"]";
    
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * self.carousel.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    /*switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * .95f;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.2;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }*/
    
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.1f;
        }
        case iCarouselOptionShowBackfaces:
            return 0;
        case iCarouselOptionFadeMin:
            return -0.1;
        case iCarouselOptionFadeMax:
            return 0.1;
        case iCarouselOptionFadeRange:
            return 1.5;
        default:
            return value;
    }

}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel;
{
    double xCoordinate = 0;
    if(carousel.currentItemIndex != 0)
        xCoordinate = 305.0*(carousel.currentItemIndex)/(makeimageArray.count);
    NSLog(@"xCoordinate: %f", xCoordinate);
    
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [circleScroller setFrame:CGRectMake(xCoordinate, 169, 15.0f, 15.0f)];
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
    
    if (carousel.currentItemIndex >= 0)
        currentMake = [makeimageArray objectAtIndex:carousel.currentItemIndex];
    
    [self switchCurrentMake];
}

#pragma mark -
#pragma mark TableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 183;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ModelCell";
    CarViewCell *cell = (CarViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[CarViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.imageScroller2.maximumZoomScale = 1.0;
    cell.imageScroller2.minimumZoomScale = 1.0;
    cell.imageScroller2.zoomScale = 1.0;
    [cell.imageScroller2 setContentOffset:CGPointMake(0, 0)];
    [cell.CarImage setAlpha:0.0];
    
    Model * modelObject = [self.ModelArray objectAtIndex:indexPath.row];
    
    [cell setUpCarImageWithModel:modelObject];
    
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedImage:)];
    [cell addGestureRecognizer:tapImage];
    
    cell.CarName.text = modelObject.CarModel;
    
    return cell;
}

- (void)switchCurrentMake;
{
    ModelArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<appdelmodelArray.count; i++)
    {
        Model *currentModel = [appdelmodelArray objectAtIndex:i];
        if (([currentModel.CarMake isEqualToString:currentMake.MakeName] && [currentModel.isClass isEqualToNumber:[NSNumber numberWithInt:1]]))
        //if (([currentModel.CarMake isEqualToString:currentMake.MakeName]))
            [ModelArray addObject:currentModel];
    }
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:NULL waitUntilDone:YES];
}

#pragma mark -
#pragma mark Loading methods

- (void) makeAppDelMakeArray;
{
    makeimageArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [makeimageArray addObjectsFromArray:appdel.makeimageArray2];
}
- (void) makeAppDelModelArray;
{
    appdelmodelArray = [[NSMutableArray alloc]init];
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelmodelArray addObjectsFromArray:appdel.modelArray];
}

#pragma mark -
#pragma mark Navigation methods

-(void)tappedImage:(UITapGestureRecognizer *)sender
{
    UIView *view = sender.view;
    CGPoint hitPoint = [view convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    [self.tableView selectRowAtIndexPath:hitIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:hitIndex];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //returns if view is in detailview state
    if(self.tableView.alpha == 0)
        return;
    
    pushingObject = [ModelArray objectAtIndex:indexPath.row];
    
    if([pushingObject.isModel isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        NSLog(@"push detail");
        [self pushDetailWithIndexPath:indexPath];
    }
    else if([pushingObject.isClass isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        NSLog(@"push subclasses");
        currentClass = pushingObject.CarModel;
        cellToSlide = [tableView cellForRowAtIndexPath:indexPath];
        [cellToSlide setFrame:[self.view convertRect:cellToSlide.frame fromView:cellToSlide.superview]];
        [self.view addSubview:cellToSlide];
        [UIView animateWithDuration:.5 animations:^{
            [cellToSlide setCenter:CGPointMake(160, 200)];
            [self.tableView setAlpha:0.0];
            [cellToSlide.imageView setAlpha:0.0];
        }];
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"pushSubclasses" sender:self];
        });
    }
    /*
    else if([pushingObject.isSubclass isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        currentSubclass = pushingObject.CarModel;
        [self performSegueWithIdentifier:@"pushModels" sender:self];
    }
    else if([pushingObject.isClass isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        currentClass = pushingObject.CarModel;
        [self performSegueWithIdentifier:@"pushSubclasses" sender:self];
    }
    NSLog(@"pushingobject.ismodel: %@", pushingObject.isModel);*/
}

-(void)pushDetailWithIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    CarViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    detailCell = selectedCell;
    pushingObject = [ModelArray objectAtIndex:indexPath.row];
    
    CGRect newFrame = [self.view convertRect:selectedCell.frame fromView:selectedCell.superview];
    initialCellFrame = newFrame;
    CGRect newFrame2 = [self.view convertRect:selectedCell.CarImage.frame fromView:selectedCell.CarImage.superview];
    detailImageView = selectedCell.CarImage;
    [self.view addSubview:selectedCell];
    [self.view addSubview:detailImageView];
    [selectedCell setFrame:newFrame];
    [detailImageView setFrame:newFrame2];
    
    [iCarousel animateWithDuration:.5 animations:^{
        _carousel.alpha = 0.0;
        lineView.alpha = 0.0;
        circleScroller.alpha = 0.0;
        upperView.alpha = 0.0;
        [self.tableView setAlpha:0.0];
        [selectedCell setAlpha:0.0];
        [selectedCell setCenter:CGPointMake(self.view.frame.size.width/2, 118)];
        [detailImageView setCenter:CGPointMake(self.view.frame.size.width/2, 118)];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        self.title = pushingObject.CarFullName;
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit46.png"] style:UIBarButtonItemStyleDone target:self action:@selector(pushSpecsDispute)];
        item.tintColor = [UIColor blackColor];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault.png"] style:UIBarButtonItemStyleDone target:self action:NULL];
        backButton.tintColor = [UIColor blackColor];
        [self.navigationItem setLeftBarButtonItem: backButton];
        [self.navigationItem setRightBarButtonItem:item];
        
        detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        detailView.view.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height);
        detailView.SpecsTableView.frame = CGRectMake(detailView.SpecsTableView.frame.origin.x, detailView.SpecsTableView.frame.origin.x, detailView.SpecsTableView.frame.size.width, detailView.view.frame.size.height);
        detailView.view.alpha = 0.0;
        
        [detailView getModel:pushingObject];
        
        [UIView animateWithDuration:1 animations:^{
            [self addChildViewController:detailView];
            [self.view addSubview:detailView.view];
            [self.view sendSubviewToBack:detailView.view];
            [detailView didMoveToParentViewController:self];
            detailView.view.alpha = 1.0;
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            CGRect newFrame = [detailView.SpecsTableView convertRect:detailImageView.frame fromView:self.view];
            [detailView.SpecsTableView addSubview:detailImageView];
            [detailImageView setFrame:newFrame];
            [backButton setAction:@selector(revertToMakesPage)];
            
            UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedDown:)];
            downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
            [detailImageView addGestureRecognizer:downSwipe];
            [detailView.SpecsTableView.panGestureRecognizer requireGestureRecognizerToFail:downSwipe];
            //[detailImageView setAlpha:0.0];
        });
    });
}

-(void)swipedDown:(UISwipeGestureRecognizer *)sender
{
    [self revertToMakesPage];
}

-(void)revertToMakesPage
{
    [detailView viewWillDisappear:NO];
    upperView.alpha = 1.0;
    CGRect frameInView = [self.view convertRect:detailImageView.frame fromView:detailView.SpecsTableView];
    [self.view addSubview:detailImageView];
    [detailImageView setFrame:frameInView];
    [detailImageView setFrame:CGRectMake(0, 0, detailImageView.frame.size.width, detailImageView.frame.size.height)];
    [detailCell.imageScroller2 addSubview:detailImageView];
    [detailCell setAlpha:1.0];
    
    self.title = @"Makes";
    [self setUpSlideToolBar];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Makes Switch.png"] style:UIBarButtonItemStyleDone target:self action:@selector(pushTraditionalMakes)];
    item.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = item;
    
    [UIView animateWithDuration:0.5 animations:^{
        [detailView.view setAlpha:0.0];
        _carousel.alpha = 1.0;
        lineView.alpha = 1.0;
        circleScroller.alpha = 1.0;
        [self.tableView setAlpha:1.0];
        [detailCell setFrame:initialCellFrame];
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        CGRect cellFrameInTable = [self.tableView convertRect:detailCell.frame fromView:self.view];
        [detailCell setFrame:cellFrameInTable];
        [_tableView addSubview:detailCell];
        [detailView removeFromParentViewController];
    });
}

-(void)revertFromSubClasses
{
    
}

-(void)pushSpecsDispute
{
    [self performSegueWithIdentifier:@"pushSpecsDispute" sender:self];
}

-(void)pushTraditionalMakes
{
    [self performSegueWithIdentifier:@"pushTradMakes" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushTradMakesInstant"])
    {
        [segue destinationViewController];
    }
    if ([[segue identifier] isEqualToString:@"pushTradMakes"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"Grid" forKey:@"Makes Layout Preference"];
        [segue destinationViewController];
    }
    if ([[segue identifier] isEqualToString:@"pushDetailView"])
    {
        [[segue destinationViewController] getModel:pushingObject];
    }
    
    if([[segue identifier] isEqualToString:@"pushSubclasses"])
    {
        [[segue destinationViewController] getClass: currentClass];
    }
    
    if([[segue identifier] isEqualToString:@"pushModels"])
    {
        [[segue destinationViewController] getSubclass: currentSubclass];
    }
}

- (IBAction)unwindToMakesVC:(UIStoryboardSegue *)segue
{
    
}

@end
