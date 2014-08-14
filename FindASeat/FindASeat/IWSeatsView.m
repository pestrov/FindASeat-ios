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
    self.seatsInfo = seatsInfo;
    self.seatViews = [NSMutableArray new];
  }
  return self;
}

- (void)drawSeats
{
  CGRect totalFrame = CGRectMake(0.0, 0.0, [[[self.seatsInfo valueForKey:@"size"] firstObject] floatValue], [[[self.seatsInfo valueForKey:@"size"] lastObject] floatValue]);
  CGFloat scaleCoef = [self scaleCoefForFrame:totalFrame];
  [self drawSeatsWithScaleCoef:scaleCoef];
  if (self.seatViews.count && self.closestSeatNumber) {
    [self showClosestSeat];
  }
}

- (void)showClosestSeat {
  for (UIView * seatView in self.seatViews) {
    UIImageView * subviewImage = nil;
    for (UIView * subview in seatView.subviews) {
      BOOL makeItMarked = NO;
      if ([subview isKindOfClass:[UILabel class]]) {
        if ( [[(UILabel *)subview text] isEqualToString:[NSString stringWithFormat:@"%d", self.closestSeatNumber]]) {
          [(UILabel *)subview setTextColor:[UIColor whiteColor]];
          makeItMarked = YES;
          [subviewImage setImage:[UIImage imageNamed:@"tick"]];
          [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
            seatView.center = CGPointMake(seatView.center.x, seatView.center.y-5.0);
          } completion:nil];
        }
      }
      if ([subview isKindOfClass:[UIImageView class]]) {
        subviewImage = (UIImageView *)subview;
        if (makeItMarked) {
          [subviewImage setImage:[UIImage imageNamed:@"tick"]];
          [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
            seatView.center = CGPointMake(seatView.center.x, seatView.center.y-5.0);
          } completion:nil];
        }
      }

    }
  }
}

- (void)drawSeatsWithScaleCoef:(CGFloat)scale
{
  for (NSDictionary * seatDict in [self.seatsInfo valueForKey:@"seats"]) {
    CGFloat seatWidth = [[seatDict[@"size"] firstObject] floatValue];
    CGFloat seatHeight = [[seatDict[@"size"] lastObject] floatValue];
    
    CGFloat seatX = [[seatDict[@"position"] firstObject] floatValue]; //- seatWidth/2.0;
    CGFloat seatY = [[seatDict[@"position"] lastObject] floatValue]; //- seatHeight/2.0;
    
    CGRect seatPlace = CGRectMake(scale*seatX, scale*seatY, scale*seatWidth, scale*seatHeight);
    [self drawSeatWithFrame:seatPlace andNumber:seatDict[@"number"] vacant:seatDict[@"vacant"]];
  }
  [self sizeToFit];
  self.center = CGPointMake(-20.0, self.superview.bounds.size.height/2.0);
}

- (CGSize)sizeThatFits:(CGSize)size
{
  CGFloat minimumX = size.width;
  CGFloat minimumY = size.height;
  CGFloat maximumX = 0.0;
  CGFloat maximumY = 0.0;
  for (UIView * view in self.subviews) {
    if ((view.frame.origin.x + view.frame.size.width) > maximumX) {
      maximumX = view.frame.origin.x+view.frame.size.width;
    }
    if ((view.frame.origin.y + view.frame.size.height) > maximumY) {
      maximumY = view.frame.origin.y + view.frame.size.height;
    }
    if ((view.frame.origin.x) < minimumX) {
      minimumX = view.frame.origin.x;
    }
    if ((view.frame.origin.y) < minimumY) {
      minimumY = view.frame.origin.y;
    }
  }
  if (maximumX > 0.0 && maximumY > 0.0) {
    return CGSizeMake(maximumX-minimumX, maximumY-minimumY);
  } else {
    return size;
  }
}

- (void)drawSeatWithFrame:(CGRect)frame andNumber:(NSNumber *)number vacant:(id)vacant
{
  UIView * seatView = [[UIView alloc]initWithFrame:frame];
  UIImageView * icon;
  if ([vacant integerValue]) {
    icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"green"]];
  } else {
    icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"red"]];
  }
  icon.frame = CGRectMake(0.0, 0.0, seatView.frame.size.width, seatView.frame.size.height);
  [seatView addSubview:icon];
  
  UILabel * numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
  numberLabel.text = [NSString stringWithFormat:@"%d", number.intValue];
  numberLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0];
  [numberLabel sizeToFit];
  numberLabel.center = CGPointMake(seatView.bounds.size.width/2.0, seatView.bounds.size.height/3.0);
  numberLabel.alpha = 0.0;
  [seatView addSubview:numberLabel];

  [self.seatViews addObject:seatView];
  [self addSubview:seatView];
}

- (CGFloat)scaleCoefForFrame:(CGRect)frame
{
  return 0.45;
  return MIN(self.frame.size.width/frame.size.width, self.frame.size.height/frame.size.height);
  
  /* Former scale
  if (frame.size.width > frame.size.height) {
    return self.frame.size.width/frame.size.width;
  } else {
    return self.frame.size.height/frame.size.height;
  }
  return 1.0;
  */
}

@end
