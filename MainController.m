//
//  MainController.m
//  Spin
//
//  Created by 石崎 徹 on 11/02/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainController.h"


@implementation MainController
-(void)awakeFromNib{
	[window setFrameAutosaveName:@"MainFrame"];
	[window setStyleMask:NSBorderlessWindowMask];//////
	[window setOpaque:NO];
	[window setBackgroundColor:[NSColor clearColor]];
	//[window setMovableByWindowBackground:YES];
	[window setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
	[window makeKeyAndOrderFront:self];
	
}

@end
