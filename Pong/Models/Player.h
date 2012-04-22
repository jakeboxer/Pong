//
//  Player.h
//  Pong
//
//  Created by Jacob Boxer on 4/22/12.
//  Copyright (c) 2012 Jake Boxer. All rights reserved.
//

#import "cocos2d.h"

@interface Player : NSObject

- (id)initWithPlayerNumber:(NSInteger)aPlayerNumber;

@property (nonatomic, assign) NSInteger playerNumber;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, retain) CCSprite *sprite;

@end
