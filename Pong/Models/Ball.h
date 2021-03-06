//
//  Ball.h
//  Pong
//
//  Created by Jacob Boxer on 4/21/12.
//  Copyright (c) 2012 Jake Boxer. All rights reserved.
//

#import "cocos2d.h"

@interface Ball : NSObject

- (void)update:(ccTime)dt;
- (void)flipAngleHorizontally;
- (void)flipAngleVertically;
- (void)updateAngleAfterHittingPaddleAtPercentageFromCenter:(CGFloat)percentage;
- (BOOL)isMovingLeft;
- (BOOL)isMovingRight;
- (BOOL)isMovingUp;
- (BOOL)isMovingDown;

@property (nonatomic, retain) CCSprite *sprite;
@property (nonatomic, assign) CGFloat angleInRadians;
@property (nonatomic, assign) CGFloat speed;

@end
