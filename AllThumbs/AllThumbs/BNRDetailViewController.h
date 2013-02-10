//
//  BNRDetailViewController.h
//  AllThumbs
//
//  Created by Jonathan Blocksom on 10/12/12.
//  Copyright (c) 2012 Big Nerd Ranch, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
