//
//  SPDMainMenuViewController.m
//  Space Defender
//
//  Created by Bruno on 2015-04-18.
//  Copyright (c) 2015 Bruno Almeida. All rights reserved.
//

#import "SPDMainMenuViewController.h"

NSString *const kMainMenuViewControllerDismissNotification = @"mainMenuViewControllerDismiss";




@implementation SPDMainMenuViewController

#pragma mark - Interface Actions

/*
 "Play" button press event handler.
 Posts the kMainMenuViewControllerDismissNotification in the default notification center.
 */
- (IBAction)playGame:(NSButton *)sender {
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:kMainMenuViewControllerDismissNotification
	 object:self];
}

@end
