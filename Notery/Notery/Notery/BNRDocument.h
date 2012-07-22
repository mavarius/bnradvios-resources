//
//  BNRDocument.h
//  Notery
//
//  Created by Dillan Laughlin on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRDocument : NSObject

@property (nonatomic, copy) NSString *contents;
@property (nonatomic, strong, readonly) NSURL *fileURL;

-(id)initWithFileURL:(NSURL *)url;
-(BOOL)save;

@end
