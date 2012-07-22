//
//  BigViewThingAppDelegate.m
//  BigViewThing
//
//  Created by Jonathan Saggau on 7/3/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "BigViewThingAppDelegate.h"
#import "BigViewThingViewController.h"
#import "JSMemoryCPUTools.h"

@interface BigViewThingAppDelegate (debuggingAPI)
- (void)showInfo:(NSTimer *)timer;
@end


@implementation BigViewThingAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    //[self showInfo:nil];// initializes cpu tracking
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
    infoPrinterTimer = [[NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(showInfo:) userInfo:nil repeats:YES] retain];
    [[NSRunLoop currentRunLoop] addTimer:infoPrinterTimer forMode:NSDefaultRunLoopMode];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application;      // try to clean up as much memory as possible. next step is to terminate app
{
    NSLog(@"applicationDidReceiveMemoryWarning");
    [self showInfo:nil]; // show the CPU and memory info right away.
}

- (void)showInfo:(NSTimer *)timer
{
	// time has passed, hide the chrome
//	[[JSMemoryCPUTools class] printCPUInfo];
//  [[JSMemoryCPUTools class] printMEMInfo];
}

- (void)dealloc {
    [infoPrinterTimer invalidate];
	[infoPrinterTimer release];
	infoPrinterTimer = nil;
    [viewController release]; viewController = nil;
    [window release]; window = nil;
    [super dealloc];
}


@end
