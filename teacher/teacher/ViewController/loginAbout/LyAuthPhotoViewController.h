//
//  LyAuthPhotoViewController.h
//  teacher
//
//  Created by Junes on 16/7/25.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyPhotoAsset;

@interface LyAuthPhotoViewController : UIViewController

//@property (retain, nonatomic)       UIImage         *imgCoachLicense;
//@property (retain, nonatomic)       UIImage         *imgDriveLicense;
//@property (retain, nonatomic)       UIImage         *imgIdentity;
//@property (retain, nonatomic)       UIImage         *imgBusinessLicense;


@property (strong, nonatomic)       LyPhotoAsset    *paCoachLicense;
@property (strong, nonatomic)       LyPhotoAsset    *paDriveLicense;
@property (strong, nonatomic)       LyPhotoAsset    *paIdentity;
@property (strong, nonatomic)       LyPhotoAsset    *paBusinessLicense;


@end
