//
//  MainView.m
//
//  Created by 石崎 徹 on 11/02/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainView.h"
#import "SpacesBoard.h"
#define VIEW_MARGIN 5
#define VIEW_TOPZONE_MARGIN 10
@implementation MainView
-(void)awakeFromNib{
	NSRect rect=NSMakeRect(0, 0, 10, 10) ;
	
	SpacesBoard *spboard=[[SpacesBoard alloc] initWithFrame:rect];
	[self addSubview:spboard];
	[spboard release];
	
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
	//NSUInteger mode=BUTTON_TYPE_SHORT;
	
	//view全体を半透明でぬりつぶす
	NSRect viewBound=[self bounds];
		
	[[NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:0.5] set];
	NSRectFill([self frame]);
	//[self setSpaceFrameSize];
	NSArray *views=[self subviews];
	if(views){
		NSRect rect;
		rect.origin.x=viewBound.origin.x+VIEW_MARGIN;
		rect.origin.y=viewBound.origin.y+VIEW_MARGIN;
		rect.size.width=(viewBound.size.width /[views count])-VIEW_MARGIN*2 ;
		rect.size.height=viewBound.size.height-(VIEW_MARGIN*2+VIEW_TOPZONE_MARGIN);
		for(NSView * sbview in views){
			[sbview setFrame:rect];
		}
	}
	//NSImage *button=[NSImage imageNamed:NSImageNameFollowLinkFreestandingTemplate];
	//[button setSize:NSMakeSize(32,32)];
	//[button drawAtPoint:NSMakePoint(2,2 ) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
		
			
}

-(BOOL)acceptsFirstMouse:(NSEvent *)theEvent{
	return YES;
}
@end
