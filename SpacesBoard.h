//
//  SpacesBoard.h
//  Spin
//
//  Created by 石崎 徹 on 11/02/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SpacesBoard : NSView {
	NSInteger spacesRow,spacesCol,spacesMax;

}
@property NSInteger spacesRow,spacesCol,spacesMax;
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

@end
