//
//  SIStep.h
//
//  Created by Laurent Favard on 02/09/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//
//	In memory of Steve Jobs, February 24, 1955 - Octover 5, 2011.


typedef enum tagStep { kBtBlue = 0, kBtRed = 1, kBtGreen = 2, kBtYellow = 3, kBtAll = 4, kBtFailed = 5 } EColor;
typedef enum tagSpeed { kDontCare = 0, kSlow = 4, kNormal = 5, kQuick = 6 } ESpeed;

@interface SIStep : NSObject {
	
	@protected

	EColor	color;
}

//	Accessors to the members variables
@property(nonatomic) EColor  color;

-(id) initWith:(EColor) aColor;

@end
