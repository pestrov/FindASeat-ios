//
//  IWHallViewController.h
//  FindASeat
//
//  Created by Nikita Pestrov on 08.08.14.
//  Copyright (c) 2014 IWorkshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IWSeatsView;
@class IWAnalyticsView;
@interface IWHallViewController : UIViewController

@property IBOutlet UIView * seatsViewContainer;
@property IBOutlet UIView * analyticsViewContainer;

@property IWSeatsView * seatsView;
@property IWAnalyticsView * analyticsView;

@end
