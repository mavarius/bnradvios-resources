//
//  BNRViewController.h
//  TempChat
//
//  Created by Jonathan Blocksom on 1/9/13.
//  Copyright (c) 2013 Big Nerd Ranch, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *messageTable;

- (IBAction)connect:(id)sender;

@property (nonatomic, weak) IBOutlet UITextField *textField;

@end
