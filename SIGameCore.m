//
//  SIGameCore.m
//
//  Created by Laurent Favard on 02/09/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - Octover 5, 2011.

#import "SIGameCore.h"


@implementation SIGameCore

-(id) initWithDelegate:(id)delegateObject {
	
	self = [super init];
		
	self->delegate = delegateObject;
	
	self->soundPlayerBlue = [NSSound soundNamed:@"simonSound1.mp3"];
	self->soundPlayerRed = [NSSound soundNamed:@"simonSound2.mp3"];
	self->soundPlayerGreen = [NSSound soundNamed:@"simonSound3.mp3"];
	self->soundPlayerYellow = [NSSound soundNamed:@"simonSound4.mp3"];

	return self;
}
//---------------------------------------------------------------------------
-(void) dealloc {
		
	self->timerResponseUser = nil;
	self->timerDisplayReference = nil;
	self->timerDisplayUserStep = nil;
	
	self->timerGameFailed = nil;
	self->timerGameSuccess = nil;
	
	self->soundPlayerBlue = nil;
	self->soundPlayerRed = nil;
	self->soundPlayerGreen = nil;
	self->soundPlayerYellow = nil;
		  
    [super dealloc];
}

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

//	This method set OFF an objet on the GUI for a given color
-(void) DisplayStepOff:(EColor) color {

	//	call delegate
	if ([self->delegate respondsToSelector:@selector(GUIButtonOff:)]) {
	
		[self->delegate performSelector:@selector(GUIButtonOff:) withObject: (id)color];
	}
}
//---------------------------------------------------------------------------
//	This method set ON an objet on the GUI for a given color
-(void) DisplayStepOn:(EColor) color {

	//	call delegate
	if ([self->delegate respondsToSelector:@selector(GUIButtonOn:)]) {
	
		[self->delegate performSelector:@selector(GUIButtonOn:) withObject: (id)color];
	}
}

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

//	Play the sound following the color for it this one is associated. In case of a sound wasn't ended
//	we stop the sound before to play it again.
-(void) PlaySound:(EColor) color {

	switch(color) {
			
		case kBtBlue:
			[self->soundPlayerBlue stop];
			[self->soundPlayerBlue play];
			break;
		case kBtRed:
			[self->soundPlayerRed stop];
			[self->soundPlayerRed play];
			break;
		case kBtGreen:
			[self->soundPlayerGreen stop];
			[self->soundPlayerGreen play];
			break;
		case kBtYellow:
			[self->soundPlayerYellow stop];
			[self->soundPlayerYellow play];
			break;
			
		case kBtAll:
			[self->soundPlayerYellow stop];
			[self->soundPlayerYellow play];
			break;
		
		case kBtFailed:
			[self->soundPlayerBlue stop];
			[self->soundPlayerBlue play];
			break;
	}
}
//---------------------------------------------------------------------------
//	Stop a sound. Used when player press bad color to stop immediatly playing and
//	replace it with the expected color.
-(void) PlaySoundOff:(EColor) color {
	
	switch(color) {
			
		case kBtBlue:
			[self->soundPlayerBlue stop];
			break;
		case kBtRed:
			[self->soundPlayerRed stop];
			break;
		case kBtGreen:
			[self->soundPlayerGreen stop];
			break;
		case kBtYellow:
			[self->soundPlayerYellow stop];
			break;
			
		case kBtAll:
			[self->soundPlayerYellow stop];
			break;
			
		case kBtFailed:
			[self->soundPlayerBlue stop];
			break;
	}
}

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

