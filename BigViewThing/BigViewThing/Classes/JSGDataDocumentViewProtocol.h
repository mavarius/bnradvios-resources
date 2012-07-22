/*
 *  JSGDataDocumentViewProtocol.h
 *  GdataI
 *
 *  Created by Jonathan Saggau on 7/4/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

@protocol JSGDataDocumentViewDelegate <NSObject>

@optional

//emulate web view delegate
- (void)documentViewDidScroll:(UIView *)aView;
- (BOOL)documentView:(UIView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)documentViewDidStartLoad:(UIView *)aWebView;
- (void)documentViewDidFinishLoad:(UIView *)aWebView;
- (void)documentView:(UIView *)aWebView didFailLoadWithError:(NSError *)error;

@end

@protocol JSGDataDocumentView <NSObject>

@required

@property(nonatomic, assign)id <JSGDataDocumentViewDelegate>documentViewDelegate;

#pragma mark document loading

- (NSArray *)documentDirectLoadMIMETypes;
- (NSArray *)documentFilePathLoadMIMETypes;

//mimic UIWebView loading
- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;
- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL;
- (void)stopLoading;

#pragma mark scrolling
//content must be loaded or this is meaningless.
-(CGSize)contentSize;
-(CGFloat)scrollPositionY;
-(void)setScrollPositionY:(CGFloat )position;

@optional
//These will be available if the document has discernable pages

-(void)setScrollPositionYByPages:(NSInteger )pages;
-(void)scrollToPageNumber:(NSUInteger )pageNumber;
-(CGFloat)numberOfPagesY;
-(NSUInteger)currentPageY;

@end

