//
//  MainWndController.h
//
//  Created by Laurent on 02/09/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - Octover 5, 2011.

#import <Cocoa/Cocoa.h>
#import "SIGameCore.h"

@interface WndController : NSWindowController {

	@protected

	//	GUI buttons and others
	IBOutlet NSMatrix		*rbLevel;
	IBOutlet NSButton		*btGameStart;
	
	IBOutlet NSButton		*btGameBlue;	
	IBOutlet NSButton		*btGameRed;	
	IBOutlet NSButton		*btGameGreen;	
	IBOutlet NSButton		*btGameYellow;	

	IBOutlet NSTextField	*tfResult;
	
	SIGameCore				*gameCore;
}

//	Methods GUI binded to IB
- (IBAction) btStartClick:(id)sender;
- (IBAction) btGameBlue:(id)sender;
- (IBAction) btGameRed:(id)sender;
- (IBAction) btGameGreen:(id)sender;
- (IBAction) btGameYellow:(id)sender;

//	Methods exposed as delegate
-(id) GUIEndSuccess;
-(id) GUIEndFailed:(id) color;
-(id) GUIButtonOff:(id) color;
-(id) GUIButtonOn:(id) color;

@end
