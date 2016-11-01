//
//  SIGameCore.h
//
//  Created by Laurent Favard on 02/09/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - Octover 5, 2011.

#import <Cocoa/Cocoa.h>
#import "SIGameBase.h"

#define	CNT_SUCCESS	3

@interface SIGameCore : SIGameBase {

	@protected

	id						delegate;

	bool					gameRunning;
	bool					isDisplayingReference;
	bool					userActionInProgress;
	
	NSTimer					*timerResponseUser;
	NSTimer					*timerDisplayReference;
	NSTimer					*timerDisplayUserStep;

	NSTimer					*timerGameFailed;
	NSTimer					*timerGameSuccess;
	
	NSSound					*soundPlayerBlue;
	NSSound					*soundPlayerRed;
	NSSound					*soundPlayerGreen;
	NSSound					*soundPlayerYellow;
	
	int						flashCount;
}

- (id) initWithDelegate:(id)delegateObject;

-(void) timerArmPlayerResponse;

- (void) Start:(NSInteger)maxStep;
- (void) ActionBlue;
- (void) ActionRed;
- (void) ActionGreen;
- (void) ActionYellow;


@end
