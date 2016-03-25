//
//  SPDInstructionViewController.m
//  Space Defender
//
//  Created by Bruno on 2015-03-23.
//  Copyright (c) 2015 Bruno Almeida. All rights reserved.
//

#import "SPDInstructionViewController.h"

NSString *const kInstructionViewControllerDismissNotification = @"instructionViewControllerDismiss";




@implementation SPDInstructionViewController

#pragma mark - Interface Actions

/*
 "Start" button press event handler.
 Posts the kInstructionViewControllerDismissNotification in the default notification center.
 */
- (IBAction)startGame:(NSButton *)sender {
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:kInstructionViewControllerDismissNotification
	 object:self];
}

@end
