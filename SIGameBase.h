//
//  SIGameBase.m
//
//  Created by Laurent Favard on 02/09/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - Octover 5, 2011.


#import "SIStep.h"

#define	STEP_LEVEL_1	5
#define	STEP_LEVEL_2	10
#define	STEP_LEVEL_3	15

#define	CNT_BUTTONS		4

@interface SIGameBase : NSObject {
	
	@private

	NSInteger		lastIndexForDisplay;

	@protected

	NSMutableArray	*arrayReference;
	NSMutableArray	*arrayPlayer;
	NSInteger		maximumStep;
}

-(void)			GameStartWithLevel:(NSInteger) maxStep;
-(SIStep *)		GameAddStep;
-(SIStep *)		GameGetStepForDisplay;
-(SIStep *)		GameExpectedStep;
-(NSInteger)	GameGetLevelReach;

-(ESpeed)		GameSpeed;

-(bool)			PlayerAddStep:(SIStep *) userStep;
-(bool)			PlayerAddedStepWasLast;


@end
