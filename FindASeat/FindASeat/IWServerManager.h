//
//  IWServerManager.h
//  FindASeat
//
//  Created by Nikita Pestrov on 08.08.14.
//  Copyright (c) 2014 IWorkshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWEntranceManager.h"
#define IWGotUserInfoNotification @"IWGotUserInfoNotification"
@interface IWServerManager : NSObject

+ (void)getCurrenRoomInfo;

@end
