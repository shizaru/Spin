//
//  SpacesBoard.h
//  Spin
//
//  Created by 石崎 徹 on 11/02/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

enum SPACE_VIEW_ROW_AND_COL {
	
	SWITCH_ROW_AND_COL,
	REAL_ROW_AND_COL
};
@interface SpacesBoard : NSView {
	NSInteger spacesRow,spacesCol,spacesMax;
	NSUInteger desktopID,rowAndColMode;
	NSInteger tag;

}
@property NSInteger spacesRow,spacesCol,spacesMax,tag;
-(void) getSpacesMax;
-(void)setSpacesViews;
-(void)setSpaceFrameSize;
-(void)spaceChange:(NSNotification*)note;

- (NSInteger)spaceNumber;
void spacesSwitchCallback(int data1, int data2, int data3, void *userParameter) ;
void spacesChangedCallback(int data1, int data2, int data3, void *userParameter) ;
+(NSInteger)getSpacesRow;
+(NSInteger)getSpacesCol;
+(NSInteger)calcSpacesMax;
-(void)spaceConfigChange:(NSNotification *)note;
-(void)isDeskTop:(NSEvent*)event;
-(void)setDesktopID;
-(void)setRowAndColMode:(NSUInteger)mode;

@end
