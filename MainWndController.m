//
//  MainWndController.m
//
//  Created by Laurent on 02/09/11.
//  Copyright 2011 Laurent68k. All rights reserved.
//

#import "MainWndController.h"
#import "SIGameCore.h"

@implementation WndController

-(id) init {
	
	self = [super init];
		
	self->gameCore = [[SIGameCore alloc] initWithDelegate: (id)self];
	
	return self;
}
//---------------------------------------------------------------------------
-(void) dealloc {
		
	[self->gameCore dealloc];
    [super dealloc];
}
//---------------------------------------------------------------------------
- (void)awakeFromNib
{
	[[self window] setTitle:@"OSXSimon"];
	[self->tfResult setStringValue: @""];

	//NSRunInformationalAlertPanel(@" Laurent", @"I proud to present to you my first MacOSX application", @"OK", NULL, NULL);
}
//---------------------------------------------------------------------------
- (void)windowWillClose:(NSNotification *)note {
	
	[NSApp terminate: self ];
}

//---------------------------------------------------------------------------
/*-(void) AddGUIMessage: (NSString *)message {
	
	[self->tfText setStringValue: [NSString stringWithFormat:@"%@\n%@", message, [self->tfText stringValue] ]];
}*/

//---------------------------------------------------------------------------
//	Delegate's public methods invoked by SIGameCore instance
//---------------------------------------------------------------------------

-(id) GUIEndSuccess {

	//NSRunInformationalAlertPanel(@"Simon", @"Congratulation", @"OK", NULL, NULL);
	
	[self->tfResult setStringValue: @"Won !"];
	[self->btGameStart setEnabled: YES];

	return nil;
}
//---------------------------------------------------------------------------
-(id) GUIEndFailed:(id) object {

	/*EColor		color = (EColor)object;
	NSString	*resultat;
	
	switch( color ) {
	
		case kBtBlue:	resultat = [NSString stringWithFormat:@"expected Blue"];
						break;
		case kBtRed:	resultat = [NSString stringWithFormat:@"expected Red"];
						break;
		case kBtGreen:	resultat = [NSString stringWithFormat:@"expected Green"];
						break;
		case kBtYellow:	resultat = [NSString stringWithFormat:@"expected yellow"];
						break;
	}
	NSRunInformationalAlertPanel(@"Simon", resultat, @"OK", NULL, NULL);*/
	
	[self->tfResult setStringValue: @"Game Over"];
	[self->btGameStart setEnabled: YES];

	return nil;
}
//---------------------------------------------------------------------------
//	This method set OFF an objet on the GUI for a given color
-(id) GUIButtonOff:(id) object {

	EColor		color = (EColor)object;
	switch( color ) {
	
		case kBtBlue:	[self->btGameBlue setButtonType:NSMomentaryPushInButton];
						[self->btGameBlue setState: NSOffState];
						break;
			
		case kBtRed:	[self->btGameRed setButtonType:NSMomentaryPushInButton];
						[self->btGameRed setState: NSOffState];
						break;
			
		case kBtGreen:	[self->btGameGreen setButtonType:NSMomentaryPushInButton];
						[self->btGameGreen setState: NSOffState];			
						break;
			
		case kBtYellow:	[self->btGameYellow setButtonType:NSMomentaryPushInButton];
						[self->btGameYellow setState: NSOffState];
						break;
			
		case kBtAll:	[self->btGameBlue setButtonType:NSPushOnPushOffButton];
						[self->btGameRed setButtonType:NSPushOnPushOffButton];
						[self->btGameGreen setButtonType:NSPushOnPushOffButton];
						[self->btGameYellow setButtonType:NSPushOnPushOffButton];
						
						[self->btGameBlue setState: NSOffState];
						[self->btGameRed setState: NSOffState];
						[self->btGameGreen setState: NSOffState];
						[self->btGameYellow setState: NSOffState];
						break;
	}

	return nil;
}
//---------------------------------------------------------------------------
//	This method set ON an objet on the GUI for a given color
-(id) GUIButtonOn:(id) object {

	
	EColor		color = (EColor)object;
	switch( color ) {
	
		case kBtBlue:	[self->btGameBlue setButtonType:NSPushOnPushOffButton];
						[self->btGameBlue setState: NSOnState];
						break;
			
		case kBtRed:	[self->btGameRed setButtonType:NSPushOnPushOffButton];
						[self->btGameRed setState: NSOnState];
						break;
			
		case kBtGreen:	[self->btGameGreen setButtonType:NSPushOnPushOffButton];
						[self->btGameGreen setState: NSOnState];
						break;
			
		case kBtYellow:	[self->btGameYellow setButtonType:NSPushOnPushOffButton];
						[self->btGameYellow setState: NSOnState];
						break;
			
		case kBtAll:	[self->btGameBlue setButtonType:NSPushOnPushOffButton];
						[self->btGameRed setButtonType:NSPushOnPushOffButton];
						[self->btGameGreen setButtonType:NSPushOnPushOffButton];
						[self->btGameYellow setButtonType:NSPushOnPushOffButton];
						
						[self->btGameBlue setState: NSOnState];
						[self->btGameRed setState: NSOnState];
						[self->btGameGreen setState: NSOnState];
						[self->btGameYellow setState: NSOnState];
						break;
	}

	return nil;
}


//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

- (IBAction) btStartClick:(id)sender {

	[self->tfResult setStringValue: @""];
	
	NSInteger	level	=	STEP_LEVEL_1;
	
	level = ( [rbLevel selectedRow] == 0 ? STEP_LEVEL_1 : level);
	level = ( [rbLevel selectedRow] == 1 ? STEP_LEVEL_2 : level);
	level = ( [rbLevel selectedRow] == 2 ? STEP_LEVEL_3 : level);
	
	[self->gameCore Start: level];
	[self->btGameStart setEnabled: NO];
}
//---------------------------------------------------------------------------
- (IBAction) btGameBlue:(id)sender {

	[self->gameCore ActionBlue];
}	
//---------------------------------------------------------------------------
- (IBAction) btGameRed:(id)sender {

	[self->gameCore ActionRed];
}
//---------------------------------------------------------------------------
- (IBAction) btGameGreen:(id)sender {

	[self->gameCore ActionGreen];
}
//---------------------------------------------------------------------------
- (IBAction) btGameYellow:(id)sender {

	[self->gameCore ActionYellow];
}
//---------------------------------------------------------------------------

@end
