//
//  BNRViewController.m
//  VidCam
//
//  Created by Jonathan Blocksom on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNRViewController.h"

@interface BNRViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *recordingSwitch;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *replayButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)toggleRecording:(id)sender;
- (IBAction)playVideo:(id)sender;
- (IBAction)saveVideo:(id)sender;

@end

@implementation BNRViewController

@synthesize recordingSwitch = _recordingSwitch;
@synthesize replayButton = _replayButton;
@synthesize saveButton = _saveButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setRecordingSwitch:nil];
    [self setReplayButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)toggleRecording:(id)sender {
    if (self.recordingSwitch.on) {
        NSLog(@"Recording on");

        self.replayButton.enabled = NO;
        self.saveButton.enabled = NO;
    } else {
        NSLog(@"Recording off");
        
        self.replayButton.enabled = YES;
        self.saveButton.enabled = YES;
    }
}

- (IBAction)playVideo:(id)sender {
}

- (IBAction)saveVideo:(id)sender {
}

@end
