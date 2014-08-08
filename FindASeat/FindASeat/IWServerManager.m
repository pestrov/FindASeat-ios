//
//  IWServerManager.m
//  FindASeat
//
//  Created by Nikita Pestrov on 08.08.14.
//  Copyright (c) 2014 IWorkshop. All rights reserved.
//

#import "IWServerManager.h"
#import "AppDelegate.h"

@implementation IWServerManager

+ (void)getCurrenRoomInfo {
  PFQuery *query = [PFQuery queryWithClassName:@"Entrance"];
  
  if (![IWEntranceManager closestEntranceID])
    return;
  
  [query whereKey:@"entranceNumber" equalTo:[IWEntranceManager closestEntranceID]];
  [query findObjectsInBackgroundWithBlock:^(NSArray *entrances, NSError *error) {
    
    PFRelation *room = [[entrances lastObject] relationForKey:@"room"];
    [[room query] findObjectsInBackgroundWithBlock:^(NSArray *rooms, NSError *error) {
      if (!error) {
        PFObject *room = [rooms lastObject];
        [self getBestSeatForRoom:[room objectId]];
        PFRelation *seats = [room relationForKey:@"seats"];
        [[seats query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
          if (!error) {
            NSMutableArray *seatsArray = [NSMutableArray arrayWithCapacity:objects.count];
            for (PFObject *seat in objects)
              [seatsArray addObject:@{@"position":@[seat[@"x"], seat[@"y"]],
                                      @"size": @[seat[@"width"], seat[@"height"]],
                                      @"number":seat[@"seatID"]}];
            [[NSNotificationCenter defaultCenter] postNotificationName:IWGotUserInfoNotification object:nil userInfo:@{@"size":@[room[@"width"],room[@"height"]],
                                                                                                                       @"seats":seatsArray}];
          }
        }];
      }
    }];
    ;
  }];
}

+ (void)getBestSeatForRoom:(NSString *)roomId {
  [PFCloud callFunctionInBackground:@"getClosestSeat"
                     withParameters:@{@"roomId": roomId}
                              block:^(NSNumber *seatNumber, NSError *error) {
                                if (!error) {
                                  [[NSNotificationCenter defaultCenter] postNotificationName:IWClosestSeatNotification object:nil userInfo:@{@"closestSeat":seatNumber}];
                                  NSLog(@"Seat! %@", seatNumber);
                                }
                              }];
}
@end
