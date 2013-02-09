//
//  BNRViewController.m
//  CustomSegue
//
//  Created by Brandon Newendorp on 1/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNRViewController.h"

#import "BNRCustomSegue.h"

@implementation BNRViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue
                sender:(id)sender
{
    // Set title of navigation bar to destination view controller title
    // (not sure why this isn't happening automatically)
    UIViewController *dest = segue.destinationViewController;
    dest.navigationItem.title = dest.title;
}

@end
