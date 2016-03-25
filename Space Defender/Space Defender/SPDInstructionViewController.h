//
//  SPDInstructionViewController.h
//  Space Defender
//
//  Created by Bruno on 2015-03-23.
//  Copyright (c) 2015 Bruno Almeida. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const kInstructionViewControllerDismissNotification;




@interface SPDInstructionViewController : NSViewController

#pragma mark - Interface Actions
- (IBAction)startGame:(NSButton *)sender;

@end