//	Callback method raised once if it is required to dispplay the next step of the full sequence.
//	If there is no more step, the timer isn't armed again.
- (void)timerFireDisplayAllReference:(NSTimer*)theTimer {
	
	if( [theTimer isValid] ) {
	
		SIStep	*step = [theTimer userInfo];
		
		//	If the timer was raised with a color object, we must switch it to OFF and arm the timer
		if( step != nil ) {
			[self DisplayStepOff: step.color];		
			
			self->timerDisplayReference = [NSTimer scheduledTimerWithTimeInterval: (NSTimeInterval)( 1.0f / [self GameSpeed] ) target:self selector: @selector(timerFireDisplayAllReference:) userInfo: (id)nil repeats: NO];
		}
		//	No object color in the timer methode, we try to find the next one to dispaly
		else {
			SIStep	*step = [self GameGetStepForDisplay];
			//	There is a step to dispay
			if( step != nil ) {
			
				[self DisplayStepOn: step.color];
				[self PlaySound: step.color];
				
				self->timerDisplayReference = [NSTimer scheduledTimerWithTimeInterval: (NSTimeInterval)( 1.0f / [self GameSpeed] ) target:self selector: @selector(timerFireDisplayAllReference:) userInfo: (id)step repeats: NO];
			}
			//	No more step, sequence to show is completed.
			else {
				self->timerDisplayReference = nil;
				self->isDisplayingReference = NO;
				
				[self timerArmPlayerResponse];
			}
		}
	}
}
//---------------------------------------------------------------------------
//	This method display with the help of a timer all sequence that player must reproduce
//	First we just arm the timer and not display anything in order to allow the player
//	to take a break before to see a new sequence with a step added.
-(void) DisplayAllReference {

	self->isDisplayingReference = YES;
	
	self->timerDisplayReference = [NSTimer scheduledTimerWithTimeInterval: (NSTimeInterval)( 1.0f ) target:self selector: @selector(timerFireDisplayAllReference:) userInfo: (id)nil/*step*/ repeats: NO];
}

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

- (void)timerFireGameSuccessMethod:(NSTimer*)theTimer {

	if( [theTimer isValid] ) {
	
		SIStep	*step = [theTimer userInfo];
		
		if( step != nil ) {
			[self DisplayStepOff: step.color];		
			[step release];
			
			self->timerGameSuccess = [NSTimer scheduledTimerWithTimeInterval: (NSTimeInterval)( 0.1f ) target:self selector: @selector(timerFireGameSuccessMethod:) userInfo: (id)nil repeats: NO];
		}
		else {
			
			if( self->flashCount < CNT_SUCCESS ) {

				SIStep	*step = [[SIStep alloc] initWith: kBtAll];
				if( step != nil ) {
			
					[self DisplayStepOn: step.color];
					[self PlaySound: step.color];
					
					self->flashCount++;
					
					self->timerGameSuccess = [NSTimer scheduledTimerWithTimeInterval: (NSTimeInterval)( 0.1f ) target:self selector: @selector(timerFireGameSuccessMethod:) userInfo: (id)step repeats: NO];
				}
			}
			else {
				self->timerGameSuccess = nil;
				self->isDisplayingReference = NO;
				self->flashCount = 0;
			}
		}
	}
}
//---------------------------------------------------------------------------
-(void) GameSuccess {

	self->gameRunning = NO;

	self->timerGameSuccess = [NSTimer scheduledTimerWithTimeInterval: (NSTimeInterval)0.2f target:self selector: @selector(timerFireGameSuccessMethod:) userInfo: (id)nil repeats: NO];

	//	call delegate
	if ([self->delegate respondsToSelector:@selector(GUIEndSuccess)]) {
	
		[self->delegate performSelector:@selector(GUIEndSuccess)];
	}
}

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

- (void)timerFireGameFailedMethod:(NSTimer*)theTimer {

	if( [theTimer isValid] ) {
	
		SIStep	*expectedStep = [theTimer userInfo];
		if( expectedStep != nil ) {
		
			[self DisplayStepOff: expectedStep.color];
		}
	}
	self->timerGameFailed = nil;
}
//---------------------------------------------------------------------------
-(void) GameFailed:(SIStep *) expectedStep {

	self->gameRunning = NO;

	[self DisplayStepOn: expectedStep.color];
	[self PlaySound: kBtFailed];
	
	self->timerGameFailed = [NSTimer scheduledTimerWithTimeInterval: (NSTimeInterval)2.0f target:self selector: @selector(timerFireGameFailedMethod:) userInfo: (id)expectedStep repeats: NO];

	//	call delegate
	if ([self->delegate respondsToSelector:@selector(GUIEndFailed:)]) {
	
		[self->delegate performSelector:@selector(GUIEndFailed:) withObject:(id)expectedStep.color];
	}
}

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

