//
//  SIGameBase.m
//
//  Created by Laurent Favard on 02/09/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - Octover 5, 2011.

#include <stdlib.h>
#import "SIGameBase.h"

@implementation SIGameBase

//---------------------------------------------------------------------------
//	Méthode surchargée init
-(id) init {
	
	self = [super init];
	
	arrayReference = [[NSMutableArray alloc] init];
	arrayPlayer = [[NSMutableArray alloc] init];
	
	return self;
}
//---------------------------------------------------------------------------
-(void) dealloc {

	[arrayReference release];
	[arrayPlayer release];
	
	[super dealloc];
}
//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------
-(void) GameStartWithMaxStep:(NSInteger) maxStep {

	NSInteger index = 0;
	
	for( index = 0; index < [self->arrayReference count]; index++ ) {
	
		[self->arrayReference removeObjectAtIndex: index];
	}
	
	for( index = 0; index < [self->arrayPlayer count]; index++ ) {
	
		[self->arrayPlayer removeObjectAtIndex: index];
	}

	[self->arrayReference removeAllObjects];
	[self->arrayPlayer removeAllObjects];
	
	self->maximumStep = maxStep;
	self->lastIndexForDisplay = 0;	
}
//---------------------------------------------------------------------------
-(int) ComputeSpeed {

	int		speed = kSlow;
	
	speed = ( [self->arrayReference count] < STEP_LEVEL_1 ? kSlow : speed);
	speed = ( [self->arrayReference count] < STEP_LEVEL_2 ? kNormal : speed);
	speed = ( [self->arrayReference count] < STEP_LEVEL_3 ? kQuick: speed);
	
	return speed;
}
//---------------------------------------------------------------------------
-(SIStep *) GameAddStep {

	SIStep	*newStep = nil;
	
	if( [self->arrayReference count] < self->maximumStep ) {
	
		int		newRandomColor = arc4random() % CNT_BUTTONS;
		 
		newStep = [[SIStep alloc] initWith: newRandomColor /*speed: [self ComputeSpeed]*/ ];
	
		[self->arrayReference addObject: newStep];
	}
	
	[self->arrayPlayer removeAllObjects];
	
	return newStep;
}
//---------------------------------------------------------------------------
-(SIStep *) GameGetStepAtIndex:(NSInteger) index {

	SIStep	*refStep = nil;
	
	if( index < [self->arrayReference count] ) {
	
		refStep = [self->arrayReference objectAtIndex: index];
	}
	
	return refStep;
}

//---------------------------------------------------------------------------
//	public entries for run the game
//---------------------------------------------------------------------------

-(void) GameStartWithLevel:(NSInteger) maxStep {

	[self GameStartWithMaxStep: maxStep];
	[self GameAddStep];
}
//---------------------------------------------------------------------------
-(SIStep *) GameGetStepForDisplay {

	SIStep	*refStep = [self GameGetStepAtIndex: self->lastIndexForDisplay++];
	if( refStep == nil ) {
	
		self->lastIndexForDisplay = 0;
	}
	return refStep;
}
//---------------------------------------------------------------------------
-(bool) PlayerAddStep:(SIStep *) userLastStep {

	bool	ret = NO;

	//	get the index of the last user step
	NSInteger	lastIndex = [self->arrayPlayer count];

	SIStep	*refLastStep = [self->arrayReference objectAtIndex: lastIndex ];
	if( refLastStep.color == userLastStep.color ) {
	
		//	Add the new last user step: retain object allocated outside of this method
		[userLastStep retain];
		[self->arrayPlayer addObject: userLastStep];

		//	ok, last user step have the same color than the reference
		ret = YES;
	}
	
	return ret;
}
//---------------------------------------------------------------------------
-(bool) PlayerAddedStepWasLast {
	
	return [self->arrayPlayer count] == [self->arrayReference count];
}
//---------------------------------------------------------------------------
-(SIStep *)GameExpectedStep {
	
	//	get the index of the last user step
	NSInteger	lastIndex = [self->arrayPlayer count];

	return [self GameGetStepAtIndex:lastIndex];
}
//---------------------------------------------------------------------------
-(NSInteger) GameGetLevelReach {

	return [self->arrayReference count];
}
//---------------------------------------------------------------------------
-(ESpeed) GameSpeed {

	ESpeed	speed = kSlow;
	
	speed = ( [self->arrayReference count] > STEP_LEVEL_1 ? kNormal : kSlow );
	speed = ( [self->arrayReference count] > STEP_LEVEL_2 ? kQuick : speed);

	return speed;
}
//---------------------------------------------------------------------------

@end
