//
//  BNRDocumentListTableViewController.h
//  Notery
//
//  Created by Dillan Laughlin on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRSingleDocumentViewController;

@interface BNRDocumentListTableViewController : UITableViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) BNRSingleDocumentViewController *documentViewController;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *addDocumentButton;

-(IBAction)addDocument:(id)sender;

@end

