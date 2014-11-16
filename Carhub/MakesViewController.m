//
//  MakesViewController.m
//  Carhub
//
//  Created by Christopher Clark on 7/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import "MakesViewController.h"
#import "AppDelegate.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface MakesViewController ()

@end

@implementation MakesViewController

- (AppDelegate *) appdelegate {
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
    }


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
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 2560)];
    self.title = @"Makes";
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"Metal Background.jpg"]];
                                 
    AlfaRomeoImage.image = nil;
    AcuraImage.image = nil;
    ArashImage.image = nil;
    ArielImage.image = nil;
    AstonMartinImage.image = nil;
    AudiImage.image = nil;
    BACImage.image = nil;
    BentleyImage.image = nil;
    BMWImage.image = nil;
    BugattiImage.image = nil;
    BuickImage.image = nil;
    CadillacImage.image = nil;
    CaparoImage.image = nil;
    CaterhamImage.image = nil;
    ChevroletImage.image = nil;
    ChryslerImage.image = nil;
    CitroenImage.image = nil;
    CorvetteImage.image = nil;
    DaciaImage.image = nil;
    DeLoreanImage.image = nil;
    DodgeImage.image = nil;
    FerrariImage.image = nil;
    FiatImage.image = nil;
    FiskerImage.image = nil;
    FordImage.image = nil;
    GMCImage.image = nil;
    GumpertImage.image = nil;
    HennesseyImage.image = nil;
    HondaImage.image = nil;
    HummerImage.image = nil;
    HyundaiImage.image = nil;
    InfinitiImage.image = nil;
    JaguarImage.image = nil;
    JeepImage.image = nil;
    KiaImage.image = nil;
    KoenigseggImage.image = nil;
    LamborghiniImage.image = nil;
    LandRoverImage.image = nil;
    LexusImage.image = nil;
    LincolnImage.image = nil;
    LotusImage.image = nil;
    MaseratiImage.image = nil;
    MaybachImage.image = nil;
    MazdaImage.image = nil;
    McLarenImage.image = nil;
    MercedesBenzImage.image = nil;
    MiniImage.image = nil;
    MitsubishiImage.image = nil;
    NissanImage.image = nil;
    PaganiImage.image = nil;
    PeugeotImage.image = nil;
    PorscheImage.image = nil;
    RAMImage.image = nil;
    RenaultImage.image = nil;
    RollsRoyceImage.image = nil;
    ScionImage.image = nil;
    SpykerImage.image = nil;
    SRTImage.image = nil;
    SSCImage.image = nil;
    SubaruImage.image = nil;
    TeslaImage.image = nil;
    ToyotaImage.image = nil;
    VauxhallImage.image = nil;
    VolkswagenImage.image = nil;
    VolvoImage.image = nil;
    ZenvoImage.image = nil;
    NSLog(@"%@", _firstCar1);
    NSLog(@"secondcar,%@", _secondCar1);
    
    dispatch_async(kBgQueue, ^{
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=1"]];
        if (imgData) {
            UIImage *image = [UIImage imageWithData:imgData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [AcuraImage setImage:image];
                });
            }
        }
        
        NSData *imgData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=2"]];
        if (imgData1) {
            UIImage *image = [UIImage imageWithData:imgData1];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [AlfaRomeoImage setImage:image];
                });
            }
        }
        
        NSData *imgData2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=78"]];
        if (imgData2) {
            UIImage *image = [UIImage imageWithData:imgData2];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ArashImage setImage:image];
                });
            }
        }
        NSData *imgData3 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=99"]];
        if (imgData3) {
            UIImage *image = [UIImage imageWithData:imgData3];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ArielImage setImage:image];
                });
            }
        }
        NSData *imgData4 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=3"]];
        if (imgData4) {
            UIImage *image = [UIImage imageWithData:imgData4];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [AstonMartinImage setImage:image];
                });
            }
        }
        NSData *imgData5 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=9"]];
        if (imgData5) {
            UIImage *image = [UIImage imageWithData:imgData5];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [AudiImage setImage:image];
                });
            }
        }
        NSData *imgData6 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=102"]];
        if (imgData6) {
            UIImage *image = [UIImage imageWithData:imgData6];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BACImage setImage:image];
                });
            }
        }
        NSData *imgData7 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=12"]];
        if (imgData7) {
            UIImage *image = [UIImage imageWithData:imgData7];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BentleyImage setImage:image];
                });
            }
        }
        NSData *imgData8 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=41"]];
        if (imgData8) {
            UIImage *image = [UIImage imageWithData:imgData8];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BMWImage setImage:image];
                });
            }
        }
        NSData *imgData9 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=42"]];
        if (imgData9) {
            UIImage *image = [UIImage imageWithData:imgData9];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BugattiImage setImage:image];
                });
            }
        }
        NSData *imgData10 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=89"]];
        if (imgData10) {
            UIImage *image = [UIImage imageWithData:imgData10];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BuickImage setImage:image];
                });
            }
        }
        NSData *imgData11 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=90"]];
        if (imgData11) {
            UIImage *image = [UIImage imageWithData:imgData11];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CadillacImage setImage:image];
                });
            }
        }
        NSData *imgData12 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=100"]];
        if (imgData12) {
            UIImage *image = [UIImage imageWithData:imgData12];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CaparoImage setImage:image];
                });
            }
        }
        NSData *imgData13 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=84"]];
        if (imgData13) {
            UIImage *image = [UIImage imageWithData:imgData13];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CaterhamImage setImage:image];
                });
            }
        }
        NSData *imgData14 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=46"]];
        if (imgData14) {
            UIImage *image = [UIImage imageWithData:imgData14];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ChevroletImage setImage:image];
                });
            }
        }
        NSData *imgData15 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=94"]];
        if (imgData15) {
            UIImage *image = [UIImage imageWithData:imgData15];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ChryslerImage setImage:image];
                });
            }
        }
        NSData *imgData16 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=48"]];
        if (imgData16) {
            UIImage *image = [UIImage imageWithData:imgData16];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CitroenImage setImage:image];
                });
            }
        }
        NSData *imgData17 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=18"]];
        if (imgData17) {
            UIImage *image = [UIImage imageWithData:imgData17];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CorvetteImage setImage:image];
                });
            }
        }
        NSData *imgData18 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=79"]];
        if (imgData18) {
            UIImage *image = [UIImage imageWithData:imgData18];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [DaciaImage setImage:image];
                });
            }
        }
        NSData *imgData19 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=80"]];
        if (imgData19) {
            UIImage *image = [UIImage imageWithData:imgData19];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [DeLoreanImage setImage:image];
                });
            }
        }
        NSData *imgData20 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=49"]];
        if (imgData20) {
            UIImage *image = [UIImage imageWithData:imgData20];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [DodgeImage setImage:image];
                });
            }
        }
        NSData *imgData21 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=50"]];
        if (imgData21) {
            UIImage *image = [UIImage imageWithData:imgData21];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [FerrariImage setImage:image];
                });
            }
        }
        NSData *imgData22 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=19"]];
        if (imgData22) {
            UIImage *image = [UIImage imageWithData:imgData22];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [FiatImage setImage:image];
                });
            }
        }
        NSData *imgData23 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=51"]];
        if (imgData23) {
            UIImage *image = [UIImage imageWithData:imgData23];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [FiskerImage setImage:image];
                });
            }
        }
        NSData *imgData24 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=52"]];
        if (imgData24) {
            UIImage *image = [UIImage imageWithData:imgData24];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [FordImage setImage:image];
                });
            }
        }
        NSData *imgData25 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=95"]];
        if (imgData25) {
            UIImage *image = [UIImage imageWithData:imgData25];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [GMCImage setImage:image];
                });
            }
        }
        NSData *imgData26 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=54"]];
        if (imgData26) {
            UIImage *image = [UIImage imageWithData:imgData26];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [GumpertImage setImage:image];
                });
            }
        }
        NSData *imgData27 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=83"]];
        if (imgData27) {
            UIImage *image = [UIImage imageWithData:imgData27];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HennesseyImage setImage:image];
                });
            }
        }
        NSData *imgData28 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=96"]];
        if (imgData28) {
            UIImage *image = [UIImage imageWithData:imgData28];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HondaImage setImage:image];
                });
            }
        }
        NSData *imgData29 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=85"]];
        if (imgData29) {
            UIImage *image = [UIImage imageWithData:imgData29];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HummerImage setImage:image];
                });
            }
        }
        NSData *imgData30 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=22"]];
        if (imgData30) {
            UIImage *image = [UIImage imageWithData:imgData30];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HyundaiImage setImage:image];
                });
            }
        }
        NSData *imgData31 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=56"]];
        if (imgData31) {
            UIImage *image = [UIImage imageWithData:imgData31];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [InfinitiImage setImage:image];
                });
            }
        }
        NSData *imgData32 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=23"]];
        if (imgData32) {
            UIImage *image = [UIImage imageWithData:imgData32];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [JaguarImage setImage:image];
                });
            }
        }
        NSData *imgData33 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=24"]];
        if (imgData33) {
            UIImage *image = [UIImage imageWithData:imgData33];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [JeepImage setImage:image];
                });
            }
        }
        NSData *imgData34 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=25"]];
        if (imgData34) {
            UIImage *image = [UIImage imageWithData:imgData34];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [KiaImage setImage:image];
                });
            }
        }
        NSData *imgData35 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=58"]];
        if (imgData35) {
            UIImage *image = [UIImage imageWithData:imgData35];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [KoenigseggImage setImage:image];
                });
            }
        }
        NSData *imgData36 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=59"]];
        if (imgData36) {
            UIImage *image = [UIImage imageWithData:imgData36];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LamborghiniImage setImage:image];
                });
            }
        }
        NSData *imgData37 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=61"]];
        if (imgData37) {
            UIImage *image = [UIImage imageWithData:imgData37];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LandRoverImage setImage:image];
                });
            }
        }
        NSData *imgData38 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=62"]];
        if (imgData38) {
            UIImage *image = [UIImage imageWithData:imgData38];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LexusImage setImage:image];
                });
            }
        }
        NSData *imgData39 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=27"]];
        if (imgData39) {
            UIImage *image = [UIImage imageWithData:imgData39];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LincolnImage setImage:image];
                });
            }
        }
        NSData *imgData40 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=28"]];
        if (imgData40) {
            UIImage *image = [UIImage imageWithData:imgData40];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LotusImage setImage:image];
                });
            }
        }
        NSData *imgData41 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=63"]];
        if (imgData41) {
            UIImage *image = [UIImage imageWithData:imgData41];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MaseratiImage setImage:image];
                });
            }
        }
        NSData *imgData42 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=29"]];
        if (imgData42) {
            UIImage *image = [UIImage imageWithData:imgData42];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MaybachImage setImage:image];
                });
            }
        }
        NSData *imgData43 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=64"]];
        if (imgData43) {
            UIImage *image = [UIImage imageWithData:imgData43];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MazdaImage setImage:image];
                });
            }
        }
        NSData *imgData44 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=98"]];
        if (imgData44) {
            UIImage *image = [UIImage imageWithData:imgData44];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [McLarenImage setImage:image];
                });
            }
        }
        NSData *imgData45 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=65"]];
        if (imgData45) {
            UIImage *image = [UIImage imageWithData:imgData45];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MercedesBenzImage setImage:image];
                });
            }
        }
        NSData *imgData46 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=66"]];
        if (imgData46) {
            UIImage *image = [UIImage imageWithData:imgData46];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MiniImage setImage:image];
                });
            }
        }
        NSData *imgData47 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=31"]];
        if (imgData47) {
            UIImage *image = [UIImage imageWithData:imgData47];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MitsubishiImage setImage:image];
                });
            }
        }
        NSData *imgData48 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=67"]];
        if (imgData48) {
            UIImage *image = [UIImage imageWithData:imgData48];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [NissanImage setImage:image];
                });
            }
        }
        NSData *imgData49 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=68"]];
        if (imgData49) {
            UIImage *image = [UIImage imageWithData:imgData49];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [PaganiImage setImage:image];
                });
            }
        }
        NSData *imgData50 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=69"]];
        if (imgData50) {
            UIImage *image = [UIImage imageWithData:imgData50];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [PeugeotImage setImage:image];
                });
            }
        }
        NSData *imgData51 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=87"]];
        if (imgData51) {
            UIImage *image = [UIImage imageWithData:imgData51];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [PorscheImage setImage:image];
                });
            }
        }
        NSData *imgData52 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=71"]];
        if (imgData52) {
            UIImage *image = [UIImage imageWithData:imgData52];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [RAMImage setImage:image];
                });
            }
        }
        NSData *imgData53 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=72"]];
        if (imgData53) {
            UIImage *image = [UIImage imageWithData:imgData53];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [RenaultImage setImage:image];
                });
            }
        }
        NSData *imgData54 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=35"]];
        if (imgData54) {
            UIImage *image = [UIImage imageWithData:imgData54];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [RollsRoyceImage setImage:image];
                });
            }
        }
        NSData *imgData55 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=73"]];
        if (imgData55) {
            UIImage *image = [UIImage imageWithData:imgData55];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ScionImage setImage:image];
                });
            }
        }
        NSData *imgData56 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=82"]];
        if (imgData56) {
            UIImage *image = [UIImage imageWithData:imgData56];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SRTImage setImage:image];
                });
            }
        }
        NSData *imgData57 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=36"]];
        if (imgData57) {
            UIImage *image = [UIImage imageWithData:imgData57];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SpykerImage setImage:image];
                });
            }
        }
        NSData *imgData58 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=101"]];
        if (imgData58) {
            UIImage *image = [UIImage imageWithData:imgData58];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SSCImage setImage:image];
                });
            }
        }
        NSData *imgData59 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=74"]];
        if (imgData59) {
            UIImage *image = [UIImage imageWithData:imgData59];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SubaruImage setImage:image];
                });
            }
        }
        NSData *imgData60 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=88"]];
        if (imgData60) {
            UIImage *image = [UIImage imageWithData:imgData60];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [TeslaImage setImage:image];
                });
            }
        }
        NSData *imgData61 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=75"]];
        if (imgData61) {
            UIImage *image = [UIImage imageWithData:imgData61];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ToyotaImage setImage:image];
                });
            }
        }
        NSData *imgData62 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=76"]];
        if (imgData62) {
            UIImage *image = [UIImage imageWithData:imgData62];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [VauxhallImage setImage:image];
                });
            }
        }
        NSData *imgData63 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=77"]];
        if (imgData63) {
            UIImage *image = [UIImage imageWithData:imgData63];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [VolkswagenImage setImage:image];
                });
            }
        }
        NSData *imgData64 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=39"]];
        if (imgData64) {
            UIImage *image = [UIImage imageWithData:imgData64];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [VolvoImage setImage:image];
                });
            }
        }
        NSData *imgData65 = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pl0x.net/image2.php?carno=103"]];
        if (imgData65) {
            UIImage *image = [UIImage imageWithData:imgData65];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ZenvoImage setImage:image];
                });
            }
        }
    });
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getfirstModel:(id)firstcarObject1;
{
    _firstCar1 = firstcarObject1;
}

