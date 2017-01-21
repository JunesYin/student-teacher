//
//  LyLocation.h
//  LyStudyDrive
//
//  Created by Junes on 16/5/25.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

//typedef double LyLocationDegress;


@protocol LyLocationTranslateAddressDelegate <NSObject>

- (void)addressTranlated:(NSString *)address;

@end


@interface LyLocation : NSObject

@property ( assign, nonatomic)      CLLocationDegrees       latitude;
@property ( assign, nonatomic)      CLLocationDegrees       longitude;


@property ( strong, nonatomic)      CLLocation              *location;

@property ( strong, nonatomic)      NSString                *province;
@property ( strong, nonatomic)      NSString                *city;
@property ( strong, nonatomic)      NSString                *district;
@property ( strong, nonatomic)      NSString                *address;
@property ( strong, nonatomic)      NSString                *detailAddress;

@property ( assign, nonatomic, getter=isValid)  BOOL        valid;

@property ( weak, nonatomic)    id<LyLocationTranslateAddressDelegate>      delegate;


+ (instancetype)locationWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude;

+ (instancetype)locationWithLocatoin:(CLLocation *)location;

- (instancetype)initWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude;

- (instancetype)initWithLocation:(CLLocation *)location;

- (CLLocationDistance)distanceWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude;

- (CLLocationDistance)distanceWithLocationCoordinate2D:(CLLocationCoordinate2D)coordinate;

- (CLLocationDistance)distanceFromLocation:(LyLocation *)location;


@end
