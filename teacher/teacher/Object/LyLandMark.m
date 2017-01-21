//
//  LyLandMark.m
//  LyStudyDrive
//
//  Created by Junes on 16/7/6.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyLandMark.h"

@implementation LyLandMark


+ (instancetype)landMarkWithId:(NSString *)lmId
                          name:(NSString *)lmName
{
    LyLandMark *landMark = [[LyLandMark alloc] initWithId:lmId
                                                     name:lmName];
    
    return landMark;
}

- (instancetype)initWithId:(NSString *)lmId
                      name:(NSString *)lmName
{
    if (self = [super init]) {
        _lmId = lmId;
        _lmName = lmName;
    }
    
    return self;
}


+ (instancetype)landMarkWithId:(NSString *)lmId
                      name:(NSString *)lmName
                    coordinate:(CLLocationCoordinate2D)coordinate
{
    LyLandMark *landMark = [[LyLandMark alloc] initWithId:lmId
                                                 name:lmName
                                               coordinate:coordinate];
    
    return landMark;
}

+ (instancetype)landMarkWithId:(NSString *)lmId
                      name:(NSString *)lmName
                      latitude:(CLLocationDegrees)latitude
                     longitude:(CLLocationDegrees)longitude
{
    LyLandMark *landMark = [[LyLandMark alloc] initWithId:lmId
                                                     name:lmName
                                                 latitude:latitude
                                                longitude:longitude];
    
    return landMark;
}


- (instancetype)initWithId:(NSString *)lmId
                  name:(NSString *)lmName
                coordinate:(CLLocationCoordinate2D)coordinate
{
    if ( self = [super init])
    {
        _lmId = lmId;
        _lmName = lmName;
        _coordinate = coordinate;
    }
    
    return self;
}

- (instancetype)initWithId:(NSString *)lmId
                  name:(NSString *)lmName
                  latitude:(CLLocationDegrees)latitude
                 longitude:(CLLocationDegrees)longitude
{
    if ( self = [super init])
    {
        _lmId = lmId;
        _lmName = lmName;
        
        _coordinate.latitude = latitude;
        _coordinate.longitude = longitude;
    }
    
    return self;
}

@end
