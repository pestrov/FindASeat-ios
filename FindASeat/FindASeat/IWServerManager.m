//
//  IWServerManager.m
//  FindASeat
//
//  Created by Nikita Pestrov on 08.08.14.
//  Copyright (c) 2014 IWorkshop. All rights reserved.
//

#import "IWServerManager.h"
#import "AppDelegate.h"
#import "MJDijkstra.h"


#define occupiedSeatWeight 5
#define vacantSeatWeight 3
#define outerWeight 1

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
        PFRelation *seats = [room relationForKey:@"seats"];
        [[seats query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
          if (!error) {
            NSMutableArray *seatsArray = [NSMutableArray arrayWithCapacity:objects.count];
            for (PFObject *seat in objects)
              [seatsArray addObject:@{@"position":@[seat[@"x"], seat[@"y"]],
                                      @"size": @[seat[@"width"], seat[@"height"]],
                                      @"number":seat[@"seatID"],
                                      @"vacant":seat[@"vacant"],
                                      @"row":seat[@"rowID"]}];
            [seatsArray sortUsingDescriptors:@[ [[NSSortDescriptor alloc] initWithKey:@"number"  ascending:YES]]];
            NSDictionary *roomInfo = @{@"size":@[room[@"width"], room[@"height"]],
                                       @"seats":seatsArray,
                                       @"entrance":@[@0, @180]};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:IWGotUserInfoNotification object:nil userInfo:roomInfo];
            
            [self findBestSeat:roomInfo];
          }
        }];
      }
    }];
    ;
  }];
}

+ (void)findBestSeat:(NSDictionary *)roomInfo {
  
  NSMutableDictionary *rows = [NSMutableDictionary dictionary];
  NSUInteger currentRow = 1;
  NSArray *seats =  roomInfo[@"seats"];
  NSUInteger seatsNumber =  seats.count;
  
  //Seats
  for (NSDictionary *seat in seats) {
    NSMutableDictionary *seatConnections = [NSMutableDictionary dictionary];
    
    if ([seat[@"number"] integerValue] < seatsNumber ) {
      
      NSDictionary *nextSeat = seats[[seats indexOfObject:seat] + 1];
      if ([nextSeat[@"row"] integerValue] == [seat[@"row"] integerValue])
        seatConnections[[self seatID: nextSeat]] = @([self weightForSeat:nextSeat]);
      else
        currentRow++;
    }
    
    if ([seat[@"number"] integerValue] > 1) {
      NSDictionary *prevSeat = seats[[seats indexOfObject:seat] - 1];
      if ([prevSeat[@"row"] integerValue] == [seat[@"row"] integerValue])
        seatConnections[[self seatID: prevSeat]] = @([self weightForSeat:prevSeat]);
    }
    
    rows[[self seatID:seat]] = seatConnections;
  }
  
  NSUInteger interRowDist = [[roomInfo[@"size"] lastObject] unsignedIntegerValue]/currentRow;
//Outer space
  for (NSUInteger row = 1; row <= currentRow; row ++) {
    NSMutableDictionary *outerConnection = [NSMutableDictionary dictionary];
    
    outerConnection[[self seatID:seats[(row - 1) * seatsNumber/currentRow]]] = @(outerWeight * [[seats[(row - 1) * seatsNumber/currentRow][@"position"] firstObject] integerValue]);
    
        if (row > 1)
      outerConnection[[NSString stringWithFormat:@"row%u", row - 1]] = @(outerWeight * interRowDist);
    if (row < currentRow)
      outerConnection[[NSString stringWithFormat:@"row%u", row + 1]] = @(outerWeight * interRowDist);
    
    rows[[NSString stringWithFormat:@"row%u", row]] =  outerConnection;
    
  }
  
  NSString *entrancePoint = [NSString stringWithFormat:@"row%u", (([[roomInfo[@"entrance"] lastObject] unsignedIntegerValue] - [[[seats firstObject][@"position"]lastObject] unsignedIntegerValue])/interRowDist)% currentRow + 1];
 MJDijkstraSolution solution =  Dijkstra(rows, entrancePoint, @"12");
  NSMutableDictionary *emptySeatsDist = [NSMutableDictionary dictionary];
  
  for (NSDictionary *seat in seats) {
    if (![seat[@"vacant"] boolValue])
      continue;
    if (solution.distances[[self seatID:seat]])
      emptySeatsDist[[self seatID:seat]] = solution.distances[[self seatID:seat]];
  }
  
  NSArray *sortedDistances = [emptySeatsDist.allValues sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    if ([obj1 floatValue] > [obj2 floatValue])
      return NSOrderedDescending;
    else if ([obj1 floatValue] < [obj2 floatValue])
      return NSOrderedAscending;
    return NSOrderedSame;
  }];
  
  NSNumber *bestSeat;
  for (NSString *seatId in emptySeatsDist.allKeys)
    if ([emptySeatsDist[seatId] isEqual:sortedDistances.firstObject])
      bestSeat = @(seatId.integerValue);
  
   [[NSNotificationCenter defaultCenter] postNotificationName:IWClosestSeatNotification object:nil userInfo:@{@"closestSeat":@10}];
}

+ (NSUInteger)weightForSeat:(NSDictionary *)seatInfo {
  NSUInteger weight = 0;
  
  if ([seatInfo[@"vacant"] boolValue]) {
    weight = [[seatInfo[@"size"] firstObject] integerValue] * vacantSeatWeight;
  } else {
    weight = [[seatInfo[@"size"] firstObject] integerValue] * occupiedSeatWeight;
  }
  return weight;
}

+ (NSString *)seatID:(NSDictionary *)seatInfo {
  return [NSString stringWithFormat:@"%@",seatInfo[@"number"]];
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
