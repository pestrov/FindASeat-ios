//
//  IWAnalyticsView.h
//  FindASeat
//
//  Created by Сергей Муратов on 13.08.14.
//  Copyright (c) 2014 IWorkshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IWHallViewController;
@interface IWAnalyticsView : UIView

- (id)initWithFrame:(CGRect)frame andSeatsInfo:(NSDictionary *)seatsInfo;
- (void)drawAnalytics;

@property (weak) IWHallViewController * delegate;
@property NSDictionary * seatsInfo;

@end
