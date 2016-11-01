//
//  SIStep.m
//
//  Created by Laurent Favard on 02/09/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - Octover 5, 2011.


#import "SIStep.h"

@implementation SIStep

@synthesize color;

//---------------------------------------------------------------------------
//	Méthode surchargée init
-(id) init {
	
	self = [super init];
	
	return self;
}
//---------------------------------------------------------------------------
-(id) initWith:(EColor) aColor {

	self = [super init];
	
	self->color = aColor;
	
	return self;
}
//---------------------------------------------------------------------------

@end
