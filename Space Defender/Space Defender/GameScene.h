//
//  GameScene.h
//  Space Defender
//

//  Copyright (c) 2015 Bruno Almeida. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <stdlib.h>

@class SPDPlayer;

extern NSString *const kGameSceneDismissNotification;




@interface GameScene : SKScene <SKPhysicsContactDelegate>

#pragma mark - Time
// Time of last call to -update:
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

#pragma mark - Player Statistics
@property (nonatomic) NSInteger numLives;
@property (nonatomic) NSInteger score;

#pragma mark - Sounds
@property (nonatomic) NSSound *backgroundSound;
@property (nonatomic) NSSound *explosionLargeSound;
@property (nonatomic) NSSound *explosionSmallSound;
@property (nonatomic) NSSound *laserShortSound;

#pragma mark - Key Child Nodes
@property (nonatomic, weak) SPDPlayer *player;
@property (nonatomic, weak) SKLabelNode *livesLabel;
@property (nonatomic, weak) SKLabelNode *scoreLabel;

#pragma mark - Scene Control - Override
- (void)didMoveToView:(SKView *)view;
- (void)willMoveFromView:(SKView *)view;

#pragma mark - Sounds
- (void)loadAllSounds;
- (void)playBackgroundSound;

#pragma mark - Keyboard Event Handlers
- (void)keyDown:(NSEvent *)theEvent;

- (void)keyDownLeftArrow;
- (void)keyDownRightArrow;
- (void)keyDownSpaceBar;

- (void)keyUp:(NSEvent *)theEvent;

- (void)keyUpLeftArrow;
- (void)keyUpRightArrow;

#pragma mark - Physics Contact Event Handlers
- (void)didBeginContact:(SKPhysicsContact *)contact;
- (void)player:(SKNode *)player didContactEnemy:(SKNode *)enemy;
- (void)enemy:(SKNode *)enemy didContactCharge:(SKNode *)charge;

#pragma mark - Frame Update
- (void)update:(NSTimeInterval)currentTime;

#pragma mark - View Pausing
- (BOOL)isViewPaused;
- (void)pauseView;
- (void)unpauseView;

#pragma mark - Unpause View Timer
- (void)setUnpauseViewTimer;

#pragma mark - Node Reset
- (void)resetNodes;

#pragma mark - Node Creation
- (void)createPlayer;
- (void)createRandomEnemy;
- (void)createCharge;
- (void)createLivesLabel;
- (void)createScoreLabel;

#pragma mark - Node Update
- (void)updateLivesLabel;
- (void)updateScoreLabel;

#pragma mark - Game State
- (BOOL)hasPlayerLost;

@end
