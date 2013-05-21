//
//  BNRAppDelegate.h
//  SalesReport
//
//  Created by Jonathan Blocksom on 4/1/13.
//  Copyright (c) 2013 Jonathan Blocksom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRReportViewController;

@interface BNRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BNRReportViewController *viewController;

@end
