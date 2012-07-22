//
//  ViewController.m
//  SalesReport
//
//  Created by Aaron Hillegass on 1/5/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "ReportViewController.h"
#import "Person.h"
#import "ReportRenderer.h"

@implementation ReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSMutableArray *persons = [NSMutableArray array];
        Person *p;
        UIImage *i;
        i = [UIImage imageNamed:@"fred"];
        p = [[Person alloc] initWithImage:i];
        [p setName:@"Fred"];
        [p setSales:134];
        [persons addObject:p];
        
        i = [UIImage imageNamed:@"matt"];
        p = [[Person alloc] initWithImage:i];
        [p setName:@"Matt"];
        [p setSales:312];
        [persons addObject:p];
        
        reportRenderer = [[ReportRenderer alloc] initWithPersons:persons];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create a layer
    reportLayer = [[CALayer alloc] init];
    [reportLayer setBackgroundColor:[[UIColor lightGrayColor] CGColor]];
    [reportLayer setGeometryFlipped:YES];
    [reportLayer setDelegate:reportRenderer];
    
    // Put it atop the view
    CALayer *viewLayer = [[self view] layer];
    [viewLayer addSublayer:reportLayer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    reportLayer = nil;
}

- (void)viewDidLayoutSubviews
{
    CGRect bounds = [[self view] bounds];
    
    // Leave some space for the buttons
    bounds.size.height -= 60;
    [reportLayer setBounds:bounds];
    [reportLayer setAnchorPoint:CGPointMake(0,0)];
    [reportLayer setPosition:CGPointMake(0,0)];
    [reportLayer display];
}

-(void)viewDidAppear:(BOOL)animated
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    [anim setToValue:[NSValue valueWithCGPoint:CGPointMake(0, 0)]];
    [anim setFromValue:[NSValue valueWithCGPoint:CGPointMake(-600, 0)]];
    [reportLayer addAnimation:anim forKey:@"positionChange"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
