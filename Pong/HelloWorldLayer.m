//
//  HelloWorldLayer.m
//  Pong
//
//  Created by Jake Boxer on 4/21/12.
//  Copyright Jake Boxer 2012. All rights reserved.
//

#import "HelloWorldLayer.h"
#import "CCTouchDispatcher.h"

@interface HelloWorldLayer ()

- (void)movePaddleSprite:(CCSprite *)paddleSprite toPosition:(CGPoint)position;

@end

@implementation HelloWorldLayer

@synthesize paddle1;
@synthesize paddle2;

#pragma mark - Creation/removal methods

+ (CCScene *)scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];

	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];

	// add layer as a child to scene
	[scene addChild:layer];

	// return the scene
	return scene;
}

- (void)dealloc {
  [paddle1 release];
  [paddle2 release];

  // don't forget to call "super dealloc"
  [super dealloc];
}

// on "init" you need to initialize your instance
- (id)init {
  self = [super init];

  // Apple recommends to re-assign "self" with the "super" return value
  if(nil != self) {
    self.paddle1 = [CCSprite spriteWithFile:@"paddle1.png"];
    self.paddle1.position = ccp(24.0f, self.contentSize.height * 0.5f);
    [self addChild:self.paddle1];

    self.paddle2 = [CCSprite spriteWithFile:@"paddle2.png"];
    self.paddle2.position = ccp(self.contentSize.width - 24.0f, self.contentSize.height * 0.5f);
    [self addChild:self.paddle2];

    [self scheduleUpdate];

    self.isTouchEnabled = YES;
  }

  return self;
}

#pragma mark - Scheduled methods

// Runs every frame. Do data update logic here.
- (void)update:(ccTime)dt {
  if (self.paddle2.position.y < self.contentSize.height) {
    self.paddle2.position = ccpAdd(self.paddle2.position, ccp(0, 20.0f * dt));
  }
}

#pragma mark - Touch methods

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  CGPoint position = [self convertTouchToNodeSpace:touch];

  [self movePaddleSprite:self.paddle1 toPosition:position];

  return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
  // Do nothing.
}

- (void)registerWithTouchDispatcher {
  // Tell the layer that we want targeted touch events instead of regular ones.
  [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                   priority:0
                                            swallowsTouches:YES];
}

#pragma mark - Sprite logic methods

- (void)movePaddleSprite:(CCSprite *)paddleSprite toPosition:(CGPoint)position {
  // Only use the Y axis of the touch
  paddleSprite.position = ccp(self.paddle1.position.x, position.y);
}

@end
