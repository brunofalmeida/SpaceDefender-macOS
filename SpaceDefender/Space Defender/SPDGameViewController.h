//
//  SPDGameViewController.h
//  Space Defender
//
//  Created by Bruno on 2015-03-16.
//  Copyright (c) 2015 Bruno Almeida. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>

extern NSString *const kGameViewControllerDismissNotification;




@interface SPDGameViewController : NSViewController

#pragma mark - Interface
@property (weak) IBOutlet SKView *skView;

#pragma mark - Interface Control - Override
- (void)viewDidLoad;
- (void)viewDidAppear;

#pragma mark - Notification Observation
- (void)setupNotificationObservation;

#pragma mark - Scene Setup
- (void)setupGameScene;

@end
