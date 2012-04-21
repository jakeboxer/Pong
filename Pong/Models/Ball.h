//
//  Ball.h
//  Pong
//
//  Created by Jacob Boxer on 4/21/12.
//  Copyright (c) 2012 Jake Boxer. All rights reserved.
//

#import "cocos2d.h"

@interface Ball : NSObject

- (void)flipVelocityX;
- (void)flipVelocityY;
- (void)update:(ccTime)dt;

@property (nonatomic, retain) CCSprite *sprite;
@property (nonatomic, assign) CGPoint velocity;

@end
