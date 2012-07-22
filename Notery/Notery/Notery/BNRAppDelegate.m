//
//  BNRAppDelegate.m
//  Notery
//
//  Created by Dillan Laughlin on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNRAppDelegate.h"
#import "BNRSingleDocumentViewController.h"
#import "BNRDocumentListTableViewController.h"

@implementation BNRAppDelegate

@synthesize window = _window;

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    NSArray *viewControllers = [splitViewController viewControllers];
    UINavigationController *navigationController = [viewControllers lastObject];
    BNRSingleDocumentViewController *singleDocViewController = (BNRSingleDocumentViewController *)navigationController.topViewController;
    
    splitViewController.delegate = singleDocViewController;
    
    navigationController = [viewControllers objectAtIndex:0];
    BNRDocumentListTableViewController *docListTableViewController = (BNRDocumentListTableViewController *)navigationController.topViewController;
    [docListTableViewController setDocumentViewController:singleDocViewController];
    
    return YES;
}

@end