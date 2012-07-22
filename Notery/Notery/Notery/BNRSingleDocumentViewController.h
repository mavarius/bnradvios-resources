//
//  BNRSingleDocumentViewController.h
//  Notery
//
//  Created by Dillan Laughlin on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRDocument;

@interface BNRSingleDocumentViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;

// This object opens the new document and closes the previous document when set
// It also closes the document on view did unload
@property (strong, nonatomic) BNRDocument *document;

@end
