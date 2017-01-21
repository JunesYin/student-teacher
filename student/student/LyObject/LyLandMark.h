//
//  LyLandMark.h
//  LyStudyDrive
//
//  Created by Junes on 16/7/6.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>



@interface LyLandMark : NSObject


@property ( strong, nonatomic)      NSString                    *lmId;
@property ( retain, nonatomic)      NSString                    *lmMasterId;

@property ( assign, nonatomic)      CLLocationCoordinate2D      coordinate;
@property ( assign, nonatomic)      CLLocationDegrees           distance;


+ (instancetype)landMarkWithId:(NSString *)lmId
                      masterId:(NSString *)masterId
                    coordinate:(CLLocationCoordinate2D)coordinate;

+ (instancetype)landMarkWithId:(NSString *)lmId
                      masterId:(NSString *)masterId
                      latitude:(CLLocationDegrees)latitude
                     longitude:(CLLocationDegrees)longitude;


- (instancetype)initWithId:(NSString *)lmId
                      masterId:(NSString *)masterId
                    coordinate:(CLLocationCoordinate2D)coordinate;

- (instancetype)initWithId:(NSString *)lmId
                      masterId:(NSString *)masterId
                      latitude:(CLLocationDegrees)latitude
                     longitude:(CLLocationDegrees)longitude;

@end
