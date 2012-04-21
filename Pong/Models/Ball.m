//
//  Ball.m
//  Pong
//
//  Created by Jacob Boxer on 4/21/12.
//  Copyright (c) 2012 Jake Boxer. All rights reserved.
//

#import "Ball.h"
#import "CCSprite.h"

@implementation Ball

@synthesize sprite;

#pragma mark - Creation/removal methods

- (id)init {
  self = [super init];
  
  if (nil != self) {
    self.sprite = [CCSprite spriteWithFile:@"ball.png"];
  }

  return self;
}

@end
