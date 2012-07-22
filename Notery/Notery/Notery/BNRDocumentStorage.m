//
//  BNRDocumentStorage.m
//  Notery
//
//  Created by Dillan Laughlin on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNRDocumentStorage.h"
#import "BNRDocument.h"

NSString *kDocumentExtension = @"noteryDoc";
NSString *kDocumentListChangedAdditionNotification = @"kDocumentListChangedAdditionNotification";
NSString *kDocumentListChangedRemovalNotification = @"kDocumentListChangedRemovalNotification";
NSString *kDocumentListRemovedIndexPathKey = @"kDocumentListRemovedIndexPathKey";
NSString *kDocumentListAddedIndexPathKey = @"kDocumentListAddedIndexPathKey";

@interface BNRDocumentStorage ()
{
    NSMutableArray *_documentURLs;
}

@end

@implementation BNRDocumentStorage

+(BNRDocumentStorage *)sharedDocumentStorage
{
    static dispatch_once_t pred;
    static BNRDocumentStorage *docStore = nil;
    
    dispatch_once(&pred, ^{ docStore = [[self alloc] init]; });
    return docStore;
}


#pragma mark - Documents

-(NSURL *)localDocumentsURL
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory 
                                                   inDomains:NSUserDomainMask] lastObject];
}

-(NSArray *)documentURLs
{
    if (!_documentURLs)
    {
        _documentURLs = [[NSMutableArray alloc] init];
        
        NSMutableArray *dirContents = [[[NSFileManager defaultManager] 
                                        contentsOfDirectoryAtURL:[self localDocumentsURL] 
                                        includingPropertiesForKeys:nil options:0 
                                        error:NULL] mutableCopy];

        [_documentURLs addObjectsFromArray:dirContents];
        [_documentURLs sortUsingComparator: ^NSComparisonResult (NSURL * url1, NSURL * url2)
         {
             return [[url1 lastPathComponent] localizedStandardCompare:[url2 lastPathComponent]];
         }];
    }
    return [NSArray arrayWithArray:_documentURLs];
}


-(void)addDocumentURL:(NSURL *)url
{
    [_documentURLs addObject:url];
    [_documentURLs sortUsingComparator: ^NSComparisonResult (NSURL * url1, NSURL * url2)
     {
         return [[url1 lastPathComponent] localizedStandardCompare:[url2 lastPathComponent]];
     }];
    
    NSUInteger row = [self.documentURLs indexOfObject:url];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    NSDictionary *uInfo = [NSDictionary dictionaryWithObject:indexPath 
                                                      forKey:kDocumentListAddedIndexPathKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     kDocumentListChangedAdditionNotification
                                                        object:self
                                                      userInfo:uInfo];
}

-(void)removeDocumentURL:(NSURL *)url
{
    NSUInteger row = [self.documentURLs indexOfObject:url];
    
    [_documentURLs removeObject:url];
    
    [[NSFileManager defaultManager] removeItemAtURL:url error:NULL];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    NSDictionary *uInfo = [NSDictionary dictionaryWithObject:indexPath 
                                                      forKey:kDocumentListRemovedIndexPathKey];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:
                                                  kDocumentListChangedRemovalNotification
                                                        object:self
                                                      userInfo:uInfo];
}


-(NSURL *)addDocumentWithName:(NSString *)name
{
    NSString *extension = kDocumentExtension;
    NSURL *baseURL = [self localDocumentsURL];
    NSURL *url = [[baseURL URLByAppendingPathComponent:name] 
                  URLByAppendingPathExtension:extension];
    
    BNRDocument *document = [[BNRDocument alloc] initWithFileURL:url];
    if ([document save])
    {
        [self addDocumentURL:url];
    }
    
    return url;
}
@end
