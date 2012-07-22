//
//  ReportRenderer.m
//  SalesReport
//
//  Created by Aaron Hillegass on 1/5/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "ReportRenderer.h"
#import "Person.h"
#import <QuartzCore/QuartzCore.h>

// RANGE is the range of values that are OK
#define RANGE (700.0f)

// B_MARGIN is the bottom margin in points
#define B_MARGIN (10.0f)

// T_MARGIN is the top margin in points
#define T_MARGIN (10.0f)

// H_GAP is the gap between the bars and side margins
#define H_GAP (10.4f)

@implementation ReportRenderer

- (id)initWithPersons:(NSArray *)p
{
    self = [super init];
    if (self) {
        persons = p;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
               bounds:(CGRect)bounds
{
    NSLog(@"Drawing in %@", NSStringFromCGRect(bounds));
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    
    CGFloat blackArray[4] = {0,0,0,1};
    CGColorRef black = CGColorCreate(cs, blackArray);
    
    CGFloat whiteArray[4] = {1,1,1,1};
    CGColorRef white = CGColorCreate(cs, whiteArray);
    
    CGContextSetStrokeColorWithColor(ctx, black);
    CGContextSetLineWidth(ctx, 2);
    
    CGContextSetFillColorWithColor(ctx, white);

    
    float minY = CGRectGetMinY(bounds) + B_MARGIN;
    float maxY = CGRectGetMaxY(bounds) - T_MARGIN;
    float increment = (maxY - minY) / RANGE;
    
    int personCount = [persons count];
    float totalHGaps = (personCount + 1) * H_GAP;
    float barWidth = (bounds.size.width - totalHGaps) / personCount;
    
    // Draw the bars
    CGRect barRect;
    barRect.size.width = barWidth;
    barRect.origin.y = minY;
    
    for (int i = 0; i < personCount; i++) {
        Person *person = [persons objectAtIndex:i];
        barRect.origin.x = bounds.origin.x + H_GAP + (barWidth + H_GAP) * i;
        uint sales = [person sales];
        barRect.size.height = sales * increment;
        CGPathRef barPath = CGPathCreateWithRect(barRect, NULL);
        CGContextAddPath(ctx, barPath);
        CGContextFillPath(ctx);
            
        // FillPath clears the current path, so add it again
        CGContextAddPath(ctx, barPath);
        CGContextStrokePath(ctx);
        CGPathRelease(barPath);
    }
    
    
    CGColorRelease(white);
    CGColorRelease(black);
    CGColorSpaceRelease(cs);
    
}

- (void)drawLayer:(CALayer *)player 
        inContext:(CGContextRef)ctx
{
    CGRect bounds = [player bounds];
    [self drawInContext:ctx bounds:bounds];
}

@end
