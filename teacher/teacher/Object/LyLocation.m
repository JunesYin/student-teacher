//
//  LyLocation.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/25.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyLocation.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "LyUtil.h"

#import "NSString+HantHansTranslate.h"




@implementation LyLocation


static CLGeocoder *geocoder;

+ (instancetype)locationWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude;
{
    LyLocation *tmpLocation = [[LyLocation alloc] initWithLatitude:latitude andLongitude:longitude];
    
    return tmpLocation;
}


+ (instancetype)locationWithLocatoin:(CLLocation *)location
{
    LyLocation *tmpLocation = [[LyLocation alloc] initWithLocation:location];
    
    return tmpLocation;
}


- (instancetype)initWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude
{
    if ( self = [super init])
    {
        _location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        _longitude = longitude;
        _latitude = latitude;
        
        _address = @"";
        _detailAddress = @"";
        
        [self translateDegressToAddress];
    }
    
    return self;
}

- (instancetype)initWithLocation:(CLLocation *)location
{
    if ( self = [super init])
    {
        _location = location;
        
        _latitude = _location.coordinate.latitude;
        _longitude = _location.coordinate.longitude;
        
        _address = @"";
        _detailAddress = @"";
        
        [self translateDegressToAddress];
    }
    
    return self;
}



- (instancetype)init
{
    if ( self = [super init])
    {
        _location = [[CLLocation alloc] init];
        
        _latitude = _location.coordinate.latitude;
        _longitude = _location.coordinate.longitude;
        
        _address = @"";
        _detailAddress = @"";
        
        [self translateDegressToAddress];
    }
    
    return self;
}



- (CLLocationDistance)distanceWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude
{
    if ( !self.isValid)
    {
        return INTMAX_MAX;
    }
//    CLLocationCoordinate2D te = {latitude, longitude};
//    CLLocationDistance distance = BMKMetersBetweenMapPoints( BMKMapPointForCoordinate(_location.coordinate), BMKMapPointForCoordinate(te));
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocationDistance distance = [_location distanceFromLocation:loc];
    
    return distance;
}


- (CLLocationDistance)distanceWithLocationCoordinate2D:(CLLocationCoordinate2D)coordinate
{
    if ( !self.isValid)
    {
        return INTMAX_MAX;
    }
    
    
//    CLLocationDistance distance = BMKMetersBetweenMapPoints( BMKMapPointForCoordinate(_location.coordinate), BMKMapPointForCoordinate(coordinate));
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    CLLocationDistance distance = [_location distanceFromLocation:loc];
    
    return distance;
}


- (CLLocationDistance)distanceFromLocation:(LyLocation *)location
{
//    CLLocationDistance distance = [_location distanceFromLocation:[location location]];
//    return distance;
    
    if ( ![location isValid])
    {
        return INTMAX_MAX;
    }
    
    if ( !self.isValid)
    {
        return INTMAX_MAX;
    }
    
//    CLLocationDistance distance = BMKMetersBetweenMapPoints( BMKMapPointForCoordinate(_location.coordinate), BMKMapPointForCoordinate(location.location.coordinate));
    CLLocationDistance distance = [_location distanceFromLocation:location.location];
    
    return distance;
}



- (NSString *)address
{
    if ( !_address || [NSNull null] == (NSNull *)_address || 0 == [_address length])
    {
        return @"";
    }
    
    return _address;
}


- (NSString *)detailAddress
{
    if ( !_detailAddress || [NSNull null] == (NSNull *)_detailAddress)
    {
        return @"";
    }
    
    return _detailAddress;
}


- (BOOL)isValid
{
    if ( 0 == _latitude && 0 == _longitude && 0 == [_location coordinate].latitude && 0 == [_location coordinate].longitude)
    {
        return NO;
    }
    
    return YES;
}


- (void)translateDegressToAddress
{
    if ( !geocoder)
    {
        geocoder = [[CLGeocoder alloc] init];
    }
    
    // 保存 Device 的现语言 (英语 法语 ，，，)
    NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans", nil] forKey:@"AppleLanguages"];
    
    [geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:_latitude longitude:_longitude] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if ( !error)
        {
            CLPlacemark *placeMark = [placemarks objectAtIndex:0];
            
            NSString *name = [placeMark name];
            //        NSString *thoroughfare = [placeMark thoroughfare];
            //        NSString *subThoroughfare = [placeMark subThoroughfare];
            NSString *locality = [placeMark locality];
            NSString *subLocality = [placeMark subLocality];
            NSString *administrativeArea = [placeMark administrativeArea];
            //        NSString *subAdministrativeArea = [placeMark subAdministrativeArea];
            //        NSString *postalCode = [placeMark postalCode];
            //        NSString *ISOcountryCode = [placeMark ISOcountryCode];
            //        NSString *country = [placeMark country];
            //        NSString *inlandWater = [placeMark inlandWater];
            //        NSString *ocean = [placeMark ocean];
            
            
            //        NSLog(@"====================================================================================================");
            //        NSLog(@"%@---%@", @"name", name);
            //        NSLog(@"%@---%@", @"thoroughfare", thoroughfare);
            //        NSLog(@"%@---%@", @"subThoroughfare", subThoroughfare);
            //        NSLog(@"%@---%@", @"locality", locality);
            //        NSLog(@"%@---%@", @"subLocality", subLocality);
            //        NSLog(@"%@---%@", @"administrativeArea", administrativeArea);
            //        NSLog(@"%@---%@", @"subAdministrativeArea", subAdministrativeArea);
            //        NSLog(@"%@---%@", @"postalCode", postalCode);
            //        NSLog(@"%@---%@", @"ISOcountryCode", ISOcountryCode);
            //        NSLog(@"%@---%@", @"country", country);
            //        NSLog(@"%@---%@", @"inlandWater", inlandWater);
            //        NSLog(@"%@---%@", @"ocean", ocean);
            
            //        _address = [[NSString alloc] initWithFormat:@"%@ %@", locality, administrativeArea];
            
            
            _province = [NSString big5ToGbk:locality];
            _city = [NSString big5ToGbk:administrativeArea];
            _district = [NSString big5ToGbk:subLocality];
            
            _address = [[NSString alloc] initWithFormat:@"%@ %@ %@", _province, _city, _district];
            _detailAddress = [NSString big5ToGbk:name];
            
            
            
            
            if ( [_delegate respondsToSelector:@selector(addressTranlated:)])
            {
                [_delegate addressTranlated:_address];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:LyNotificationForAddressTranslated object:_address];
            }
            
            // 还原Device 的语言
            [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
        }
        
    }];
}




- (NSString *)description
{
    return [[NSString alloc] initWithFormat:@"latitude=%.10f--longitude=%.10f", _latitude, _longitude];
}



@end
