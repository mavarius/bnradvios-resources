//
//  BNRSingleDocumentViewController.m
//  Notery
//
//  Created by Dillan Laughlin on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNRSingleDocumentViewController.h"
#import "BNRDocument.h"

@interface BNRSingleDocumentViewController ()

@property (nonatomic, strong) UIPopoverController *documentPopoverController;
@property (assign, nonatomic) CGFloat keyboardHeight;

// copies the text from the view into the document
-(void)syncTextViewWithDocument;
-(void)openDocument;
-(void)closeDocument;

@end

@implementation BNRSingleDocumentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //    self.view.layer.borderWidth = 4.0f;
    //    self.view.layer.borderColor = [UIColor redColor].CGColor;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillUpdate:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillUpdate:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillUpdate:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textView flashScrollIndicators];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    self.keyboardHeight = 0.0;
    
    [super viewWillDisappear:animated];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    [self setTextView:nil];
    [self setDocument:nil];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Split view

-(void)splitViewController:(UISplitViewController *)splitController
    willHideViewController:(UIViewController *)viewController
         withBarButtonItem:(UIBarButtonItem *)barButtonItem
      forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = @"Documents";
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.documentPopoverController = popoverController;
}

-(void)splitViewController:(UISplitViewController *)splitController
    willShowViewController:(UIViewController *)viewController
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.documentPopoverController = nil;
}

#pragma mark - Document

-(void)documentContentsDidUpdate;
{
    self.textView.text = self.document.contents;
}

-(void)documentUpdated:(NSNotification *)note
{
    [self view]; // makes sure our textView is ready
    [self documentContentsDidUpdate];
}

-(void)openDocument
{
    if (self.document)
    {
        [self documentContentsDidUpdate];
    }
}


-(void)closeDocument;
{
    if (self.document)
    {
        [self syncTextViewWithDocument];
        if ([self.document save])
        {
            NSLog(@"Closed document: %@", [self document]);
        }
    }
}

#pragma mark - text sync with UI

-(void)syncTextViewWithDocument
{
    self.document.contents = self.textView.text;
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self syncTextViewWithDocument];
}


#pragma mark - Keyboard

@synthesize keyboardHeight = _keyboardHeight;
-(void)setKeyboardHeight:(CGFloat)value
{
    _keyboardHeight = value;
    
    CGFloat parentHeight = self.view.bounds.size.height;
    CGRect frame = self.textView.frame;
    frame.size.height = parentHeight - _keyboardHeight;
    self.textView.frame = frame;
}

-(void)keyboardWillUpdate:(NSNotification *)notification
{
    NSTimeInterval animationDuration = [[[notification userInfo] 
                                         objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] 
                                            objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGRect endFrame = [[[notification userInfo] 
                        objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    endFrame = [self.view convertRect:[[self.view window] convertRect:endFrame 
                                                           fromWindow:nil] fromView:nil];
    endFrame = CGRectIntersection(endFrame, self.view.bounds);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    self.keyboardHeight = endFrame.size.height;
    [UIView commitAnimations];
}


#pragma mark - Accessors
@synthesize documentPopoverController = _documentPopoverController;

@synthesize textView = _textView;
-(void)setTextView:(UITextView *)textView
{
    if (_textView != textView)
    {
        _textView = textView;
        [self performSelector:@selector(documentContentsDidUpdate) withObject:nil afterDelay:0.0f];
    }
}

@synthesize document = _document;
- (void)setDocument:(BNRDocument *)document
{
    if (_document != document) 
    {
        [self closeDocument];
        _document = document;
        [self openDocument];
    }
}

@end
