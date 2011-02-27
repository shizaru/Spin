//
//  ResizeWindow.h
//
//  Created by 石崎 徹 on 11/02/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ResizeWindow : NSPanel {
	BOOL shouldDrag;
	BOOL shouldRedoInitials;
	NSPoint initialLocation;
	NSPoint initialLocationOnScreen;
	NSRect initialFrame;
	NSPoint currentLocation;
	NSPoint newOrigin;
	NSRect screenFrame;
	NSRect windowFrame;
	float minY; 
	
}

@end
