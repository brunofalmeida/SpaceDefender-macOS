//
//  AppDelegate.h
//  Space Defender
//

//  Copyright (c) 2015 Bruno Almeida. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>

@class SPDMasterViewController;




@interface AppDelegate : NSObject <NSApplicationDelegate>

#pragma mark - Interface
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSView *view;

#pragma mark - Master View Controller
@property SPDMasterViewController *masterViewController;

#pragma mark - Application Control - Override
- (void)applicationDidFinishLaunching:(NSNotification *)notification;
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender;

@end
