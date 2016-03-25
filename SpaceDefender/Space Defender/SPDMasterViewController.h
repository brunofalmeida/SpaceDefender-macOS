//
//  SPDMasterViewController.h
//  Space Defender
//
//  Created by Bruno on 2015-04-23.
//  Copyright (c) 2015 Bruno Almeida. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SPDMainMenuViewController;
@class SPDInstructionViewController;
@class SPDGameViewController;
@class SPDGameOverViewController;




@interface SPDMasterViewController : NSViewController

#pragma mark - Subview Controllers
@property SPDMainMenuViewController *mainMenuViewController;
@property SPDInstructionViewController *instructionViewController;
@property SPDGameViewController *gameViewController;
@property SPDGameOverViewController *gameOverViewController;

#pragma mark - View Controller Control - Override
- (void)viewDidLoad;

#pragma mark - Subview Controller Loading
- (void)loadMainMenuViewController;
- (void)loadInstructionViewController;
- (void)loadGameViewController;
- (void)loadGameOverViewController;

#pragma mark - Subview Controller Presentation
- (void)presentMainMenuViewController;

#pragma mark - Subview Controller Transitions
- (void)transitionFromMainMenuViewControllerToInstructionViewController;
- (void)transitionFromInstructionViewControllerToGameViewController;
- (void)transitionFromGameViewControllerToGameOverViewController;

@end
