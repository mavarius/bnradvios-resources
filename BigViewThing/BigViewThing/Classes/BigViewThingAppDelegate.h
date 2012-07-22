//
//  BigViewThingAppDelegate.h
//  BigViewThing
//
//  Created by Jonathan Saggau on 7/3/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BigViewThingViewController;

@interface BigViewThingAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BigViewThingViewController *viewController;
    NSTimer *infoPrinterTimer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BigViewThingViewController *viewController;

@end

