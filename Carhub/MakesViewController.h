//
//  MakesViewController.h
//  Carhub
//
//  Created by Christopher Clark on 7/20/14.
//  Copyright (c) 2014 Ham Applications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface MakesViewController : UIViewController
{
    IBOutlet UIImageView * AcuraImage;
    IBOutlet UIImageView * AlfaRomeoImage;
    IBOutlet UIImageView * ArashImage;
    IBOutlet UIImageView * ArielImage;
    IBOutlet UIImageView * AstonMartinImage;
    IBOutlet UIImageView * AudiImage;
    IBOutlet UIImageView * BACImage;
    IBOutlet UIImageView * BentleyImage;
    IBOutlet UIImageView * BMWImage;
    IBOutlet UIImageView * BugattiImage;
    IBOutlet UIImageView * BuickImage;
    IBOutlet UIImageView * CadillacImage;
    IBOutlet UIImageView * CaparoImage;
    IBOutlet UIImageView * CaterhamImage;
    IBOutlet UIImageView * ChevroletImage;
    IBOutlet UIImageView * ChryslerImage;
    IBOutlet UIImageView * CitroenImage;
    IBOutlet UIImageView * CorvetteImage;
    IBOutlet UIImageView * DaciaImage;
    IBOutlet UIImageView * DeLoreanImage;
    IBOutlet UIImageView * DodgeImage;
    IBOutlet UIImageView * FerrariImage;
    IBOutlet UIImageView * FiatImage;
    IBOutlet UIImageView * FiskerImage;
    IBOutlet UIImageView * FordImage;
    IBOutlet UIImageView * GMCImage;
    IBOutlet UIImageView * GumpertImage;
    IBOutlet UIImageView * HennesseyImage;
    IBOutlet UIImageView * HondaImage;
    IBOutlet UIImageView * HummerImage;
    IBOutlet UIImageView * HyundaiImage;
    IBOutlet UIImageView * InfinitiImage;
    IBOutlet UIImageView * JaguarImage;
    IBOutlet UIImageView * JeepImage;
    IBOutlet UIImageView * KiaImage;
    IBOutlet UIImageView * KoenigseggImage;
    IBOutlet UIImageView * LamborghiniImage;
    IBOutlet UIImageView * LandRoverImage;
    IBOutlet UIImageView * LexusImage;
    IBOutlet UIImageView * LincolnImage;
    IBOutlet UIImageView * LotusImage;
    IBOutlet UIImageView * MaseratiImage;
    IBOutlet UIImageView * MaybachImage;
    IBOutlet UIImageView * MazdaImage;
    IBOutlet UIImageView * McLarenImage;
    IBOutlet UIImageView * MercedesBenzImage;
    IBOutlet UIImageView * MiniImage;
    IBOutlet UIImageView * MitsubishiImage;
    IBOutlet UIImageView * NissanImage;
    IBOutlet UIImageView * PaganiImage;
    IBOutlet UIImageView * PeugeotImage;
    IBOutlet UIImageView * PorscheImage;
    IBOutlet UIImageView * RAMImage;
    IBOutlet UIImageView * RenaultImage;
    IBOutlet UIImageView * RollsRoyceImage;
    IBOutlet UIImageView * ScionImage;
    IBOutlet UIImageView * SpykerImage;
    IBOutlet UIImageView * SRTImage;
    IBOutlet UIImageView * SSCImage;
    IBOutlet UIImageView * SubaruImage;
    IBOutlet UIImageView * TeslaImage;
    IBOutlet UIImageView * ToyotaImage;
    IBOutlet UIImageView * VauxhallImage;
    IBOutlet UIImageView * VolkswagenImage;
    IBOutlet UIImageView * VolvoImage;
    IBOutlet UIImageView * ZenvoImage;

    IBOutlet UIScrollView * scroller;
}
- (void)getfirstModel:(id)firstcarObject1;
- (void)getsecondModel:(id)secondcarObject1;
@property(nonatomic, strong) Model * firstCar1;
@property(nonatomic, strong) Model * secondCar1;

@end
