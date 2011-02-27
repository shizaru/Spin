//
//  ResizeWindow.m
//
//  Created by 石崎 徹 on 11/02/27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResizeWindow.h"

@implementation ResizeWindow
#define MINIMUM_WINDOW_WIDTH 100
#define MINIMUM_WINDOW_HEIGHT 100
-(void)awakeFromNib{
	
	shouldRedoInitials=YES;
	shouldDrag=YES;
}
-(void)mouseDragged:(NSEvent *)theEvent
{
	if (shouldRedoInitials)
	{
		initialLocation = [theEvent locationInWindow];
		initialLocationOnScreen = [self convertBaseToScreen:[theEvent locationInWindow]];
		
		initialFrame = [self frame];
		shouldRedoInitials = NO;
		
		if (initialLocation.x > initialFrame.size.width - 20 && initialLocation.y < 20) {
			shouldDrag = NO;
		}
		else {
			
			shouldDrag = YES;
		}
		
		screenFrame = [[NSScreen mainScreen] frame];
		windowFrame = [self frame];
		
		minY = windowFrame.origin.y+(windowFrame.size.height-MINIMUM_WINDOW_HEIGHT);
	}
	
	
	// 1. Is the Event a resize drag (test for bottom right-hand corner)?
	if (shouldDrag == FALSE)
	{
		// i. Remember the current downpoint
		NSPoint currentLocationOnScreen = [self convertBaseToScreen:[self mouseLocationOutsideOfEventStream]];
		currentLocation = [theEvent locationInWindow];
		//NSLog(@"currentLocation in shouldDrag==FALSE x:%f y:%f",currentLocation.x,currentLocation.y);
		// ii. Adjust the frame size accordingly
		float heightDelta = (currentLocationOnScreen.y - initialLocationOnScreen.y);
		
		if ((initialFrame.size.height - heightDelta) < MINIMUM_WINDOW_HEIGHT+1)
		{
			windowFrame.size.height = MINIMUM_WINDOW_HEIGHT;
			//windowFrame.origin.y = initialLocation.y-(initialLocation.y - windowFrame.origin.y)+heightDelta;
			windowFrame.origin.y = minY;
		} else
		{
			windowFrame.size.height = (initialFrame.size.height - heightDelta);
			windowFrame.origin.y = (initialFrame.origin.y + heightDelta);
		}
		
		windowFrame.size.width = initialFrame.size.width + (currentLocation.x - initialLocation.x);
		if (windowFrame.size.width < MINIMUM_WINDOW_WIDTH)
		{
			windowFrame.size.width = MINIMUM_WINDOW_WIDTH;
		}
		
		// iii. Set
		[self setFrame:windowFrame display:YES animate:NO];
	}
	else
	{
		//grab the current global mouse location; we could just as easily get the mouse location 
		//in the same way as we do in -mouseDown:
		currentLocation = [self convertBaseToScreen:[self mouseLocationOutsideOfEventStream]];
		//NSLog(@"currentLocation x:%f y:%f",currentLocation.x,currentLocation.y);
		newOrigin.x = currentLocation.x - initialLocation.x;
		newOrigin.y = currentLocation.y - initialLocation.y;
		//NSLog(@"NewOrigin x:%f y:%f",newOrigin.x,newOrigin.y);
		// Don't let window get dragged up under the menu bar
		if( (newOrigin.y+windowFrame.size.height) > (screenFrame.origin.y+screenFrame.size.height) )
		{
			newOrigin.y=screenFrame.origin.y + (screenFrame.size.height-windowFrame.size.height);
		}
		
		//go ahead and move the window to the new location
		[self setFrameOrigin:newOrigin];
		
	}
}
- (void)mouseUp:(NSEvent *)theEvent
{
	shouldRedoInitials = YES;
}	
-(void)mouseDown:(NSEvent *)theEvent{
	shouldRedoInitials = YES;
}


@end
