//
//  HelloWorldLayer.m
//  Pong
//
//  Created by Jake Boxer on 4/21/12.
//  Copyright Jake Boxer 2012. All rights reserved.
//

#import "Ball.h"
#import "HelloWorldLayer.h"
#import "Player.h"

#import "CCTouchDispatcher.h"
#import "CCNode+Frame.h"

enum GameState {
  GameStatePlaying,
  GameStatePaused,
  GameStateNone
};
typedef enum GameState GameState;

@interface HelloWorldLayer ()

@property (nonatomic, retain) Ball *ball;
@property (nonatomic, retain) Player *player1;
@property (nonatomic, retain) Player *player2;
@property (nonatomic, retain) CCLabelTTF *endLabel;
@property (nonatomic, assign) GameState gameState;
@property (nonatomic, assign) GameState gameStateWhereTouchBegan;
@property (nonatomic, retain) NSDictionary *scoreLabels;
@property (nonatomic, readonly) Player *winningPlayer;

- (void)startGame;
- (void)pauseGame;
- (void)movePlayerSprite:(CCSprite *)playerSprite toPosition:(CGPoint)position;
- (void)checkEndConditions:(ccTime)dt;
- (void)resetGameState;
- (void)resetScores;
- (void)updateScoreLabelForPlayer:(Player *)player;
- (void)updateGameObjects:(ccTime)dt;

@end

@implementation HelloWorldLayer

static NSInteger const kWinningScore = 5;

@synthesize ball;
@synthesize endLabel;
@synthesize gameState;
@synthesize gameStateWhereTouchBegan;
@synthesize player1;
@synthesize player2;
@synthesize scoreLabels;

#pragma mark - Creation/removal methods

+ (CCScene *)scene {
	CCScene *scene = [CCScene node];
	HelloWorldLayer *layer = [HelloWorldLayer node];

	// add layer as a child to scene
	[scene addChild:layer];

	return scene;
}

- (id)init {
  self = [super init];

  if(nil != self) {
    CCLabelTTF *scoreLabel1 = [CCLabelTTF labelWithString:@"" fontName:@"Helvetica" fontSize:24.0f];
    scoreLabel1.position = ccp(50.0f, self.contentSize.height - 50.0f);
    [self addChild:scoreLabel1];

    CCLabelTTF *scoreLabel2 = [CCLabelTTF labelWithString:@"" fontName:@"Helvetica" fontSize:24.0f];
    scoreLabel2.position = ccp(self.contentSize.width - 50.0f, self.contentSize.height - 50.0f);
    [self addChild:scoreLabel2];

    self.scoreLabels = [NSDictionary dictionaryWithObjectsAndKeys:
                        scoreLabel1, [NSNumber numberWithInteger:1],
                        scoreLabel2, [NSNumber numberWithInteger:2],
                        nil];

    self.ball = [[[Ball alloc] init] autorelease];
    [self addChild:self.ball.sprite];

    self.player1 = [[[Player alloc] initWithPlayerNumber:1] autorelease];
    [self addChild:self.player1.sprite];

    self.player2 = [[[Player alloc] initWithPlayerNumber:2] autorelease];
    [self addChild:self.player2.sprite];

    [self resetScores];
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
  [player1 release];
  [player2 release];
  [scoreLabels release];

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
    if ((self.ball.sprite.topY    >= self.contentSize.height && [self.ball isMovingUp]) ||
        (self.ball.sprite.bottomY <= 0                       && [self.ball isMovingDown])) {
      // Ball collided with a top/bottom wall and is moving in that wall's direction.
      [self.ball flipAngleVertically];
    }
  }

  // Check for ball collisions.
  Player *collidingPlayer = nil;

  if (CGRectIntersectsRect(self.ball.sprite.boundingBox, self.player1.sprite.boundingBox) && [self.ball isMovingLeft]) {
    collidingPlayer = self.player1;
  } else if (CGRectIntersectsRect(self.ball.sprite.boundingBox, self.player2.sprite.boundingBox) && [self.ball isMovingRight]) {
    collidingPlayer = self.player2;
  }

  if (nil != collidingPlayer) {
    // Ball collided with a paddle and is moving in the paddle's direction.
    CGFloat percentageFromCenter = (self.ball.sprite.position.y - collidingPlayer.sprite.position.y) / collidingPlayer.sprite.contentSize.height;
    [self.ball updateAngleAfterHittingPaddleAtPercentageFromCenter:percentageFromCenter];
  }

  [self.ball update:dt];

  // For debugging purposes, keep paddle 2 in line with ball
  [self movePlayerSprite:self.player2.sprite toPosition:self.ball.sprite.position];
}

