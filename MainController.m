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
	//[window setFrameAutosaveName:@"MainWindow"];
	[window setStyleMask:NSBorderlessWindowMask];//////
	[window setOpaque:NO];
	[window setBackgroundColor:[NSColor clearColor]];
	//[window setMovableByWindowBackground:YES];
	[window setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spinConfigChange:) name:@"SpinConfigurationDidChangeNotification" object:nil];
	
	[NSApp activateIgnoringOtherApps:YES];
	[window makeKeyAndOrderFront:self];
	
	
	
}
-(IBAction)showAboutPanel:(id)sender{
	NSDictionary *options;
    NSImage *img;
	
    img = [NSImage imageNamed: @"ApplicationIcon"];
    options = [NSDictionary dictionaryWithObjectsAndKeys:
			    @"1.0",@"Version",
			    @"Spin",@"ApplicationName",
			   img, @"ApplicationIcon",
			    @"Shizaru",@"Copyright",
			   nil];
	
    [[NSApplication sharedApplication] orderFrontStandardAboutPanelWithOptions:options];


}
-(IBAction)quitSpin:(id)sender{
	NSApplication* app=[NSApplication sharedApplication];
	[app terminate:self];
}
-(void)spinConfigChange:(NSNotification*)note{
	NSUserDefaults *df=[NSUserDefaults standardUserDefaults];
	
	if([df boolForKey:@"enableTaskSwitcher"]){
		if ([[view subviews] count]<2) {
			[view addSwitcherView];
		}
		
	}
	else{
		[view removeSwitcherView];
	}
	NSInteger i= [df integerForKey:@"show"];
		[view setSwitchViewMode:i];
	BOOL mode=[df boolForKey:@"VIEW_PLACE_HOLIZONTALLY"];
	
	if (mode) {
		[view setViewMode:MAIN_VIEW_HORIZONTAL];
	}
	else {
		[view setViewMode:MAIN_VIEW_VERTICAL];
	}

}
	
-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
	
}
@end
