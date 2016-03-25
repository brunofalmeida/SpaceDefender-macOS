//
//  SPDMainMenuViewController.h
//  Space Defender
//
//  Created by Bruno on 2015-04-18.
//  Copyright (c) 2015 Bruno Almeida. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const kMainMenuViewControllerDismissNotification;




@interface SPDMainMenuViewController : NSViewController

#pragma mark - Interface Actions
- (IBAction)playGame:(NSButton *)sender;

@end
