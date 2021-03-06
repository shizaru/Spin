//
//  SpacesView.m
//  Spin
//
//  Created by 石崎 徹 on 11/02/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SpacesView.h"
#import "SpacesBoard.h"
#import "CGSPrivate.h"



@implementation SpacesView
@synthesize spaceNo,active;
- (id)initWithFrame:(NSRect)frame spaceNo:(NSUInteger) spaceNO{
    self = [super initWithFrame:frame];
    if (self) {
        
		[self setSpaceNo:spaceNO];
		string_attributes = [[NSMutableDictionary dictionary] retain];
		[string_attributes setObject:[NSColor grayColor]
							   forKey:NSForegroundColorAttributeName];
		[string_attributes setObject:[NSFont boldSystemFontOfSize:16.0]
							   forKey: NSFontAttributeName];
		[self setActive:NO];
		
    }
    return self;
}
-(BOOL)acceptsFirstMouse:(NSEvent *)theEvent{
	return YES;
}
-(NSArray *)setColorArray:(BOOL)state{
	float alha;
	
	if (state==YES) alha=0.8;
	else alha=0.3;
		
	 NSArray* colorArray = [NSArray arrayWithObjects:
								  [NSColor colorWithDeviceWhite:0.4 alpha:alha],
								  [NSColor colorWithDeviceWhite:0.1 alpha:alha],
								  [NSColor colorWithDeviceWhite:0.0 alpha:alha],
								  nil];
	return colorArray;
	
}
- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
	[NSGraphicsContext saveGraphicsState];
	NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:[self bounds] xRadius:5 yRadius:5];
	NSArray* colorArray;
	if ([self active]==YES) {
		colorArray = [self setColorArray:YES];		
	}
	else{
		colorArray = [self setColorArray:NO];	
	}
	
	NSGradient* gradient = [[NSGradient alloc] initWithColors:colorArray];
	[gradient drawInBezierPath:path angle:270];
	[[NSColor colorWithDeviceRed:0.7 green:0.7 blue:0.7 alpha:0.8] set];
	[path setLineWidth:0.5];
	[path stroke];
	NSString *intString = [NSString stringWithFormat:@"%d", spaceNo];
	NSSize size=[intString sizeWithAttributes:string_attributes];
	NSPoint point=NSMakePoint(([self bounds].size.width -size.width)/2, ([self bounds].size.height-size.height)/2);
	[intString drawAtPoint:point withAttributes: string_attributes];
	[gradient release];
	[NSGraphicsContext restoreGraphicsState];

}
- (NSInteger)spaceNumber {
	CGSWorkspace currentSpace;
	
	if (CGSGetWorkspace(_CGSDefaultConnection(), &currentSpace) == kCGErrorSuccess) {
		if (currentSpace == 65538) {
			return -1;
		}
		
		return currentSpace;
	} else {
		return -1;
	}
} 

-(void)mouseUp:(NSEvent *)theEvent{
	if ([self spaceNo]!= [self spaceNumber]) {
		CGSSetWorkspace( _CGSDefaultConnection(), [self spaceNo]);
		//[[NSNotificationCenter defaultCenter] postNotificationName:@"ActiveSpaceDidSwitchNotification" object:nil];
		[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.apple.switchSpaces"object:[NSString stringWithFormat:@"%d", [self spaceNo]-1]];
	}

	
}
-(void)rightMouseUp:(NSEvent *)theEvent{
    NSWorkspace* ws=[NSWorkspace sharedWorkspace];
    [ws launchApplication:@"Spaces.app"];
    
}
-(void)removeSelf{
	[self removeFromSuperview];
}
-(void)dealloc{
	[string_attributes release];
	[super dealloc];
}

@end
