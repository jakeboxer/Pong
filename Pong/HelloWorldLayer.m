//
//  HelloWorldLayer.m
//  Pong
//
//  Created by Jake Boxer on 4/21/12.
//  Copyright Jake Boxer 2012. All rights reserved.
//

#import "Ball.h"
#import "HelloWorldLayer.h"
#import "CCTouchDispatcher.h"
#import "CCNode+Frame.h"

enum GameState {
  GameStatePlaying,
  GameStateEnd,
  GameStateNone
};
typedef enum GameState GameState;

@interface HelloWorldLayer ()

@property (nonatomic, retain) Ball *ball;
@property (nonatomic, retain) CCSprite *paddle1;
@property (nonatomic, retain) CCSprite *paddle2;
@property (nonatomic, retain) CCLabelTTF *endLabel;
@property (nonatomic, assign) GameState gameState;
@property (nonatomic, assign) GameState gameStateWhereTouchBegan;
@property (nonatomic, assign) NSInteger winningPlayerNumber;

- (void)endGame;
- (void)startGame;
- (void)movePaddleSprite:(CCSprite *)paddleSprite toPosition:(CGPoint)position;
- (void)checkEndConditions:(ccTime)dt;
- (void)resetGameState;
- (void)updateGameObjects:(ccTime)dt;

@end

@implementation HelloWorldLayer

@synthesize ball;
@synthesize endLabel;
@synthesize gameState;
@synthesize gameStateWhereTouchBegan;
@synthesize paddle1;
@synthesize paddle2;
@synthesize winningPlayerNumber;

#pragma mark - Creation/removal methods

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];
	HelloWorldLayer *layer = [HelloWorldLayer node];

	// add layer as a child to scene
	[scene addChild:layer];

	return scene;
}

// on "init" you need to initialize your instance
- (id)init {
  self = [super init];

  // Apple recommends to re-assign "self" with the "super" return value
  if(nil != self) {
    self.ball = [[[Ball alloc] init] autorelease];
    [self addChild:self.ball.sprite];

    self.paddle1 = [CCSprite spriteWithFile:@"paddle1.png"];
    [self addChild:self.paddle1];

    self.paddle2 = [CCSprite spriteWithFile:@"paddle2.png"];
    [self addChild:self.paddle2];

    [self resetGameState];

    self.isTouchEnabled = YES;
    self.gameState = GameStatePlaying;

    [self scheduleUpdate];
  }

  return self;
}

- (void)dealloc {
  [ball release];
  [endLabel release];
  [paddle1 release];
  [paddle2 release];

  // don't forget to call "super dealloc"
  [super dealloc];
}

#pragma mark - Scheduled methods

// Runs every frame. Do data update logic here.
- (void)update:(ccTime)dt {
  [self updateGameObjects:dt];
  [self checkEndConditions:dt];
}

- (void)updateGameObjects:(ccTime)dt {
  // Check for ball containment
  if (!CGRectContainsRect(self.boundingBox, self.ball.sprite.boundingBox)) {
    // Ball collided with a top/bottom wall
    [self.ball flipVelocityY];
  }

  // Check for ball collisions.
  if (CGRectIntersectsRect(self.ball.sprite.boundingBox, self.paddle1.boundingBox) || CGRectIntersectsRect(self.ball.sprite.boundingBox, self.paddle2.boundingBox)) {
    // Ball collided with a paddle
    [self.ball flipVelocityX];
  }

  [self.ball update:dt];

  // For debugging purposes, keep paddle 2 in line with ball
  [self movePaddleSprite:self.paddle2 toPosition:self.ball.sprite.position];
}

- (void)checkEndConditions:(ccTime)dt {
  if (self.ball.sprite.rightX >= self.contentSize.width) {
    self.winningPlayerNumber = 1;
  } else if (self.ball.sprite.leftX <= 0) {
    self.winningPlayerNumber = 2;
  }

  if (self.winningPlayerNumber > 0) {
    self.endLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Player %d wins!", self.winningPlayerNumber]
                                       fontName:@"Helvetica"
                                       fontSize:24.0f];
    self.endLabel.position = self.center;
    [self addChild:self.endLabel];

    [self endGame];
  }
}

#pragma mark - Touch methods

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  self.gameStateWhereTouchBegan = self.gameState;
  CGPoint position = [self convertTouchToNodeSpace:touch];

  switch (self.gameState) {
    case GameStatePlaying:
      [self movePaddleSprite:self.paddle1 toPosition:position];
      break;
    default:
      break;
  }

  return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
  CGPoint position = [self convertTouchToNodeSpace:touch];

  switch (self.gameState) {
    case GameStatePlaying:
      [self movePaddleSprite:self.paddle1 toPosition:position];
      break;
    default:
      break;
  }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
  switch (self.gameState) {
    case GameStateEnd:
      if (GameStateEnd == self.gameStateWhereTouchBegan) {
        [self.endLabel removeFromParentAndCleanup:YES];
        self.endLabel = nil;

        [self resetGameState];
        [self startGame];
      }

      break;
    default:
      break;
  }
}

- (void)registerWithTouchDispatcher {
  // Tell the layer that we want targeted touch events instead of regular ones.
  [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                   priority:0
                                            swallowsTouches:YES];
}

#pragma mark - Game state methods

- (void)endGame {
  self.gameState = GameStateEnd;
  [[CCDirector sharedDirector] pause];
}

- (void)startGame {
  self.gameState = GameStatePlaying;
  [[CCDirector sharedDirector] resume];
}

- (void)resetGameState {
  // No one has won yet
  self.winningPlayerNumber = 0;

  self.ball.sprite.position = self.center;
  self.ball.velocity = ccp(-160.0f, 80.0f);

  self.paddle1.position = ccp(self.paddle1.halfWidth + 16.0f, self.halfHeight);
  self.paddle2.position = ccp(self.contentSize.width - self.paddle2.halfWidth - 16.0f, self.halfHeight);
}

#pragma mark - Sprite logic methods

- (void)movePaddleSprite:(CCSprite *)paddleSprite toPosition:(CGPoint)position {
  // Only use the Y axis of the touch. Don't allow it to go over the boundary.
  CGFloat verticalMargin = paddleSprite.halfHeight;
  CGFloat newY = MAX(verticalMargin, position.y);
  newY = MIN(self.contentSize.height - verticalMargin, newY);

  paddleSprite.position = ccp(paddleSprite.position.x, newY);
}

@end
