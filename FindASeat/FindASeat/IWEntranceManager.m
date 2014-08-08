//
//  IWEntranceManager.m
//  FindASeat
//
//  Created by Nikita Pestrov on 08.08.14.
//  Copyright (c) 2014 IWorkshop. All rights reserved.
//

#import "IWEntranceManager.h"
#define kFindASeatUUID @"EBEFD083-70A2-47C8-9837-E7B5634DF524"
@implementation IWEntranceManager

- (instancetype)init {
  if (self = [super init]) {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self initRegion];
  }
  return self;
}

- (void)initRegion {
  NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:kFindASeatUUID];
  self.beaconRegion =  [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.findaseat"];
  //[self.locationManager startMonitoringForRegion:self.beaconRegion];
  [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

+ (NSString *)closestEntranceID {
  return @"b3J7w16RVG";
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
  NSLog(@"monitoringDidFailForRegion - error: %@", [error localizedDescription]);
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"monitoringDidFailForRegion - error: %@", [error localizedDescription]);
}
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
  
}
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
  [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
  NSLog(@"OH YES");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
  [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
  NSLog(@"OH NO");
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
  CLBeacon *beacon = [[CLBeacon alloc] init];
  beacon = [beacons lastObject];
  
  NSLog(@"UUIDString %@ MAJOR %@ MINOR %@", beacon.proximityUUID.UUIDString, beacon.major, beacon.minor);
  if (beacon.proximity == CLProximityUnknown) {
    NSLog(@"Unknown Proximity");
  } else if (beacon.proximity == CLProximityImmediate) {
    NSLog(@"Immediate");
  } else if (beacon.proximity == CLProximityNear) {
    NSLog(@"Near");
  } else if (beacon.proximity == CLProximityFar) {
    NSLog(@"FAR");
  }
}
@end
