//
//  JSRandomCrazyScrollView.h
//  Tiling
//
//  Created by Jonathan Saggau on 7/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAPLTapDetectingView.h"
#import "BigViewPageView.h"

//Based not-so-loosely on AAPL's TiledScrollView Example
@interface BigViewScrollView : UIScrollView <UIScrollViewDelegate, 
AAPLTapDetectingViewDelegate> {
    AAPLTapDetectingView             *contentView;
    NSMutableArray                   *sleepingTiles;
    NSMutableArray                   *wakefulTiles;
    
    CGSize                           tileSize;
    
    // we use the following ivars to keep track of which rows and columns are visible
    NSInteger firstVisibleRow, lastVisibleRow;
    NSUInteger numberOfPrerenderedOffscreenViews;
    BOOL isdblTapZooming;
    BOOL drawingSuspended;
    NSMutableArray *imagesNames;
}

//if you get a memory warning, call this to clear me out.
-(void)memoryWentboom;

-(void)resumeDrawingInTiles;
-(void)suspendDrawingInTiles;

@property (nonatomic, retain)NSMutableArray *imagesNames;
@property (nonatomic, readonly) AAPLTapDetectingView *contentView;
@property (nonatomic, assign) NSUInteger numberOfPrerenderedOffscreenViews;

- (void)reloadData;
- (void)fullReset;

- (void)addImageName:(id)anImagesName;
- (void)removeImageName:(id)anImagesName;

@end
