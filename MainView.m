//
//  MainView.m
//
//  Created by 石崎 徹 on 11/02/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainView.h"
#import "SpacesBoard.h"
#import "SwitcherBoard.h"
#define VIEW_MARGIN 5
#define VIEW_TOPZONE_MARGIN 10

@implementation MainView
-(void)awakeFromNib{
	NSRect rect=NSMakeRect(0, 0, 10, 10) ;
	
	SpacesBoard *spboard=[[SpacesBoard alloc] initWithFrame:rect];
	[spboard setTag:SPIN_SPACE_VIEW];
	[self addSubview:spboard];
	[spboard release];
	NSUserDefaults* df=[NSUserDefaults standardUserDefaults];
	if ([[df valueForKey:@"enableTaskSwitcher"] boolValue]) {
		[self addSwitcherView];
        topView=[df integerForKey:@"TOP_VIEW"];
		
	}

	BOOL mode=[df boolForKey:@"VIEW_PLACE_HOLIZONTALLY"];
	if (mode) {
		[self setViewMode:MAIN_VIEW_HORIZONTAL];
	}
	else {
		[self setViewMode:MAIN_VIEW_VERTICAL];
	}
	
	
}
-(void)setSpaceViewDesktopWheel:(BOOL)flag{
    SpacesBoard* spview=[[self subviews] objectAtIndex:0];
    [spview setEnableDesktopWheel:flag];
    
    
    
}
-(void)setTopView:(NSUInteger)tView{
    if(topView!=tView){
        topView=tView;
        //NSLog(@"in setTopView topView=%d",topView);
        [self setNeedsDisplay:YES];
    }
    
}
-(void)setViewMode:(NSUInteger)mode{
	
	viewMode=mode;
	SpacesBoard* sbview=[[self subviews] objectAtIndex:0];
	[sbview setRowAndColMode:mode];
	[self setNeedsDisplay:YES];
	
}
	
-(void)addSwitcherView{
	SwitcherBoard *swboard=[[SwitcherBoard alloc] initWithFrame:NSMakeRect(0, 0, 10, 10)];
	[swboard setTag:SPIN_SWITCHER_VIEW];
	[self addSubview:swboard];
	[swboard release];
}
-(void)removeSwitcherView{
	SwitcherBoard* sbview=[[self subviews] objectAtIndex:1];
	[sbview removeFromSuperview];
    [self setTopView:SPIN_SPACE_VIEW];
	
}
-(void)setSwitchViewMode:(NSInteger)mode{
	if ([[self subviews] count]>1){
		SwitcherBoard* sbview=[[self subviews] objectAtIndex:1];
		[sbview setMode:mode];
		[sbview setNeedsDisplay:YES];
	}
}
-(void)resetCursorRects{
	
	NSCursor* arrowCursor    = [NSCursor arrowCursor];
	[self addCursorRect:[self frame] cursor:arrowCursor];
}
	
- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
	[NSGraphicsContext saveGraphicsState];
	
	
	NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:[self bounds] xRadius:10 yRadius:10];	
	[[NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:0.6] set];
	[path fill];
	// draw subview
	NSArray *views=[self subviews];
    NSRect viewBound=[self bounds];
    NSRect rect;
    
    if([views count]==1){
        
        topView=SPIN_SPACE_VIEW;
    }
    

            //size of subview
    if (viewMode==MAIN_VIEW_HORIZONTAL) {
        rect.size.width=(viewBound.size.width /[views count])-VIEW_MARGIN*2-2 ;
        rect.size.height=viewBound.size.height-(VIEW_MARGIN*2+VIEW_TOPZONE_MARGIN);
    
        //position of subview
        for (NSInteger i=0;i<[views count];i++){
            
            NSView* sbview=[views objectAtIndex:i];
            if (i==topView) {
                rect.origin.x=VIEW_MARGIN+viewBound.origin.x+VIEW_MARGIN;
                rect.origin.y=viewBound.origin.y+VIEW_MARGIN;
            }
            else{
                
                rect.origin.x=VIEW_MARGIN*2 +viewBound.origin.x+rect.size.width+VIEW_MARGIN;
                rect.origin.y=viewBound.origin.y+VIEW_MARGIN;
            }
                            
            [sbview setFrame:rect];
        }
    }
    else{
        rect.size.width=viewBound.size.width-(VIEW_MARGIN*2);
        rect.size.height=(viewBound.size.height /[views count])-VIEW_MARGIN*2-2 ;
        for (NSInteger i=0;i<[views count];i++){
            NSView* sbview=[views objectAtIndex:i];
            //rect.origin.y=VIEW_MARGIN+VIEW_MARGIN*i +viewBound.origin.y+((rect.size.height)* i)+VIEW_MARGIN;
            if (i==topView) {
                rect.origin.y=viewBound.size.height-rect.size.height-VIEW_MARGIN-VIEW_TOPZONE_MARGIN;
                rect.origin.x=viewBound.origin.x+VIEW_MARGIN;
            }
            else{
                rect.origin.y=viewBound.size.height-rect.size.height-rect.size.height-VIEW_MARGIN-VIEW_TOPZONE_MARGIN;
                rect.origin.x=viewBound.origin.x+VIEW_MARGIN;
            }
            
            [sbview setFrame:rect];
        }
    }

	[NSGraphicsContext restoreGraphicsState];
		
			
}
-(void)rightMouseDown:(NSEvent *)theEvent{
	[NSMenu popUpContextMenu:subMenu withEvent:theEvent forView:self];
	
}
-(BOOL)acceptsFirstMouse:(NSEvent *)theEvent{
	return YES;
}
@end
