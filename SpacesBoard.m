//
//  SpacesBoard.m
//  Spin
//
//  Created by 石崎 徹 on 11/02/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SpacesBoard.h"
#import "SpacesView.h"
#import "CGSPrivate.h"
#define VIEW_FRAME_SPACE 2

@implementation SpacesBoard
@synthesize spacesRow;
@synthesize spacesCol;
@synthesize spacesMax;
NSString *SwitchSpacesNotification = @"com.apple.switchSpaces";

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		
        // Initialization code here.
		[self getSpacesMax];
		[self setSpacesViews];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spaceChange:) name:@"ActiveSpaceDidSwitchNotification" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spaceConfigChange:) name:@"SpacesConfigurationDidChangeNotification" object:nil];
		CGSRegisterConnectionNotifyProc(_CGSDefaultConnection(), spacesSwitchCallback, CGSWorkspaceChangedEvent, (void *)self);
		CGSRegisterConnectionNotifyProc(_CGSDefaultConnection(), spacesChangedCallback, CGSWorkspaceConfigurationEnabledEvent, (void *)self);
		CGSRegisterConnectionNotifyProc(_CGSDefaultConnection(), spacesChangedCallback, CGSWorkspaceConfigurationDisabledEvent, (void *)self);
    }
    return self;
}
void spacesChangedCallback(int data1, int data2, int data3, void *userParameter) {
	static NSInteger lastCols;
	static NSInteger lastRows;
	NSInteger currentCols = [SpacesBoard getSpacesCol];
	NSInteger currentRows = [SpacesBoard getSpacesRow];
	if (lastCols != currentCols || lastRows != currentRows) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"SpacesConfigurationDidChangeNotification" object:nil];	
	}
	lastCols = currentCols;
	lastRows = currentRows;
}
void spacesSwitchCallback(int data1, int data2, int data3, void *userParameter) {
	CGSWorkspace currentSpace = 0;
	
	if (CGSGetWorkspace(_CGSDefaultConnection(), &currentSpace) == kCGErrorSuccess && currentSpace != 65538) {
		//NSDictionary *info = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:currentSpace] forKey:@"Space"];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ActiveSpaceDidSwitchNotification" object:nil]; //userInfo:info];
	}
}
-(void)spaceConfigChange:(NSNotification *)note{
	NSLog(@"Call ConfigChange!");
	[self getSpacesMax];
	[self setSpacesViews];
	[self setNeedsDisplay:YES];
	
	
}
-(void)spaceChange:(NSNotification*)note{
	NSInteger no=[self spaceNumber];
	
	if (no> spacesMax) {
		no=1;
	}
	//NSLog(@"SpaceNo:%d",no);
	NSArray *views=[self subviews];
	for(NSInteger i=0;i<[views count];i++){
		SpacesView* spview=[views objectAtIndex:i]; 
		if([spview spaceNo] ==no){
			[spview setActive:YES];
			//NSLog(@"i=%d ACTIVE_NO %d",i,[spview spaceNo]);
			
		}else{
			[spview setActive:NO];
		}
		//[spview setNeedsDisplay:YES];
	}
	[self setNeedsDisplay:YES];
	
}
-(void)setSpacesViews{
	NSRect rect=NSMakeRect(0, 0, 10, 10);
	NSArray *views=[self subviews];
	if([views count]>0){
		if(spacesMax > [views count]){
			for(NSInteger i=[views count];i<spacesMax;i++){
				SpacesView *frame=[[SpacesView alloc] initWithFrame:rect spaceNo:i+1];
				//NSLog(@"add View:no %d",[frame spaceNo]);
				[self addSubview:frame];
				[frame release];
			}
		}else if(spacesMax < [views count]) {
			for(NSInteger i=[views count]-1;i>=spacesMax;i--){
				SpacesView *spview=[views objectAtIndex:i];
				//NSLog(@"remove View:no %d count:%d MAX:%d loop:i:%d",[spview spaceNo],[views count],spacesMax,i);
				[spview removeSelf];
			}
		}
		CGSWorkspace currentSpace=[self spaceNumber];
		for(NSInteger i=0;i<spacesMax;i++){
			if (i==currentSpace-1) {
				SpacesView *spview=[views objectAtIndex:i];
				[spview setActive:YES];
			}
		}
				
	}
	else{
		CGSWorkspace currentSpace=[self spaceNumber];
		
		for(NSInteger i=0;i< spacesMax;i++){
			SpacesView *frame=[[SpacesView alloc] initWithFrame:rect spaceNo:i+1];
			//NSLog(@"add View:no %d",[frame spaceNo]);
			if (i==currentSpace-1) {
				[frame setActive:YES];
			}
			
			[self addSubview:frame];
			[frame release];
		}
	}
	
	
}

