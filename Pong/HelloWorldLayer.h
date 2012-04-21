//
//  HelloWorldLayer.h
//  Pong
//
//  Created by Jake Boxer on 4/21/12.
//  Copyright Jake Boxer 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class Ball;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer

// returns a CCScene that contains the HelloWorldLayer as the only child
+ (CCScene *)scene;

@property (nonatomic, retain) Ball *ball;
@property (nonatomic, retain) CCSprite *paddle1;
@property (nonatomic, retain) CCSprite *paddle2;

@end
