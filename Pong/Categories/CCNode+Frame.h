//
//  CCNode+Frame.h
//  Pong
//
//  Created by Jacob Boxer on 4/21/12.
//  Copyright (c) 2012 Jake Boxer. All rights reserved.
//

#import "CCNode.h"

@interface CCNode (Frame)

@property (nonatomic, readonly) CGFloat leftX;
@property (nonatomic, readonly) CGFloat rightX;

@property (nonatomic, readonly) CGFloat topY;
@property (nonatomic, readonly) CGFloat bottomY;

@property (nonatomic, readonly) CGFloat halfWidth;
@property (nonatomic, readonly) CGFloat halfHeight;
@property (nonatomic, readonly) CGPoint center;

@end
