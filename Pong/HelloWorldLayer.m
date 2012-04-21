//
//  HelloWorldLayer.m
//  Pong
//
//  Created by Jake Boxer on 4/21/12.
//  Copyright Jake Boxer 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize paddle1;
@synthesize paddle2;

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
  }

  return self;
}

- (void)update:(ccTime)dt {
  if (self.paddle1.position.y > 0) {
    self.paddle1.position = ccpSub(self.paddle1.position, ccp(0, 20.0f * dt));
  }

  if (self.paddle2.position.y < self.contentSize.height) {
    self.paddle2.position = ccpAdd(self.paddle2.position, ccp(0, 20.0f * dt));
  }
}

// on "dealloc" you need to release all your retained objects
- (void)dealloc {
  [paddle1 release];
  [paddle2 release];

	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
