//
//  Ball.m
//  Pong
//
//  Created by Jacob Boxer on 4/21/12.
//  Copyright (c) 2012 Jake Boxer. All rights reserved.
//

#import "Ball.h"

@interface Ball ()

- (CGFloat)xOffsetOverTime:(ccTime)dt;
- (CGFloat)yOffsetOverTime:(ccTime)dt;

@end

@implementation Ball

@synthesize angleInRadians;
@synthesize speed;
@synthesize sprite;

#pragma mark - Creation/removal methods

- (id)init {
  self = [super init];
  
  if (nil != self) {
    self.speed = 5.0f;
    self.sprite = [CCSprite spriteWithFile:@"ball.png"];
  }

  return self;
}

#pragma mark - Scheduled methods

- (void)update:(ccTime)dt {
  self.sprite.position = ccpAdd(self.sprite.position, ccp([self xOffsetOverTime:dt], [self yOffsetOverTime:dt]));
}

#pragma mark - Movement methods

- (void)flipAngleHorizontally {
  self.angleInRadians = fabsf(self.angleInRadians - M_PI);
}

- (BOOL)isMovingLeft {
  return self.angleInRadians >= (M_PI_2) && self.angleInRadians <= (3.0f * M_PI_2);
}

- (BOOL)isMovingRight {
  return ![self isMovingLeft];
}

- (CGFloat)xOffsetOverTime:(ccTime)dt {
  return cosf(self.angleInRadians) * self.speed;
}

- (CGFloat)yOffsetOverTime:(ccTime)dt {
  return sinf(self.angleInRadians) * self.speed;
}

@end
