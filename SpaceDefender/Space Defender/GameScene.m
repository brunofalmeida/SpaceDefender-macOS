//
//  GameScene.m
//  Space Defender
//
//  Created by Bruno on 2015-02-24.
//  Copyright (c) 2015 Bruno Almeida. All rights reserved.
//

#import "GameScene.h"

#import "SPDPlayer.h"
#import "SPDEnemy.h"
#import "SPDCharge.h"

NSString *const kGameSceneDismissNotification = @"gameSceneDismissNotification";

/* NSLog control constants */
static const BOOL logLoads = NO;
static const BOOL logAccesses = NO;
static const BOOL logResets = NO;
static const BOOL logCreates = NO;
static const BOOL logTimers = NO;
static const BOOL logPauses = NO;
static const BOOL logUnpauses = NO;
static const BOOL logEvents = NO;
static const BOOL logContacts = NO;
static const BOOL logSounds = NO;

/* SKNode name constants */
static NSString *const playerNodeName = @"Player";
static NSString *const enemyNodeName = @"Enemy";
static NSString *const chargeNodeName = @"Charge";
static NSString *const livesLabelNodeName = @"Lives";
static NSString *const scoreLabelNodeName = @"Score";

/* SKPhysicsBody bitmask constants - categoryBitMask, collisionBitMask, contactTestBitMask */
static const uint32_t playerCategory = 0x1 << 0;
static const uint32_t enemyCategory = 0x1 << 1;
static const uint32_t chargeCategory = 0x1 << 2;

/* Gameplay constants */
static NSInteger const playerAcceleration = 600;
static NSInteger const enemyVerticalSpeed = 150;
static NSInteger const numLivesInitial = 3;

/* Sound constants */
static const BOOL playBackgroundSound = YES;
static const BOOL playExplosionLargeSound = YES;
static const BOOL playExplosionSmallSound = YES;
static const BOOL playLaserShortSound = YES;




@implementation GameScene

#pragma mark - Custom Accessors

/*
 Custom setter.
 
 Ensures that self.score >= 0.
 */
- (void)setScore:(NSInteger)score {
    _score = score;
    
    if (_score < 0) {
		_score = 0;
    }
}

/*
 Custom getter.
 */
- (SPDPlayer *)player {
	if (_player) {
		return _player;
	} else {
		if (logAccesses) {
			NSLog(@"Error: Missing reference to player node.");
		}
		
		return nil;
	}
}

/*
 Custom getter.
 */
- (SKLabelNode *)livesLabel {
	if (_livesLabel) {
		return _livesLabel;
	} else {
		if (logAccesses) {
			NSLog(@"Error: Missing reference to lives label node.");
		}
		
		return nil;
	}
}

/*
 Custom getter.
 */
- (SKLabelNode *)scoreLabel {
	if (_scoreLabel) {
		return _scoreLabel;
	} else {
		if (logAccesses) {
			NSLog(@"Error: Missing reference to score label node.");
		}
		
		return nil;
	}
}


#pragma mark - Scene Control - Override

/*
 View setup.
 
 Initializes the scene properties.
 Loads all of the game sounds.
 Sets up the physics world.
 Creates the essential game nodes.
 Plays the background sound.
 */
- (void)didMoveToView:(SKView *)view {
    // Properties
    self.numLives = numLivesInitial;
    self.score = 0;
	
	// Sounds
	[self loadAllSounds];
    
    // Physics world
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
	
	// Create essential nodes
	[self createPlayer];
	[self createLivesLabel];
	[self createScoreLabel];
	
	// Background sound
	[self playBackgroundSound];
}

/*
 View cleanup.
 
 Stops the background sound.
 */
- (void)willMoveFromView:(SKView *)view {
	[self.backgroundSound stop];
}


#pragma mark - Sounds

/*
 Loads and initializes all sound properties.
 */
