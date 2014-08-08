//
//  IWSeatsView.m
//  FindASeat
//
//  Created by Сергей Муратов on 08.08.14.
//  Copyright (c) 2014 IWorkshop. All rights reserved.
//

#import "IWSeatsView.h"

@implementation IWSeatsView

- (id)initWithFrame:(CGRect)frame andSeatsInfo:(NSDictionary *)seatsInfo {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    self.seatsInfo = seatsInfo;
  }
  return self;
}

- (void)drawSeats
{
  CGRect totalFrame = CGRectMake(0.0, 0.0, [[[self.seatsInfo valueForKey:@"size"] firstObject] floatValue], [[[self.seatsInfo valueForKey:@"size"] lastObject] floatValue]);
  CGFloat scaleCoef = [self scaleCoefForFrame:totalFrame];
  [self drawSeatsWithScaleCoef:scaleCoef];
}

- (void)drawSeatsWithScaleCoef:(CGFloat)scale
{
  for (NSDictionary * seatDict in [self.seatsInfo valueForKey:@"seats"]) {
    CGFloat seatWidth = [[seatDict[@"size"] firstObject] floatValue];
    CGFloat seatHeight = [[seatDict[@"size"] lastObject] floatValue];
    
    CGFloat seatX = [[seatDict[@"position"] firstObject] floatValue] - seatWidth/2.0;
    CGFloat seatY = [[seatDict[@"position"] lastObject] floatValue] - seatHeight/2.0;
    
    CGRect seatPlace = CGRectMake(scale*seatX, scale*seatY, scale*seatWidth, scale*seatHeight);
    [self drawSeatWithFrame:seatPlace andNumber:seatDict[@"number"]];
  }
}

- (void)drawSeatWithFrame:(CGRect)frame andNumber:(NSNumber *)number
{
  UIView * seatView = [[UIView alloc]initWithFrame:frame];
  UIImageView * icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SeatIcon"]];
  icon.frame = CGRectMake(0.0, 0.0, seatView.frame.size.width, seatView.frame.size.height);
  [seatView addSubview:icon];
  
  UILabel * numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
  numberLabel.text = [NSString stringWithFormat:@"%d", number.intValue];
  [numberLabel sizeToFit];
  numberLabel.center = CGPointMake(seatView.center.x, seatView.center.y);
  [seatView addSubview:numberLabel];
  
  [self addSubview:seatView];
}

- (CGFloat)scaleCoefForFrame:(CGRect)frame
{
  if ((frame.size.width > self.frame.size.width) || (frame.size.height > self.frame.size.height)) {
    if (frame.size.width > frame.size.height) {
      return self.frame.size.width/frame.size.width;
    } else {
      return self.frame.size.height/frame.size.height;
    }
  }
  return 1.0;
}

@end
