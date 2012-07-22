//
//  JSRandomCrazyPageView.m
//  BigViewThing
//
//  Created by Jonathan Saggau on 7/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BigViewPageView.h"
#import "BigViewThingAppDelegate.h"
#include <unistd.h>

CGFloat scale = .94;

@implementation BigViewPageView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        pageToDraw = 1;
        drawingSuspended = YES;
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [self setContentMode:UIViewContentModeScaleToFill];
        [self setClearsContextBeforeDrawing:NO];
        imageName = nil;
    }
    return self;
}

-(void)setFrame:(CGRect )someFrame
{
    if(!drawingSuspended)
        [self setNeedsDisplay];
    
    [super setFrame:someFrame];
}

-(void)drawRect:(CGRect)rect
{   
    NSLog(@"drawRect");
    CGContextRef context = UIGraphicsGetCurrentContext();    
    CGSize layerSize = [self bounds].size;
    layerSize.height = floorf(layerSize.height);
    layerSize.width = floorf(layerSize.width);
    
    CGContextTranslateCTM(context, 0, layerSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGFloat tx = layerSize.width * (1.0 - scale) * 0.5;
    CGFloat ty = layerSize.height * (1.0 - scale) * 0.5;
    CGRect tempbounds = CGRectZero;
    tempbounds.size = layerSize;
    tempbounds = CGRectIntegral(CGRectInset(tempbounds, tx, ty));
    CGContextSetShadow(context, CGSizeMake(5,-5), 5);
    if(!drawingSuspended)
    {
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor);
        CGImageRef tempImage = [UIImage imageNamed:self.imageName].CGImage;
        CGContextDrawImage(context, tempbounds, tempImage);
        drawnPageOnce = YES;
    }
    else 
    {
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor);
        CGContextFillRect(context, tempbounds);
    }
}

-(void)didMoveToSuperview
{
    //NSLog(@"didMoveToSuperview %d", pageToDraw);
    drawnPageOnce = NO;
    [self setNeedsDisplay];
}

@synthesize pageToDraw;
- (void)setPageToDraw:(NSUInteger)aPageToDraw
{
    //NSLog(@"in -setPageToDraw, old value of pageToDraw: %d, changed to: %d", pageToDraw, aPageToDraw);
    @synchronized(self)
    {
        if(pageToDraw != aPageToDraw)
        {
            pageToDraw = aPageToDraw;
            drawnPageOnce = NO;
        }
    }
}

@synthesize drawingSuspended;
- (void)setDrawingSuspended:(BOOL)flag
{
    @synchronized(self){
        if (drawingSuspended != flag) {
            NSString *sus = flag ? @"SUSPEND" : @"RESUME";
            NSLog(@"%@ %d", sus, pageToDraw);
            drawingSuspended = flag;
            if(!drawingSuspended)
            {
                [self setNeedsDisplay];
            }
            [self setFrame:self.frame];
        }
    }
}

@synthesize imageName;
- (void)setImageName:(NSString *)anImageName
{
    @synchronized(self) {
        if (![imageName isEqualToString:anImageName]) {
            NSLog(@"in  -setImageName:, old value of imageName: %@, changed to: %@", imageName, anImageName);
            
            anImageName = [anImageName copy];
            [imageName release];
            imageName = anImageName;
            if(!IsEmpty(imageName))
            {
                [self setNeedsDisplay];
            }
        }
    }
}

- (void)dealloc {
    self.imageName = nil;
    [super dealloc];
}

@end

