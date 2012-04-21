//
//  Ball.m
//  Pong
//
//  Created by Jacob Boxer on 4/21/12.
//  Copyright (c) 2012 Jake Boxer. All rights reserved.
//

#import "Ball.h"

@implementation Ball

@synthesize sprite;
@synthesize velocity;

#pragma mark - Creation/removal methods

- (id)init {
  self = [super init];
  
  if (nil != self) {
    self.sprite = [CCSprite spriteWithFile:@"ball.png"];
    self.velocity = ccp(-80.0f, 40.0f);
  }

  return self;
}

#pragma mark - Scheduled methods

- (void)update:(ccTime)dt {
  self.sprite.position = ccpAdd(self.sprite.position, ccpMult(self.velocity, dt));
}

#pragma mark - Movement methods

- (void)flipVelocityX {
  self.velocity = ccp(-self.velocity.x, self.velocity.y);
}

- (void)flipVelocityY {
  self.velocity = ccp(self.velocity.x, -self.velocity.y);
}

@end