- (void)loadAllSounds {
	// Background sound - loops forever
	self.backgroundSound = [NSSound soundNamed:@"Background"];
	if (!self.backgroundSound) {
		if (logLoads) {
			NSLog(@"Error: Load of backgroundSound failed");
		}
	}
	self.backgroundSound.volume = 1.0;
	self.backgroundSound.loops = YES;
	
	// Large explosion sound
	self.explosionLargeSound = [NSSound soundNamed:@"Explosion - Large"];
	if (!self.explosionLargeSound) {
		if (logLoads) {
			NSLog(@"Error: Load of explosionLargeSound failed");
		}
	}
	self.explosionLargeSound.volume = 1.0;
	
	// Small explosion sound
	self.explosionSmallSound = [NSSound soundNamed:@"Explosion - Small"];
	if (!self.explosionSmallSound) {
		if (logLoads) {
			NSLog(@"Error: Load of explosionSmallSound failed");
		}
	}
	self.explosionSmallSound.volume = 1.0;
	
	// Short laser sound
	self.laserShortSound = [NSSound soundNamed:@"Laser - Short"];
	if (!self.laserShortSound) {
		if (logLoads) {
			NSLog(@"Error: Load of laserShortSound failed");
		}
	}
	self.laserShortSound.volume = 1.0;
}

/*
 Plays the backgroundSound, which loops forever.
 */
- (void)playBackgroundSound {
	if (playBackgroundSound) {
		// Stop the sound if it's already playing
		[self.backgroundSound stop];
		
		// Play the sound, and check for success or failure
		if ([self.backgroundSound play]) {
			if (logSounds) {
				NSLog(@"Sound playback of backgroundSound");
			}
		} else {
			if (logSounds) {
				NSLog(@"Error: Sound playback of backgroundSound failed");
			}
		}
	}
}


#pragma mark - Keyboard Event Handlers

/*
 Key down event handler.
 
 Delegates the event handling to the key down event helper methods.
 
 Left arrow
 Right arrow
 Space bar
 */
- (void)keyDown:(NSEvent *)theEvent {
    // Get the keys pressed
    NSString *characters = [theEvent charactersIgnoringModifiers];
    
    // For each key pressed
    for (int i = 0; i < [characters length]; i++) {
		unichar character = [characters characterAtIndex:i];
		
		// Left arrow down
		if (character == NSLeftArrowFunctionKey) {
			[self keyDownLeftArrow];
		}
		
		// Right arrow down
		else if (character == NSRightArrowFunctionKey) {
			[self keyDownRightArrow];
		}
		
		// Space bar down
		else if (character == ' ') {
			[self keyDownSpaceBar];
		}
    }
}

/*
 Left arrow key down event handler.
 
 Makes the player accelerate left.
 */
- (void)keyDownLeftArrow {
	if (logEvents) {
		NSLog(@"Event: Left arrow down");
	}
	
	SPDPlayer *player = self.player;
	if (player) {
		player.isAcceleratingLeft = YES;
	}
}

/*
 Right arrow key down event handler.
 
 Makes the player accelerate right.
 */
- (void)keyDownRightArrow {
	if (logEvents) {
		NSLog(@"Event: Right arrow down");
	}
	
	SPDPlayer *player = self.player;
	if (player) {
		player.isAcceleratingRight = YES;
	}
}

/*
 Space bar key down event handler.
 
 Fires a charge and plays the short laser sound.
 */
- (void)keyDownSpaceBar {
	if (logEvents) {
		NSLog(@"Event: Space bar down");
	}
	
	// Create a charge to fire
	[self createCharge];
	
	// Play the short laser sound
	if (playLaserShortSound) {
		[self.laserShortSound stop];
		
		if ([self.laserShortSound play]) {
			if (logSounds) {
				NSLog(@"Sound playback of laserShortSound");
			}
		} else {
			if (logSounds) {
				NSLog(@"Error: Sound playback of laserShortSound failed");
			}
		}
	}
}

/*
 Key up event handler.
 
 Delegates the event handling to the key up event helper methods.
 
 Left arrow
 Right arrow
 */
- (void)keyUp:(NSEvent *)theEvent {
    // Get the keys pressed
    NSString *characters = [theEvent charactersIgnoringModifiers];
    
    // For each key pressed
    for (int i = 0; i < [characters length]; i++) {
		unichar character = [characters characterAtIndex:i];
		
		// Left arrow up
		if (character == NSLeftArrowFunctionKey) {
			[self keyUpLeftArrow];
		}
		
		// Right arrow up
		else if (character == NSRightArrowFunctionKey) {
			[self keyUpRightArrow];
		}
    }
}

/*
 Left arrow key up event handler.
 
 Stops the player from accelerating left.
 */
- (void)keyUpLeftArrow {
	if (logEvents) {
		NSLog(@"Event: Left arrow up");
	}
	
	SPDPlayer *player = self.player;
	if (player) {
		player.isAcceleratingLeft = NO;
	}
}

