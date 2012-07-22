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
@synthesize segueButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setSegueButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass:[BNRCustomSegue class]])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(segueFinished:) 
													 name:BNRCustomSegueDidFinish 
												   object:segue];
        BNRViewController *destination = [segue destinationViewController];
        BNRViewController *source = [segue sourceViewController];
		
        [destination.navigationItem setHidesBackButton:YES];
        if ([segue.identifier isEqualToString:BNRCustomSegueForward])
        {
            [destination.navigationItem setTitle:@"I was underneath"];
        }
		
        // make sure views are loaded
        [destination view];
        [source view];
//        [destination.segueButton setEnabled:NO];
//        [source.segueButton setEnabled:NO]; 
    }
}

-(void)segueFinished:(NSNotification *)note
{
    BNRCustomSegue *segue = [note object];
    BNRViewController *destination = (BNRViewController *)[segue 
														   destinationViewController];
    BNRViewController *source = (BNRViewController *)[segue 
													  sourceViewController];
    [destination.segueButton setEnabled:YES];
    [source.segueButton setEnabled:YES];
}

@end
