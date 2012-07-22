//
//  ViewController.h
//  SalesReport
//
//  Created by Aaron Hillegass on 1/5/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class ReportRenderer;

@interface ReportViewController : UIViewController
{
    CALayer *reportLayer;
    ReportRenderer *reportRenderer;
}

@end
