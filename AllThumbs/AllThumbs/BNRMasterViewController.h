//
//  BNRMasterViewController.h
//  AllThumbs
//
//  Created by Jonathan Blocksom on 10/12/12.
//  Copyright (c) 2012 Big Nerd Ranch, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRDetailViewController;

@interface BNRMasterViewController : UITableViewController

@property (strong, nonatomic) BNRDetailViewController *detailViewController;

@end
