//
//  LyBMKPointAnnotaion.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/27.
//  Copyright © 2016年 Junes. All rights reserved.
//


#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface LyBMKPointAnnotaion : BMKPointAnnotation

@property ( nonatomic)      NSString        *annoId;

@property ( nonatomic)      NSString        *objectId;
@property ( nonatomic)      float           score;
//@property ( nonatomic)      float           price;

@end
