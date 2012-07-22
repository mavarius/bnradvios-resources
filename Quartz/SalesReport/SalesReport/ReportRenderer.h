//
//  ReportRenderer.h
//  SalesReport
//
//  Created by Aaron Hillegass on 1/5/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportRenderer : NSObject
{
    NSArray *persons;
}
- (id)initWithPersons:(NSArray *)p;

// Assumes the ctx is flipped
- (void)drawInContext:(CGContextRef)ctx
               bounds:(CGRect)bounds;

// Just a stub that calls drawInContext:bounds:
- (void)drawLayer:(CALayer *)player 
        inContext:(CGContextRef)ctx;


@end
