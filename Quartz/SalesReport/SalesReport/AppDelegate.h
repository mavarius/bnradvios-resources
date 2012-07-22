//
//  AppDelegate.h
//  SalesReport
//
//  Created by Aaron Hillegass on 1/5/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReportViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ReportViewController *viewController;

@end
