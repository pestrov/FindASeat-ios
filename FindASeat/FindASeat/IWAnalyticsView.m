//
//  IWAnalyticsView.m
//  FindASeat
//
//  Created by Сергей Муратов on 13.08.14.
//  Copyright (c) 2014 IWorkshop. All rights reserved.
//

#import "IWAnalyticsView.h"

@implementation IWAnalyticsView

- (id)initWithFrame:(CGRect)frame andSeatsInfo:(NSDictionary *)seatsInfo {
  self = [super initWithFrame:frame];
  if (self) {
    self.seatsInfo = seatsInfo;
  }
  return self;
}

- (void)drawAnalytics
{
  UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height)];
  label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0];
  
  NSInteger vacant = 0;
  NSInteger occupied = 0;
  for (NSDictionary * seatDict in [self.seatsInfo valueForKey:@"seats"]) {
    if ([seatDict[@"vacant"] integerValue]) {
      vacant++;
    } else {
      occupied++;
    }
  }
  
  label.text = [NSString stringWithFormat:@"%d/%d", vacant, occupied+vacant];
  [label sizeToFit];
  label.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
  [self addSubview:label];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
