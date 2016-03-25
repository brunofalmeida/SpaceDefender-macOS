//
//  SPDGameViewController.m
//  Space Defender
//
//  Created by Bruno on 2015-03-16.
//  Copyright (c) 2015 Bruno Almeida. All rights reserved.
//

#import "SPDGameViewController.h"

#import "GameScene.h"

NSString *const kGameViewControllerDismissNotification = @"gameViewControllerDismiss";




#pragma mark - Scene Unarchiving

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
					  options:NSDataReadingMappedIfSafe
					    error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end




@implementation SPDGameViewController

#pragma mark - Interface Control - Override

/*
 View setup.
 Sets up the game scene.
 */
- (void)viewDidLoad {
    // Call the super method
    [super viewDidLoad];
	
	// Set up the view controller's notification observation
	[self setupNotificationObservation];
	
	// Setup the game scene
	[self setupGameScene];
}

/*
 View presentation.
 
 Makes the skView the first responder in the window.
 */
- (void)viewDidAppear {
	[self.view.window makeFirstResponder:self.skView];
}


#pragma mark - Notification Observation

/*
 Sets up the view controller's notification observation.
 kGameSceneDismissNotification - Forwards the notification by posting a kGameViewControllerDismissNotification to the default notification center.
 */
- (void)setupNotificationObservation {
	[[NSNotificationCenter defaultCenter]
	 addObserverForName:kGameSceneDismissNotification
	 object:nil
	 queue:nil
	 usingBlock:^(NSNotification *note) {
		 [[NSNotificationCenter defaultCenter]
		  postNotificationName:kGameViewControllerDismissNotification object:self];
	 }];
}


#pragma mark - Scene Setup

/*
 Creates, sets up, and presents the game scene in the view.
 */
- (void)setupGameScene {
	// Create the scene
	GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
	
	// Set the scene to scale to fit to the view
	scene.scaleMode = SKSceneScaleModeAspectFit;
	
	// Optimize the view
	self.skView.ignoresSiblingOrder = YES;
	
	// Display debugging stats
//	self.skView.showsFPS = YES;
//	self.skView.showsNodeCount = YES;
	
	// Present the scene in the view
	[self.skView presentScene:scene];
}

@end
