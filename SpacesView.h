//
//  SpacesView.h
//  Spin
//
//  Created by 石崎 徹 on 11/02/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SpacesView : NSView {
	NSUInteger spaceNo;
	NSMutableDictionary *string_attributes;
	BOOL active;


}
- (id)initWithFrame:(NSRect)frame spaceNo:(NSUInteger) spaceNO;
- (NSInteger)spaceNumber;
-(void)removeSelf;
@property NSUInteger spaceNo;
@property BOOL active;

@end
