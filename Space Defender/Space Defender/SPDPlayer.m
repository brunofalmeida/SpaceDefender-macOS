//
//  SPDPlayer.m
//  Space Defender
//
//  Created by Bruno on 2015-03-18.
//  Copyright (c) 2015 Bruno Almeida. All rights reserved.
//

#import "SPDPlayer.h"


@implementation SPDPlayer

/*
 Returns an integer describing the player's horizontal acceleration direction.
 */
- (NSInteger)horizontalAccelerationDirection {
    return (int)self.isAcceleratingRight - (int)self.isAcceleratingLeft;
}


/*
 Designated initializer.
 */
- (instancetype)initWithImageNamed:(NSString *)name {
    self = [super initWithImageNamed:name];
    
    if (self) {
		_isAcceleratingLeft = NO;
		_isAcceleratingRight = NO;
    }
    
    return self;
}

@end