- (void)getsecondModel:(id)secondcarObject1;
{
    _secondCar1 = secondcarObject1;
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"acuraseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"alfaromeoseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"arashseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];

    }
    if ([[segue identifier] isEqualToString:@"arielseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"astonmartinseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"audiseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"bacseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"bentleyseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"bmwseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"bugattiseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"buickseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"cadillacseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"caparoseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"caterhamseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"chevroletseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"chryslerseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"citroenseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"corvetteseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"daciaseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"deloreanseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"dodgeseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"ferrariseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"fiatseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];

    }
    if ([[segue identifier] isEqualToString:@"fiskerseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];

    }
    if ([[segue identifier] isEqualToString:@"fordseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"gmcseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"gumpertseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];

    }
    if ([[segue identifier] isEqualToString:@"hennesseyseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"hondaseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];

    }
    if ([[segue identifier] isEqualToString:@"hummerseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"hyundaiseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];

    }
    if ([[segue identifier] isEqualToString:@"alfaromeoseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];

    }
    if ([[segue identifier] isEqualToString:@"infinitiseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"jaguarseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];

    }
    if ([[segue identifier] isEqualToString:@"jeepseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"kiaseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"koenigseggseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"lamborghiniseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"landroverseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];

    }
    if ([[segue identifier] isEqualToString:@"lexusseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"lincolnseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"lotusseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"maseratiseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"maybachseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"mazdaseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"mclarenseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"mercedesseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"miniseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"mitsubishiseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"nissanseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"paganiseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"peugeotseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"porscheseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"ramseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"renaultseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];

    }
    if ([[segue identifier] isEqualToString:@"rollsroyceseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];

    }
    if ([[segue identifier] isEqualToString:@"scionseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"spykerseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"srtseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];

    }
    if ([[segue identifier] isEqualToString:@"sscseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"subaruseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];

    }
    if ([[segue identifier] isEqualToString:@"teslaseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"toyotaseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];

    }
    if ([[segue identifier] isEqualToString:@"volkswagenseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"volvoseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];
    }
    if ([[segue identifier] isEqualToString:@"zenvoseg"])
    {
        //Get the object for the selected row
        Model * firstcarobject2 = _firstCar1;
        Model * secondcarobject2 = _secondCar1;
        [[segue destinationViewController] getfirstModel:firstcarobject2];
        [[segue destinationViewController] getsecondModel:secondcarobject2];

    }


}


@end
