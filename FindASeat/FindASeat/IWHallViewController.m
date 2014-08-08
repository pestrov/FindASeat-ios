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

@interface IWHallViewController ()

@end

@implementation IWHallViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.seatsInfo = [NSMutableDictionary new];
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib
  [self addSeatsView];
}

- (void)addSeatsView
{
  IWSeatsView * seatsView = [[IWSeatsView alloc]initWithFrame:self.seatsViewContainer.bounds andSeatsInfo:self.seatsInfo];
  [self.seatsViewContainer addSubview:seatsView];
  [seatsView drawSeats];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