/*
 Right arrow key up event handler.
 
 Stops the player from accelerating right.
 */
- (void)keyUpRightArrow {
	if (logEvents) {
		NSLog(@"Event: Right arrow up");
	}
	
	SPDPlayer *player = self.player;
	if (player) {
		player.isAcceleratingRight = NO;
	}
}


#pragma mark - Physics Contact Event Handlers

/*
 Physics contact delegate method.
 
 Delegates the event handling to the physics contact event helper methods.
 
 Handles the following contacts:
 Player and enemy
 Enemy and charge
 */
- (void)didBeginContact:(SKPhysicsContact *)contact {
	// If both nodes still exist
    if (contact.bodyA.node && contact.bodyB.node) {
		// Put the two physics bodies in order by category
		SKPhysicsBody *firstBody;   // Lower category
		SKPhysicsBody *secondBody;  // Higher category
		
		if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
			firstBody = contact.bodyA;
			secondBody = contact.bodyB;
		} else {
			firstBody = contact.bodyB;
			secondBody = contact.bodyA;
		}
		
		if (logContacts) {
			NSLog(@"Contact: %@ and %@", firstBody.node.name, secondBody.node.name);
		}
		
		// Player and enemy
		if (firstBody.categoryBitMask == playerCategory && secondBody.categoryBitMask == enemyCategory) {
			[self player:firstBody.node didContactEnemy:secondBody.node];
		}
		
		// Enemy and charge
		else if (firstBody.categoryBitMask == enemyCategory && secondBody.categoryBitMask == chargeCategory) {
			[self enemy:firstBody.node didContactCharge:secondBody.node];
		}
    }
}

/*
 Physics contact event handler for player and enemy nodes.
 
 Removes a life.
 Resets nodes.
 Plays the large explosion sound.
 Pauses the view for 2 seconds.
 */
- (void)player:(SKNode *)player didContactEnemy:(SKNode *)enemy {
    // Remove a life
    self.numLives -= 1;
	
	// Update the lives label
	[self updateLivesLabel];
    
    // Reset the node graph
    [self resetNodes];
    
    // Play the large explosion sound
    if (playExplosionLargeSound) {
		[self.explosionLargeSound stop];
		
		if ([self.explosionLargeSound play]) {
			if (logSounds) {
				NSLog(@"Sound playback of explosionLargeSound");
			}
		} else {
			if (logSounds) {
				NSLog(@"Error: Sound playback of explosionLargeSound failed");
			}
		}
    }
    
	// If the view is not paused
    if (![self isViewPaused]) {
		// Pause the view
		[self pauseView];
		
		// Set the timer to unpause the view
		[self setUnpauseViewTimer];
    }
}

/*
 Physics contact event handler for enemy and charge nodes.
 
 Removes both nodes from the node graph.
 Plays the explosionSmallSound.
 Increases the score by 100.
 Updates the score label.
 */
- (void)enemy:(SKNode *)enemy didContactCharge:(SKNode *)charge {
    // Remove both nodes from the node graph
    [NSObject cancelPreviousPerformRequestsWithTarget:enemy];
    [enemy removeFromParent];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:charge];
    [charge removeFromParent];
    
    // Play small explosion sound
    if (playExplosionSmallSound) {
		[self.explosionSmallSound stop];
		
		if ([self.explosionSmallSound play]) {
			if (logSounds) {
				NSLog(@"Sound playback of explosionSmallSound");
			}
		} else {
			if (logSounds) {
				NSLog(@"Error: Sound playback of explosionSmallSound failed");
			}
		}
    }
    
    // Increase the score by 100
    self.score += 100;
    
    // Update the score label
    [self updateScoreLabel];
}


#pragma mark - Frame Update

/*
 Updates the player's velocity.
 Randomly chooses whether to create an enemy (1/120 probability).
 Updates the lastUpdateTimeInterval property.
 */
