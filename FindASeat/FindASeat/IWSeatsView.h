//
//  IWSeatsView.h
//  FindASeat
//
//  Created by Сергей Муратов on 08.08.14.
//  Copyright (c) 2014 IWorkshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IWHallViewController;
@interface IWSeatsView : UIView

- (id)initWithFrame:(CGRect)frame andSeatsInfo:(NSDictionary *)seatsInfo;
- (void)drawSeats;

@property (weak) IWHallViewController * delegate;
@property NSDictionary * seatsInfo;

@end
