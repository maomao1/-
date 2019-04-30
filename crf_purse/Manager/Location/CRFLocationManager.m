//
//  CRFLocationManager.m
//  crf_purse
//
//  Created by xu_cheng on 2017/7/7.
//  Copyright © 2017年 com.crfchina. All rights reserved.
//

#import "CRFLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface CRFLocationManager() <CLLocationManagerDelegate> {
    BOOL flag;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation CRFLocationManager

+ (instancetype)defaultManager {
    static CRFLocationManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if(self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [_locationManager requestWhenInUseAuthorization];
    }
    return self;
}

- (void)startPositioning {
    if (![CLLocationManager locationServicesEnabled]) {
        DLog(@"Location service is not yet open.");
        return;
    }
    if(([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        [self.locationManager startUpdatingLocation];
    } else {
        DLog(@"Location service not authorized.");
    }
}

- (void)stopPositioning {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    [self.locationManager stopUpdatingLocation];
    if (flag) {
        return;
    }
    flag = YES;
    [CRFAppManager defaultManager].locationInfo.longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    [CRFAppManager defaultManager].locationInfo.latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        for (CLPlacemark *place in placemarks) {
            DLog(@"name,%@",place.name);                       // 位置名
            DLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
            DLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
            DLog(@"locality,%@",place.locality);               // 市
            [CRFAppManager defaultManager].locationInfo.city = place.locality;
            DLog(@"subLocality,%@",place.subLocality);         // 区
            DLog(@"country,%@",place.country);                 // 国家
        }
        
    }];
}


@end
