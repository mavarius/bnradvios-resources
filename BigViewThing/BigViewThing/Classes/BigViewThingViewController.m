//
//  BigViewThingViewController.m
//  BigViewThing
//
//  Created by Jonathan Saggau on 7/3/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "BigViewThingViewController.h"
#import "BigViewScrollView.h"

#define SCROLLER_VIEW_TAG (1001)

@implementation BigViewThingViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    BigViewScrollView *scroller = [[BigViewScrollView alloc] initWithFrame:CGRectZero];
    CGRect scrollerFrame = [self.view frame];
    scrollerFrame.origin.x = scrollerFrame.origin.y = 0;
    [self.view addSubview:scroller];
    [scroller setFrame:scrollerFrame];
    [scroller setNumberOfPrerenderedOffscreenViews:0];
    [scroller setAutoresizingMask:[self.view autoresizingMask]];
    [scroller setTag:SCROLLER_VIEW_TAG];
    [scroller suspendDrawingInTiles]; // don't draw heavy stuff until it's visible.
    
    [scroller addImageName:@"1.png"];
    [scroller addImageName:@"2.png"];
    [scroller addImageName:@"3.png"];
    [scroller addImageName:@"4.png"];
    [scroller addImageName:@"5.png"];
    [scroller addImageName:@"6.png"];
    [scroller addImageName:@"7.png"];
//    [scroller addImageName:@"8.png"];
//    [scroller addImageName:@"9.png"];
    [scroller release];
}

- (void)viewWillAppear:(BOOL)animated; 
// Called when the view is about to made visible. Default does nothing
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated;
{// Called when the view has been fully transitioned onto the screen. Default does nothing
    [super viewDidAppear:animated];
    BigViewScrollView *scroller = (BigViewScrollView *) [self.view viewWithTag:SCROLLER_VIEW_TAG];
    [scroller fullReset];
    [scroller performSelector:@selector(resumeDrawingInTiles) withObject:nil afterDelay:0.1];
}
- (void)viewWillDisappear:(BOOL)animated; 
{// Called when the view is dismissed, covered or otherwise hidden. Default does nothing
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated;  
{// Called after the view was dismissed, covered or otherwise hidden. Default does nothing
    [super viewDidDisappear:animated];
    [super viewDidAppear:animated];
    BigViewScrollView *scroller = (BigViewScrollView *) [self.view viewWithTag:SCROLLER_VIEW_TAG];
    [scroller suspendDrawingInTiles];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation; // Override to allow rotation. Default returns YES only for UIDeviceOrientationPortrait
{
    return YES;
}

- (void)setScrollerOffscreenViews:(NSNumber *)howMany
{
    BigViewScrollView *scroller = (BigViewScrollView *) [self.view viewWithTag:SCROLLER_VIEW_TAG];
    [scroller setNumberOfPrerenderedOffscreenViews:[howMany intValue]];
}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    LogMethod();
    BigViewScrollView *scroller = (BigViewScrollView *) [self.view viewWithTag:SCROLLER_VIEW_TAG];
    [scroller memoryWentboom];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
