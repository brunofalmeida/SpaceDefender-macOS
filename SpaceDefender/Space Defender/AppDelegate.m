//
//  AppDelegate.m
//  Space Defender
//
//  Created by Bruno on 2015-02-24.
//  Copyright (c) 2015 Bruno Almeida. All rights reserved.
//

#import "AppDelegate.h"

#import "SPDMasterViewController.h"




@implementation AppDelegate

@synthesize window = _window;

#pragma mark - Application Control - Override

/*
 Application setup.
 
 Loads the master view controller and presents the master view.
 */
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Load the master view controller
	self.masterViewController = [[SPDMasterViewController alloc]
								 initWithNibName:@"SPDMasterViewController"
								 bundle:nil];
	
	// Present the master view
	[self.view addSubview:self.masterViewController.view];
}

/*
 Application terminates after the last window is closed.
 Returns YES.
 */
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
