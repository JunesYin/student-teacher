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


@property (strong, nonatomic)       NSString                    *lmId;
@property (retain, nonatomic)       NSString                    *lmName;

@property (assign, nonatomic)       CLLocationCoordinate2D      coordinate;



+ (instancetype)landMarkWithId:(NSString *)lmId
                          name:(NSString *)lmName;

- (instancetype)initWithId:(NSString *)lmId
                      name:(NSString *)lmName;

+ (instancetype)landMarkWithId:(NSString *)lmId
                          name:(NSString *)lmName
                    coordinate:(CLLocationCoordinate2D)coordinate;

- (instancetype)initWithId:(NSString *)lmId
                      name:(NSString *)lmName
                coordinate:(CLLocationCoordinate2D)coordinate;

+ (instancetype)landMarkWithId:(NSString *)lmId
                      name:(NSString *)lmName
                      latitude:(CLLocationDegrees)latitude
                     longitude:(CLLocationDegrees)longitude;

- (instancetype)initWithId:(NSString *)lmId
                      name:(NSString *)lmName
                      latitude:(CLLocationDegrees)latitude
                     longitude:(CLLocationDegrees)longitude;

@end
