//
//  LyLandMark.m
//  LyStudyDrive
//
//  Created by Junes on 16/7/6.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyLandMark.h"
#import "LyCurrentUser.h"

@implementation LyLandMark


+ (instancetype)landMarkWithId:(NSString *)lmId
                      masterId:(NSString *)masterId
                    coordinate:(CLLocationCoordinate2D)coordinate
{
    LyLandMark *landMark = [[LyLandMark alloc] initWithId:lmId
                                                 masterId:masterId
                                               coordinate:coordinate];
    
    return landMark;
}

+ (instancetype)landMarkWithId:(NSString *)lmId
                      masterId:(NSString *)masterId
                      latitude:(CLLocationDegrees)latitude
                     longitude:(CLLocationDegrees)longitude
{
    LyLandMark *landMark = [[LyLandMark alloc] initWithId:lmId
                                                 masterId:masterId
                                                 latitude:latitude
                                                longitude:longitude];
    
    return landMark;
}


- (instancetype)initWithId:(NSString *)lmId
                  masterId:(NSString *)masterId
                coordinate:(CLLocationCoordinate2D)coordinate
{
    if ( self = [super init])
    {
        _lmId = lmId;
        _lmMasterId = masterId;
        _coordinate = coordinate;
        
        _distance = [[[LyCurrentUser curUser] location] distanceWithLocationCoordinate2D:_coordinate];
    }
    
    return self;
}

- (instancetype)initWithId:(NSString *)lmId
                  masterId:(NSString *)masterId
                  latitude:(CLLocationDegrees)latitude
                 longitude:(CLLocationDegrees)longitude
{
    if ( self = [super init])
    {
        _lmId = lmId;
        _lmMasterId = masterId;
        
        _coordinate.latitude = latitude;
        _coordinate.longitude = longitude;
        
        _distance = [[[LyCurrentUser curUser] location] distanceWithLocationCoordinate2D:_coordinate];
    }
    
    return self;
}

@end
