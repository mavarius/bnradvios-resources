//
//  BNRDocumentListTableViewController.m
//  Notery
//
//  Created by Dillan Laughlin on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNRDocumentListTableViewController.h"
#import "BNRSingleDocumentViewController.h"
#import "BNRDocumentStorage.h"
#import "BNRDocument.h"


@interface BNRDocumentListTableViewController ()

@property (nonatomic, readonly, weak) NSArray *documentURLs;
-(void)showDocumentURL:(NSURL *)documentURL;

@end

@implementation BNRDocumentListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

#pragma mark - Adding docs
-(IBAction)addDocument:(id)sender;
{
    UIAlertView *alertView = [[UIAlertView alloc] 
                              initWithTitle:NSLocalizedString(@"New Document", @"New Document") 
                              message:NSLocalizedString(@"Choose a name for your new document.", 
                                                        @"Choose a name for your new document.") 
                              delegate:self 
                              cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") 
                              otherButtonTitles:NSLocalizedString(@"Create", @"Create"), 
                              nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *field = [alertView textFieldAtIndex:0];
    field.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [alertView show];
}

-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *name = [[alertView textFieldAtIndex:0] text];
    
    return (name.length > 0);
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *name = [[alertView textFieldAtIndex:0] text];
        NSURL *documentURL = [[BNRDocumentStorage sharedDocumentStorage] 
                              addDocumentWithName:name];
        [self showDocumentURL:documentURL];
    }
}

#pragma mark - Navigation
-(void)showDocumentURL:(NSURL *)documentURL
{
    BNRDocument *document = nil;
    if (documentURL)
    {
        document = [[BNRDocument alloc] initWithFileURL:documentURL];
        NSInteger indexOfDocument = [self.documentURLs indexOfObject:documentURL];
        if (indexOfDocument != NSNotFound)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexOfDocument inSection:0];
            if (![[self.tableView indexPathForSelectedRow] isEqual:indexPath])
            {
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }
    }
    [self.documentViewController setDocument:document];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(documentRemoved:)
                                                 name:kDocumentListChangedRemovalNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(documentAdded:)
                                                 name:kDocumentListChangedAdditionNotification
                                               object:nil];
    
    [self.navigationController setToolbarHidden:NO animated:NO];
    if ([self.documentURLs count])
    {
        NSURL *docUrl = [self.documentURLs objectAtIndex:0];
        [self showDocumentURL:docUrl];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kDocumentListChangedRemovalNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kDocumentListChangedAdditionNotification
                                                  object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - editing adding removing

-(void)documentAdded:(NSNotification *)note
{
    [self.tableView reloadData];
}

-(void)documentRemoved:(NSNotification *)note
{
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSURL *url = [self.documentURLs objectAtIndex:indexPath.row];
        
        [[BNRDocumentStorage sharedDocumentStorage] removeDocumentURL:url];
    }
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    BNRDocument *document = [self.documentViewController document];
    NSURL *documentURL = [document fileURL];
    if (documentURL)
    {
        NSUInteger row = [self.documentURLs indexOfObject:documentURL];
        if (row == NSNotFound)
        {
            NSArray *documentURLs = [self documentURLs];
            if ([documentURLs count] > 0)
            {
                documentURL = [documentURLs objectAtIndex:0];
                [self showDocumentURL:documentURL];
            }
        }
        else
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:UITableViewScrollPositionNone];
        }
    }
}


#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.documentURLs count];
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DocumentListTableViewControllerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *url = [self.documentURLs objectAtIndex:indexPath.row];
    NSString *cellText = [[url lastPathComponent] stringByDeletingPathExtension];
    
    [cell.textLabel setText:cellText];
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    if ([self.documentURLs count] > row)
    {
        id documentURL = [self.documentURLs objectAtIndex:row];
        [self showDocumentURL:documentURL];
    }
}

#pragma mark - Accessors
-(NSArray *)documentURLs
{
    NSArray *docArray = [[BNRDocumentStorage sharedDocumentStorage] documentURLs];
    return docArray;
}

@synthesize addDocumentButton = _addDocumentButton;
@synthesize documentViewController = _detailViewController;

@end
