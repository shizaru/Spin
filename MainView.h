//
//  MainView.h
//
//  Created by 石崎 徹 on 11/02/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
enum  SPIN_MAIN_VIEW_MODE{
	MAIN_VIEW_VERTICAL,
	MAIN_VIEW_HORIZONTAL
};
enum SPIN_SUB_VIEW_TAG {
	SPIN_SPACE_VIEW,
	SPIN_SWITCHER_VIEW
};
@interface MainView : NSView {
	IBOutlet NSMenu *subMenu;
	NSUInteger viewMode;
    NSUInteger topView;

}
-(void)addSwitcherView;
-(void)removeSwitcherView;
-(void)setSwitchViewMode:(NSInteger)mode;
-(void)setViewMode:(NSUInteger)mode;
-(void)setTopView:(NSUInteger)tView;
-(void)setSpaceViewDesktopWheel:(BOOL)flag;
@end
