//
//  BNRViewController.m
//  Bugspray
//
//  Created by Michael Ward on 1/24/12.
//  Copyright (c) 2012 Big Nerd Ranch, Inc. All rights reserved.
//

#import "BNRViewController.h"

//#import "NSObject+DLIntrospection.h"

@implementation BNRViewController
@synthesize lcdLabel;
@synthesize opButtons;
@synthesize op, memValue, lcdValue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lcdLabel.text = @"";
    
}

- (void)viewDidUnload 
{
    [self setLcdLabel:nil];
    [self setOpButtons:nil];
    [super viewDidUnload];
}

#pragma mark - IBActions

- (IBAction)numberButtonPressed:(UIButton *)sender 
{
    if ([self.lcdLabel.text isEqualToString:@"0"]) {
        self.lcdLabel.text = [sender titleForState:UIControlStateNormal];
    }
    
    self.lcdLabel.text = [self.lcdLabel.text stringByAppendingString:[sender titleForState:UIControlStateNormal]];
}

- (IBAction)calcClear:(UIButton *)sender 
{
    self.memValue = 0.0;
    self.lcdLabel.text = @"0.00000";
}

- (IBAction)calcResolve:(UIButton *)sender 
{
    float a = self.lcdLabel.text.floatValue * 1.0;
    float b = self.memValue * 1.0;
    float r = 0.0;
    
    switch (op) {
        case 1:
            r = b - a;
            break;
        case 2:
            r = b + a;
            break;
        case 3:
            r = b / a;
            break;
        case 4:
            r = b * a;
            break;
            
        default:
            break;
    }
    
//    [self performSelector:@selector(bogus:)];
    
    self.lcdLabel.text = [NSString stringWithFormat:@"%.5f",r];
    self.memValue = 0.0;
}

- (IBAction)calcOperate:(UIButton *)sender 
{
    [self setOp:[sender tag]];
    
    if (!self.lcdLabel.text.floatValue) {
        return;
    }
    
    if (self.memValue && self.lcdLabel.text.floatValue) {
        [self calcResolve:sender];
    }
    
    self.memValue = [self.lcdLabel.text floatValue];
    self.lcdLabel.text = @"";
}

- (void)setOp:(CalcOperation)newOp
{
    for (UIButton *button in opButtons) {
        button.highlighted = (button.tag == newOp) ? YES : NO;
    }
    
    op = newOp;
}





































@end
