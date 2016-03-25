//
//  SPDMasterViewController.m
//  Space Defender
//
//  Created by Bruno on 2015-04-23.
//  Copyright (c) 2015 Bruno Almeida. All rights reserved.
//

#import "SPDMasterViewController.h"

#import "SPDMainMenuViewController.h"
#import "SPDInstructionViewController.h"
#import "SPDGameViewController.h"
#import "SPDGameOverViewController.h"




@implementation SPDMasterViewController

#pragma mark - View Controller Control - Override

/*
 Called after the view has been loaded.
 
 Loads all of the subview controllers.
 Presents the main menu view controller.
 Registers notification observations for subview controller transitions.
 */
- (void)viewDidLoad {
	// Call super method
    [super viewDidLoad];
	
	// Load all of the subview controllers
	[self loadMainMenuViewController];
	[self loadInstructionViewController];
	[self loadGameViewController];
	[self loadGameOverViewController];
	
	// Present the main menu view controller as the initial view
	[self presentMainMenuViewController];
	
	// Register notifications for subview controller transitions
	
	// Main menu view to instruction view
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(transitionFromMainMenuViewControllerToInstructionViewController)
	 name:kMainMenuViewControllerDismissNotification
	 object:nil];
	
	// Instruction view to game view
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(transitionFromInstructionViewControllerToGameViewController)
	 name:kInstructionViewControllerDismissNotification
	 object:nil];
	
	// Game view to game over view
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(transitionFromGameViewControllerToGameOverViewController)
	 name:kGameViewControllerDismissNotification
	 object:nil];
}


#pragma mark - Subview Controller Loading

/*
 If mainMenuViewController is nil, loads and initializes it, adding the view controller as a child view controller.
 */
- (void)loadMainMenuViewController {
	if (!self.mainMenuViewController) {
		self.mainMenuViewController = [[SPDMainMenuViewController alloc]
									   initWithNibName:@"SPDMainMenuView"
									   bundle:nil];
		[self addChildViewController:self.mainMenuViewController];
	}
}

/*
 If instructionViewController is nil, loads and initializes it, adding the view controller as a child view controller.
 */
- (void)loadInstructionViewController {
	if (!self.instructionViewController) {
		self.instructionViewController = [[SPDInstructionViewController alloc]
										  initWithNibName:@"SPDInstructionView"
										  bundle:nil];
		[self addChildViewController:self.instructionViewController];
	}
}

/*
 If gameViewController is nil, loads and initializes it, adding the view controller as a child view controller.
 */
- (void)loadGameViewController {
	if (!self.gameViewController) {
		self.gameViewController = [[SPDGameViewController alloc]
								   initWithNibName:@"SPDGameView"
								   bundle:nil];
		[self addChildViewController:self.gameViewController];
	}
}

/*
 If gameOverViewController is nil, loads and initializes it, adding the view controller as a child view controller.
 */
- (void)loadGameOverViewController {
	if (!self.gameOverViewController) {
		self.gameOverViewController = [[SPDGameOverViewController alloc]
									   initWithNibName:@"SPDGameOverView"
									   bundle:nil];
		[self addChildViewController:self.gameOverViewController];
	}
}


#pragma mark - Subview Controller Presentation

/*
 Adds mainMenuViewController's view as a subview.
 */
- (void)presentMainMenuViewController {
	[self.view addSubview:self.mainMenuViewController.view];
}


#pragma mark - Subview Controller Transitions

/*
 Transitions from mainMenuViewController to instructionViewController.
 */
- (void)transitionFromMainMenuViewControllerToInstructionViewController {
	[self transitionFromViewController:self.mainMenuViewController
					  toViewController:self.instructionViewController
							   options:NSViewControllerTransitionNone
					 completionHandler:nil];
}

/*
 Transitions from instructionViewController to gameViewController.
 */
- (void)transitionFromInstructionViewControllerToGameViewController {
	[self transitionFromViewController:self.instructionViewController
					  toViewController:self.gameViewController
							   options:NSViewControllerTransitionNone
					 completionHandler:nil];
}

/*
 Transitions from gameViewController to gameOverViewController.
 */
- (void)transitionFromGameViewControllerToGameOverViewController {
	[self transitionFromViewController:self.gameViewController
					  toViewController:self.gameOverViewController
							   options:NSViewControllerTransitionNone
					 completionHandler:nil];
}

@end
