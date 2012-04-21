//
//  CCNode+Frame.m
//  Pong
//
//  Created by Jacob Boxer on 4/21/12.
//  Copyright (c) 2012 Jake Boxer. All rights reserved.
//

#import "CCNode+Frame.h"

@implementation CCNode (Frame)

- (CGFloat)halfWidth {
  return self.contentSize.width * 0.5f;
}

- (CGFloat)halfHeight {
  return self.contentSize.height * 0.5f;
}

- (CGFloat)leftX {
  return self.position.x - self.halfWidth;
}

- (CGFloat)rightX {
  return self.position.x + self.halfWidth;
}

- (CGFloat)topY {
  return self.position.y + self.halfHeight;
}

- (CGFloat)bottomY {
  return self.position.y - self.halfHeight;
}

@end
