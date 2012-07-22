//
//  BNRDocumentStorage.h
//  Notery
//
//  Created by Dillan Laughlin on 1/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

extern NSString *kDocumentExtension;
extern NSString *kDocumentListChangedRemovalNotification;
extern NSString *kDocumentListRemovedIndexPathKey;
extern NSString *kDocumentListChangedAdditionNotification;
extern NSString *kDocumentListAddedIndexPathKey;

@interface BNRDocumentStorage : NSObject

+(BNRDocumentStorage *)sharedDocumentStorage;

@property (nonatomic, readonly) NSArray *documentURLs;

-(void)addDocumentURL:(NSURL *)url;
-(void)removeDocumentURL:(NSURL *)url;
-(NSURL *)addDocumentWithName:(NSString *)name;

@end
