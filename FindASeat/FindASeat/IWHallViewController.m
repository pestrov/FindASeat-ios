//
//  IWHallViewController.m
//  FindASeat
//
//  Created by Nikita Pestrov on 08.08.14.
//  Copyright (c) 2014 IWorkshop. All rights reserved.
//

#import <Parse/Parse.h>
#import "IWHallViewController.h"
#import "IWSeatsView.h"
#import "IWServerManager.h"

@implementation IWHallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib
  [self addSeatsView];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSeats:) name:IWGotUserInfoNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateClosestSeat:) name:IWClosestSeatNotification object:nil];
  [IWServerManager getCurrenRoomInfo];
}

- (void)updateClosestSeat:(NSNotification *)notif
{
  NSDictionary * closestSeat = notif.userInfo;
  self.seatsView.closestSeatNumber = [closestSeat[@"closestSeat"] unsignedIntegerValue];
  [self.seatsView showClosestSeat];
}

- (void)updateSeats:(NSNotification *)notif
{
  NSDictionary * receivedSeatsInfo = notif.userInfo;
  self.seatsView.seatsInfo = receivedSeatsInfo;
  [self.seatsView drawSeats];
}

- (void)addSeatsView
{
  self.seatsView = [[IWSeatsView alloc]initWithFrame:self.seatsViewContainer.bounds andSeatsInfo:nil];
  self.seatsView.delegate = self;
  self.seatsView.center = CGPointMake(self.seatsViewContainer.bounds.size.width/2.0, self.seatsViewContainer.bounds.size.height/2.0);
  [self.seatsViewContainer addSubview:self.seatsView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