- (void)update:(NSTimeInterval)currentTime {
    // If the last update time property has been set
    if (self.lastUpdateTimeInterval) {
		// Calculate the time elapsed since the last update (in seconds)
		NSTimeInterval elapsedTimeInterval = currentTime - self.lastUpdateTimeInterval;
		
		// Update player's velocity
		SPDPlayer *player = self.player;
		if (player) {
			CGVector currentVelocity = player.physicsBody.velocity;
			NSInteger horizontalAccelerationDirection = player.horizontalAccelerationDirection;
			
			// If the player is horizontally out of view and its velocity is in that direction, set the x velocity to 0
			if ((CGRectGetMaxX(player.frame) < 0 && currentVelocity.dx < 0) || (CGRectGetMinX(player.frame) > self.frame.size.width && currentVelocity.dx > 0)) {
				player.physicsBody.velocity = CGVectorMake(0, currentVelocity.dy);
			}
			
			// If the player is touching the edge of view and its accelerating is in that direction, divide the x velocity by 1.15
			else if ((CGRectGetMinX(player.frame) < 0 && (int)horizontalAccelerationDirection <= 0) || (CGRectGetMaxX(player.frame) > self.frame.size.width && (int)horizontalAccelerationDirection >= 0)) {
				player.physicsBody.velocity = CGVectorMake(currentVelocity.dx / 1.15, currentVelocity.dy);
			}
			
			// If the current horizontal velocity and horizontal acceleration are in opposite directions, double the acceleration
			else if ( (currentVelocity.dx < 0 && horizontalAccelerationDirection > 0) || (currentVelocity.dx > 0 && horizontalAccelerationDirection < 0) ) {
				player.physicsBody.velocity = CGVectorMake(currentVelocity.dx + 2 * horizontalAccelerationDirection * playerAcceleration * elapsedTimeInterval, currentVelocity.dy);
			}
			
			// If the current horizontal velocity and horizontal acceleration are in the same direction, use normal acceleration
			else {
				player.physicsBody.velocity = CGVectorMake(currentVelocity.dx + horizontalAccelerationDirection * playerAcceleration * elapsedTimeInterval, currentVelocity.dy);
			}
		}
    }
    
    // Update the last update time property
    self.lastUpdateTimeInterval = currentTime;
    
    // Randomly choose whether to create an enemy
    if (random() % 60 == 0) {
		[self createRandomEnemy];
    }
	
	// Check if the player has lost
	if ([self hasPlayerLost]) {
		[self pauseView];
	}
}


#pragma mark - View Pausing

/*
 Returns the view's paused property.
 */
- (BOOL)isViewPaused {
    return self.view.paused;
}

/*
 Sets the view's paused property to YES.
 */
- (void)pauseView {
    if (logPauses) {
		NSLog(@"Pause view");
    }
    
    self.view.paused = YES;
}

/*
 Sets the view's paused property to NO.
 */
- (void)unpauseView {
    if (logUnpauses) {
		NSLog(@"Unpause view");
    }
    
    self.view.paused = NO;
}


#pragma mark - Unpause View Timer

/*
 Sets a 2-second timer which will unpause the view.
 */
- (void)setUnpauseViewTimer {
    if (logTimers) {
		NSLog(@"Timer set to unpause view");
    }
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(unpauseView) userInfo:nil repeats:NO];
}


#pragma mark - Node Reset

/*
 Removes all non-essential nodes.
 Essential nodes include the player, lives label, and score label.
 */
- (void)resetNodes {
    if (logResets) {
		NSLog(@"Reset nodes");
    }
    
    // Remove all non-essential nodes, and the player node
    for (SKNode *node in self.children) {
		if ([@[livesLabelNodeName, scoreLabelNodeName] indexOfObject:node.name] == NSNotFound) {
			[NSObject cancelPreviousPerformRequestsWithTarget:node];
			[node removeFromParent];
		}
    }
	
	// Recreate the player node
	[self createPlayer];
}


#pragma mark - Node Creation

/*
 Creates and adds a player node in the bottom centre of the scene.
 */
- (void)createPlayer {
    if (logCreates) {
		NSLog(@"Create player");
    }
    
    SPDPlayer *player = [[SPDPlayer alloc] initWithImageNamed:@"Spaceship"];
    
    player.name = playerNodeName;
    
    player.scale = 0.25;
    player.position = CGPointMake(CGRectGetMidX(self.frame), player.frame.size.height / 2);
    
    player.physicsBody = [SKPhysicsBody bodyWithTexture:player.texture size:player.frame.size];
    player.physicsBody.velocity = CGVectorMake(0, 0);
    player.physicsBody.linearDamping = 1.0;
    player.physicsBody.categoryBitMask = playerCategory;
    player.physicsBody.collisionBitMask = 0x0;
    player.physicsBody.contactTestBitMask = enemyCategory;
    
    [self addChild:player];
	
	self.player = player;
}

