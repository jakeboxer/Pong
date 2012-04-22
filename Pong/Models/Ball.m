//
//  Ball.m
//  Pong
//
//  Created by Jacob Boxer on 4/21/12.
//  Copyright (c) 2012 Jake Boxer. All rights reserved.
//

#import "Ball.h"

@interface Ball ()

+ (CGFloat)normalizedAngle:(CGFloat)angle;
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

+ (CGFloat)normalizedAngle:(CGFloat)angle {
  while (angle >= M_PI * 2.0f) {
    angle -= M_PI * 2.0f;
  }

  while (angle < 0) {
    angle += M_PI * 2.0f;
  }

  return angle;
}

- (void)flipAngleHorizontally {
  CGFloat offsetAngle;

  if (self.angleInRadians > M_PI) {
    offsetAngle = 3.0f * M_PI;
  } else {
    offsetAngle = M_PI;
  }

  self.angleInRadians = offsetAngle - self.angleInRadians;
}

- (void)flipAngleVertically {
  if (self.angleInRadians > 0) {
    self.angleInRadians = 2.0f * M_PI - self.angleInRadians;
  }
}

- (void)updateAngleAfterHittingPaddleAtPercentageFromCenter:(CGFloat)percentage {
  [self flipAngleHorizontally];

  CGFloat absoluteOffset = M_PI_4 * percentage;
  CGFloat newAngle;

  if ([self isMovingRight]) {
    // Moving right.

    // Offset is easy cuz increasing the angle always points further upwards.
    newAngle = [Ball normalizedAngle:self.angleInRadians + absoluteOffset];

    // Restriction is hard cuz of 2*pi - 0 cutoff.
    if (newAngle >= 3.0f * M_PI_2) {
      // Bottom-right quadrant (3*pi/2 to 2*pi). Restrict to above 19*pi/12
      newAngle = MAX(19.0f * M_PI / 12.0f, newAngle);
    } else {
      // Top-right quadrant (0 to pi/2). Restrict to below 5*pi/12
      newAngle = MIN(5.0f * M_PI  / 12.0f, newAngle);
    }
  } else {
    // Moving left.

    // Offset is easy cuz increasing the angle always points further downwards.
    newAngle = [Ball normalizedAngle:self.angleInRadians - absoluteOffset];

    // Restriction is easy. Restrict to between 7*pi/12 and 17*pi/12
    newAngle = MAX(7.0f * M_PI  / 12.0f, newAngle);
    newAngle = MIN(17.0f * M_PI / 18.0f, newAngle);
  }

  self.angleInRadians = newAngle;
}

- (BOOL)isMovingLeft {
  return self.angleInRadians >= (M_PI_2) && self.angleInRadians <= (3.0f * M_PI_2);
}

- (BOOL)isMovingRight {
  return ![self isMovingLeft];
}

- (BOOL)isMovingUp {
  return self.angleInRadians >= 0 && self.angleInRadians <= M_PI;
}

- (BOOL)isMovingDown {
  return ![self isMovingUp];
}

- (CGFloat)xOffsetOverTime:(ccTime)dt {
  return cosf(self.angleInRadians) * self.speed;
}

- (CGFloat)yOffsetOverTime:(ccTime)dt {
  return sinf(self.angleInRadians) * self.speed;
}

@end