- (void)checkEndConditions:(ccTime)dt {
  Player *scoringPlayer = nil;

  if (self.ball.sprite.rightX >= self.contentSize.width) {
    self.player1.score++;
    scoringPlayer = self.player1;
  } else if (self.ball.sprite.leftX <= 0) {
    self.player2.score++;
    scoringPlayer = self.player2;
  }

  if (scoringPlayer != nil) {
    [self updateScoreLabelForPlayer:scoringPlayer];

    if (self.winningPlayer == scoringPlayer) {
      // Scoring player won.
      self.endLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Player %d wins!", scoringPlayer.playerNumber]
                                         fontName:@"Helvetica"
                                         fontSize:24.0f];
      self.endLabel.position = self.center;
      [self addChild:self.endLabel];
    }

    [self pauseGame];
  }
}

#pragma mark - Touch methods

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  self.gameStateWhereTouchBegan = self.gameState;
  CGPoint position = [self convertTouchToNodeSpace:touch];

  switch (self.gameState) {
    case GameStatePlaying:
      [self movePlayerSprite:self.player1.sprite toPosition:position];
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
      [self movePlayerSprite:self.player1.sprite toPosition:position];
      break;
    default:
      break;
  }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
  switch (self.gameState) {
    case GameStatePaused:
      if (GameStatePaused == self.gameStateWhereTouchBegan) {
        if (nil != self.winningPlayer) {
          // There is a winner, so start the game over.
          [self.endLabel removeFromParentAndCleanup:YES];
          self.endLabel = nil;
          [self resetScores];
        }

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

- (void)pauseGame {
  self.gameState = GameStatePaused;
  [[CCDirector sharedDirector] pause];
}

- (void)startGame {
  self.gameState = GameStatePlaying;
  [[CCDirector sharedDirector] resume];
}

- (void)resetGameState {
  self.ball.sprite.position = self.center;
  self.ball.angleInRadians = 5.0f * M_PI / 6.0f;

  self.player1.sprite.position = ccp(self.player1.sprite.halfWidth + 16.0f, self.halfHeight);
  self.player2.sprite.position = ccp(self.contentSize.width - self.player2.sprite.halfWidth - 16.0f, self.halfHeight);
}

- (void)resetScores {
  self.player1.score = 0;
  self.player2.score = 0;
  [self updateScoreLabelForPlayer:self.player1];
  [self updateScoreLabelForPlayer:self.player2];
}

- (void)updateScoreLabelForPlayer:(Player *)player {
  CCLabelTTF *scoringPlayerLabel = (CCLabelTTF *)[scoreLabels objectForKey:[NSNumber numberWithInteger:player.playerNumber]];
  [scoringPlayerLabel setString:[NSString stringWithFormat:@"%d", player.score]];
}

- (Player *)winningPlayer {
  Player *player = nil;

  if (self.player1.score >= kWinningScore) {
    player = self.player1;
  } else if (self.player2.score >= kWinningScore) {
    player = self.player2;
  }

  return player;
}

#pragma mark - Sprite logic methods

- (void)movePlayerSprite:(CCSprite *)playerSprite toPosition:(CGPoint)position {
  // Only use the Y axis of the touch. Don't allow it to go over the boundary.
  CGFloat verticalMargin = playerSprite.halfHeight;
  CGFloat newY = MAX(verticalMargin, position.y);
  newY = MIN(self.contentSize.height - verticalMargin, newY);

  playerSprite.position = ccp(playerSprite.position.x, newY);
}

@end