-(void)setSpaceFrameSize{
	NSRect rect;
	NSRect bound=[self bounds];
	rect.origin.x=VIEW_FRAME_SPACE;
	rect.origin.y=(bound.size.height / spacesRow)*(spacesRow-1)+VIEW_FRAME_SPACE;
	rect.size.width=(bound.size.width / spacesCol)-(VIEW_FRAME_SPACE * 2);
	rect.size.height=(bound.size.height / spacesRow)-(VIEW_FRAME_SPACE * 2);
	NSArray *views=[self subviews];
	if([views count]>0){ 
		for(NSInteger j=0; j< spacesRow ;j++){
			for(NSInteger i =0;i<spacesCol;i++){
				//NSLog(@"x:%f y:%f w:%f h:%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
				SpacesView *aFrame=[views objectAtIndex:i+(spacesCol*j)];
				aFrame.frame=rect;
				rect.origin.x+=(VIEW_FRAME_SPACE *2)+rect.size.width;
				
			}
			rect.origin.y-=(rect.size.height+VIEW_FRAME_SPACE*2);
			rect.origin.x=VIEW_FRAME_SPACE;
			
		}
	}
}


- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
	NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:[self bounds]
														 xRadius:10
														 yRadius:10];
	
	[[NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:0.0] set];
	[path fill];
	//[[NSColor colorWithDeviceRed:0.7 green:0.7 blue:0.7 alpha:0.8] set];
	//[path setLineWidth:1.0];
	//[path stroke];
	[self setSpaceFrameSize];
}
-(void) getSpacesMax{
	CFPreferencesAppSynchronize(CFSTR("com.apple.dock"));
	spacesRow=CFPreferencesGetAppIntegerValue(CFSTR("workspaces-rows"),CFSTR( "com.apple.dock"), nil);
	spacesCol=CFPreferencesGetAppIntegerValue(CFSTR("workspaces-cols"), CFSTR("com.apple.dock"), nil);
	spacesMax=spacesRow * spacesCol;
	
	
}
+(NSInteger)getSpacesRow{
	CFPreferencesAppSynchronize(CFSTR("com.apple.dock"));
	NSInteger row=CFPreferencesGetAppIntegerValue(CFSTR("workspaces-rows"),CFSTR( "com.apple.dock"), nil);
	return row;
}
+(NSInteger)getSpacesCol{
	CFPreferencesAppSynchronize(CFSTR("com.apple.dock"));
	NSInteger col=CFPreferencesGetAppIntegerValue(CFSTR("workspaces-cols"),CFSTR( "com.apple.dock"), nil);
	return col;
}
+(NSInteger)calcSpacesMax{
	NSInteger row=[self getSpacesRow];
	NSInteger col=[self getSpacesCol];
	return row * col;
	
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


- (void)postNotificationSpacesSwitch:(NSInteger)object{
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:SwitchSpacesNotification object:[NSString stringWithFormat:@"%d", object]];
	
}
-(void)rightMouseDown:(NSEvent *)theEvent{
	NSLog(@"click!");
	
}
- (void)scrollWheel:(NSEvent *)theEvent{
	//NSLog(@"%f",theEvent.deltaY);
	NSInteger number_space=[self spaceNumber];
	//NSLog(@"spaceNumber %d",number_space);
	if ([theEvent deltaY] < 0.0) {
		if (number_space==[self spacesMax]) {
			number_space=1;
		}
		else{
			number_space++;
		}
		
	}
	else{
		if (number_space==1) {
			number_space=[self spacesMax];
		}
		else{
			number_space--;
		}
	}
	//[self postNotificationSpacesSwitch:number_space-1];
	CGSSetWorkspace( _CGSDefaultConnection(), number_space);
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ActiveSpaceDidSwitchNotification" object:nil];
	
}
-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self]; 
	[super dealloc];
}
	
@end
