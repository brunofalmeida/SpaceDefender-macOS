//
//  SPDPlayer.h
//  Space Defender
//
//  Created by Bruno on 2015-03-18.
//  Copyright (c) 2015 Bruno Almeida. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@interface SPDPlayer : SKSpriteNode

/* Horizontal acceleration directions */
@property BOOL isAcceleratingLeft;
@property BOOL isAcceleratingRight;

/*
 Indicates direction of acceleration.
 Determined using isAcceleratingLeft and isAcceleratingRight properties.
 
 -1 = left
  0 = none
  1 = right
 */
@property (readonly) NSInteger horizontalAccelerationDirection;

/* Initializer */
- (instancetype)initWithImageNamed:(NSString *)name;

@end
