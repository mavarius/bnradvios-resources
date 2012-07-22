//
//  BNRCustomSegue.m
//  CustomSegue
//
//  Created by Brandon Newendorp on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "BNRCustomSegue.h"

NSString *BNRCustomSegueReverse = @"BNRCustomSegueReverse";
NSString *BNRCustomSegueForward = @"BNRCustomSegueForward";
NSString *BNRCustomSegueDidFinish = @"BNRCustomSegueDidFinish";

@implementation BNRCustomSegue

- (void)perform
{
    NSLog(@"Your transition goes here!");
}

@end
