//
//  BNRDocument.m
//  Notery
//
//  Created by Dillan Laughlin on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNRDocument.h"

@interface BNRDocument ()

@property (nonatomic, strong, readwrite) NSURL *fileURL;

@end

@implementation BNRDocument

-(id)initWithFileURL:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        [self setFileURL:url];
        
        NSError *readError = nil;
        NSString *text = [NSString stringWithContentsOfURL:[self fileURL] encoding:NSUTF8StringEncoding error:&readError];
        
        if (!text)
        {
            text = NSLocalizedString(@"New Document", @"New Document");
        }
        
        [self setContents:text];
    }
    return self;
}

-(BOOL)save
{
    NSError *writeError = nil;
    BOOL success = [self.contents writeToURL:[self fileURL] atomically:YES encoding:NSUTF8StringEncoding error:&writeError];
    if (!success)
    {
        if (writeError)
        {
            NSLog(@"Error writing file to url: %@\nError info:%@", [self fileURL], [writeError localizedDescription]);
        }
    }
    return success;
}

#pragma mark - Accessors

@synthesize fileURL = _fileURL;
@synthesize contents = _contents;
-(void)setContents:(NSString *)contents
{
    if (![_contents isEqualToString:contents])
    {
        _contents = [contents copy];
    }
}

@end
