//
//  MainController.h
//  Spin
//
//  Created by 石崎 徹 on 11/02/20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainView.h"

@interface MainController : NSObject {

	IBOutlet NSWindow *window;
	IBOutlet MainView *view;
}
-(IBAction)quitSpin:(id)sender;
-(IBAction)showAboutPanel:(id)sender;
@end