//	Method raised if player didn't press any pad.
- (void)timerFirePlayerResponseMethod:(NSTimer*)theTimer {

	if( [theTimer isValid] ) {
	
		SIStep	*expectedStep = [self GameExpectedStep];
		if( expectedStep != nil ) {
			[self GameFailed: expectedStep];
		}
	}
	self->timerResponseUser = nil;
}
//---------------------------------------------------------------------------
//	Start the maximum time to wait player must respond
-(void) timerArmPlayerResponse {

	self->timerResponseUser = [NSTimer scheduledTimerWithTimeInterval: (NSTimeInterval)2.0f target:self selector: @selector(timerFirePlayerResponseMethod:) userInfo: (id)nil repeats: NO];
}
//---------------------------------------------------------------------------
//	Cancel the maximum player response time timer
-(void) CancelPlayerResponseTimer {

	if( self->timerResponseUser != nil ) {
		[self->timerResponseUser invalidate];
	}
	self->timerResponseUser = nil;
}

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------


//	Display the button player has pressed.
-(void) DisplayUserStepAndContinue:(SIStep *) step {

	if( [self PlayerAddStep: step] ) {
			
		//	If this user step is the last of the current sequence
		if( [self PlayerAddedStepWasLast] ) {
				
			SIStep	*newStep = [self GameAddStep];			
			if( newStep == nil ) {
					
				[self GameSuccess];
			}
			else {
				[self DisplayAllReference];
			}
		}
		else {
			//	play must continue the current sequence
			[self timerArmPlayerResponse];
		}
	}
	else {
		[self DisplayStepOff:step.color];
		[self PlaySoundOff:step.color];
		
		SIStep	*expectedStep = [self GameExpectedStep];
		if( expectedStep != nil ) {
			[self GameFailed: expectedStep];
		}
	}	
	self->userActionInProgress = NO;	
}

//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

- (void) Start:(NSInteger)maxStep {

	[self GameStartWithLevel: maxStep];
	[self DisplayAllReference];
	
	self->flashCount = 0;
	self->gameRunning = YES;
}
//---------------------------------------------------------------------------
- (void) ActionBlue {

	if( ! self->isDisplayingReference && self->gameRunning && !self->userActionInProgress) {
	
		[self CancelPlayerResponseTimer];
	
		self->userActionInProgress = YES;
		SIStep	*step = [[SIStep alloc] initWith:kBtBlue];
			
		[self PlaySound:kBtBlue];

		[self DisplayUserStepAndContinue: step];
		[step release];
	}
}	
//---------------------------------------------------------------------------
- (void) ActionRed{

	if( ! self->isDisplayingReference && self->gameRunning && !self->userActionInProgress) {
	
		[self CancelPlayerResponseTimer];
		
		self->userActionInProgress = YES;
		SIStep	*step = [[SIStep alloc] initWith:kBtRed];

		[self PlaySound:kBtRed];

		[self DisplayUserStepAndContinue: step];
		[step release];
	}
}
//---------------------------------------------------------------------------
- (void) ActionGreen {

	if( ! self->isDisplayingReference && self->gameRunning && !self->userActionInProgress) {
	
		[self CancelPlayerResponseTimer];
		
		self->userActionInProgress = YES;
		SIStep	*step = [[SIStep alloc] initWith:kBtGreen];

		[self PlaySound:kBtGreen];

		[self DisplayUserStepAndContinue: step];
		[step release];
	}
}
//---------------------------------------------------------------------------
- (void) ActionYellow {

	if( ! self->isDisplayingReference && self->gameRunning && !self->userActionInProgress) {
	
		[self CancelPlayerResponseTimer];
		
		self->userActionInProgress = YES;
		SIStep	*step = [[SIStep alloc] initWith:kBtYellow];

		[self PlaySound:kBtYellow];

		[self DisplayUserStepAndContinue: step];
		[step release];
	}
}
//---------------------------------------------------------------------------

@end
