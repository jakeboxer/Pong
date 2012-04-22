//
//  Player.m
//  Pong
//
//  Created by Jacob Boxer on 4/22/12.
//  Copyright (c) 2012 Jake Boxer. All rights reserved.
//

#import "Player.h"

@implementation Player

@synthesize playerNumber;
@synthesize score;
@synthesize sprite;

#pragma mark - Creation/removal methods

- (id)initWithPlayerNumber:(NSInteger)aPlayerNumber {
  self = [super init];

  if (nil != self) {
    self.playerNumber = aPlayerNumber;
    self.score = 0;
    self.sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"paddle%d.png", self.playerNumber]];
  }

  return self;
}

@end