/*
 Creates an enemy node at the top of the scene at a random horizontal location.
 */
- (void)createRandomEnemy {
    if (logCreates) {
		NSLog(@"Create enemy");
    }
    
    SPDEnemy *enemy = [[SPDEnemy alloc] initWithImageNamed:@"Spaceship"];
    
    enemy.name = enemyNodeName;
    
    CGFloat enemyWidth = enemy.frame.size.width;
    CGFloat xPos = random() % (long)(self.size.width - enemyWidth) + (enemyWidth / 2);
    
    enemy.scale = 0.2;
    enemy.zRotation = M_PI;
    enemy.position = CGPointMake(xPos, CGRectGetMaxY(self.frame));
    
    enemy.color = [NSColor redColor];
    enemy.colorBlendFactor = 0.5;
    
    enemy.physicsBody = [SKPhysicsBody bodyWithTexture:enemy.texture size:enemy.frame.size];
    enemy.physicsBody.velocity = CGVectorMake(0, -enemyVerticalSpeed);
    enemy.physicsBody.linearDamping = 0.0;
    enemy.physicsBody.categoryBitMask = enemyCategory;
    enemy.physicsBody.collisionBitMask = 0x0;
    enemy.physicsBody.contactTestBitMask = playerCategory | chargeCategory;
    
    [self addChild:enemy];
}

/*
 Creates a charge node at the player's position (top centre of player's frame).
 */
- (void)createCharge {
    if (logCreates) {
		NSLog(@"Create charge");
    }
    
    SPDCharge *charge = [[SPDCharge alloc] initWithColor:[NSColor yellowColor] size:CGSizeMake(1, 40)];
    
    charge.name = chargeNodeName;
    
    SPDPlayer *player = self.player;
    if (player) {
		charge.position = CGPointMake(CGRectGetMidX(player.frame), CGRectGetMaxY(player.frame) + charge.frame.size.height / 2);
    }
    
    charge.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:charge.frame.size];
    charge.physicsBody.velocity = CGVectorMake(0, 1500);
    charge.physicsBody.linearDamping = 0.0;
    charge.physicsBody.categoryBitMask = chargeCategory;
    charge.physicsBody.collisionBitMask = 0x0;
    charge.physicsBody.contactTestBitMask = enemyCategory;
    
    [self addChild:charge];
}

/*
 Creates a lives label node in the top left of the scene.
 */
- (void)createLivesLabel {
    SKLabelNode *livesLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
    
    livesLabel.name = livesLabelNodeName;
    
    livesLabel.fontSize = 36;
    livesLabel.fontColor = [NSColor whiteColor];
    
    livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    livesLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    
    livesLabel.position = CGPointMake(20, self.frame.size.height - 20);
    
    livesLabel.text = [NSString stringWithFormat:@"Lives: %ld", (long)self.numLives];
    
    [self addChild:livesLabel];
	
	self.livesLabel = livesLabel;
}

/*
 Creates a score label node in the top right of the scene.
 */
- (void)createScoreLabel {
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
    
    scoreLabel.name = scoreLabelNodeName;
    
    scoreLabel.fontSize = 36;
    scoreLabel.fontColor = [NSColor whiteColor];
    
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    
    scoreLabel.position = CGPointMake(self.frame.size.width - 20, self.frame.size.height - 20);
    
    scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.score];
    
    [self addChild:scoreLabel];
	
	self.scoreLabel = scoreLabel;
}


#pragma mark - Node Update

/*
 Updates the lives label's text.
 */
- (void)updateLivesLabel {
    self.livesLabel.text = [NSString stringWithFormat:@"Lives: %ld", (long)self.numLives];
}

/*
 Updates the score label's text.
 */
- (void)updateScoreLabel {
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.score];
}


#pragma mark - Game State

/*
 If the player has lost, returns YES and posts the kGameSceneDismissNotification in the default notification center.
 Otherwise, returns NO.
 
 The player is considered to have lost if the number of lives <= 0.
 */
- (BOOL)hasPlayerLost {
    if (self.numLives <= 0) {
		[[NSNotificationCenter defaultCenter]
		 postNotificationName:kGameSceneDismissNotification
		 object:self];
		
		return YES;
    } else {
		return NO;
    }
}

@end
