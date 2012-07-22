//
//  Created by Jonathan Saggau on 7/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "BigViewScrollView.h"
#import "AAPLTapDetectingView.h"
#import "BigViewPageView.h"
#import "NSArray+nonEmptyObjects.h"

#define ANNOTATE_TILES (0)
#define ZOOM_STEP (2.0)
#define RESUME_DRAWING_IN_TILES_DELAY (0.01)

//preserves aspect ratio
void shrinkOrExpandRectToFitHorizontallyInRect(CGRect *fitThisRect, const CGRect inHere)
{
    if(inHere.size.width > 0)
    {
        CGFloat multiplier = inHere.size.width/fitThisRect->size.width;
        fitThisRect->size.width *= multiplier;
        fitThisRect->size.height *= multiplier;
    }
}

@interface BigViewScrollView ()
- (void)annotateTile:(UIView *)tile;
- (CGSize)tileSizeForRect:(CGRect)aRect;
- (BigViewPageView *)tileForPage:(NSUInteger)page;
- (void)sleepTile:(BigViewPageView *)tile;
- (void)sleepAlltiles;

@end

@implementation BigViewScrollView

-(void)helperSetNumberOffscreenViews:(NSNumber *)osvNumber
{
    [self setNumberOfPrerenderedOffscreenViews:[osvNumber intValue]];
}

-(void)memoryWentboom
{
    LogMethod();
    //cache our viewing location
    CGPoint cachedContentOffset = [self contentOffset];
    CGSize cachedContentSize = [self contentSize];
    CGRect cachedViewFrame = [self.contentView frame];
    float cachedMinZoom = [self minimumZoomScale];
    float cachedMaxZoom = [self maximumZoomScale];
    float cachedZoom = [self zoomScale];
    
    //LogMethod();
    //get set to redraw only those views that are on the screen
	NSNumber *howMany = [NSNumber numberWithInt:[self numberOfPrerenderedOffscreenViews]];
    [self performSelector:@selector(helperSetNumberOffscreenViews:) withObject:howMany afterDelay:2.0];
    [self setNumberOfPrerenderedOffscreenViews:0];    
    
    //reset everything (blowing out images)
    [self fullReset];
    
    //reset location and redraw
    [[self contentView] setFrame:cachedViewFrame];
    [super setContentSize:cachedContentSize];
    [super setMaximumZoomScale:cachedMaxZoom];
    [super setMinimumZoomScale:cachedMinZoom];
    [super setZoomScale:cachedZoom];
    [super setContentOffset:cachedContentOffset animated:NO];
}

-(void)resumeDrawingInTiles
{
    drawingSuspended = NO;
    [self setNeedsLayout];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resumeDrawingInTiles) object:nil];
}

-(void)suspendDrawingInTiles
{
    drawingSuspended = YES;
    [self sleepAlltiles];
}

-(CGSize)tileSizeForRect:(CGRect)aRect;
{
    CGRect rectOut = CGRectZero;
    rectOut.size = CGSizeMake(800, 600);
    shrinkOrExpandRectToFitHorizontallyInRect(&rectOut, aRect);
    return rectOut.size;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        imagesNames = [[NSMutableArray alloc] init];
        // we need a tile container view to hold all the tiles. This is the view that is returned
        // in the -viewForZoomingInScrollView: delegate method, and it also detects taps.
        contentView = [[AAPLTapDetectingView alloc] initWithFrame:CGRectZero];
        [contentView setDelegate:self];
        [contentView setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:contentView];
        // the TiledScrollView is its own UIScrollViewDelegate, so we can handle our own zooming.
        // We need to return our tileContainerView as the view for zooming.
        [self setClearsContextBeforeDrawing:NO];
        [self setDirectionalLockEnabled:NO];
        [self setClipsToBounds:YES];
        self.numberOfPrerenderedOffscreenViews = 0;
        [super setDelegate:self];
        [self reloadData];
    }
    return self;
}

- (void)dealloc {
    [imagesNames removeAllObjects]; [imagesNames release]; imagesNames = nil;
    [sleepingTiles removeAllObjects]; [sleepingTiles release]; sleepingTiles = nil;
    [wakefulTiles removeAllObjects]; [wakefulTiles release]; wakefulTiles = nil;
    [contentView removeFromSuperview]; [contentView release]; contentView = nil;
    [super dealloc];
}

-(void)sleepAlltiles
{
    for (BigViewPageView *tile in [wakefulTiles nonEmptyObjects]) {
        NSUInteger index = [tile pageToDraw];
        [sleepingTiles replaceObjectAtIndex:index withObject:tile];
        [wakefulTiles replaceObjectAtIndex:index withObject:[NSNull null]];
        [tile setDrawingSuspended:YES];
    }
}

- (void)sleepTile:(BigViewPageView *)tile;
{
    if(!IsEmpty(tile))
    {    
        //NSLog(@"sleepTile:%d", [tile pageToDraw]);
        NSUInteger index = [tile pageToDraw];
        [tile setDrawingSuspended:YES];
        [sleepingTiles replaceObjectAtIndex:index withObject:tile];
        [wakefulTiles replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}

- (void)wakeTile:(BigViewPageView *)tile;
{
    if(!IsEmpty(tile))
    {    
        //NSLog(@"sleepTile:%d", [tile pageToDraw]);
        NSUInteger index = [tile pageToDraw];
        [tile setDrawingSuspended:NO];
        [wakefulTiles replaceObjectAtIndex:index withObject:tile];
        [sleepingTiles replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}

- (BigViewPageView *)tileForPage:(NSUInteger )pageNumber {
    NSUInteger index = pageNumber;
    BigViewPageView *tile = [sleepingTiles objectAtIndex:index];
    [sleepingTiles replaceObjectAtIndex:index withObject:[NSNull null]];
    
    if(IsEmpty(tile))
    {
        tile = [wakefulTiles objectAtIndex:index];
    }
    if(IsEmpty(tile))
    {
        
        tile = [[BigViewPageView alloc] initWithFrame:CGRectZero];
        // set the tile's frame so we insert it at the correct position
        CGSize tilesize = [self tileSizeForRect:[contentView frame]];
        CGRect frame = CGRectMake(0.0, 
                                  tilesize.height * index, 
                                  tilesize.width, tilesize.height);
        [tile setFrame:frame];
        [tile autorelease];
    }
    //if we pulled it from an array, we need to make sure it isn't released right away.
    [[tile retain] autorelease];
    NSString *imageName = [imagesNames objectAtIndex:pageNumber];
    [tile setPageToDraw:pageNumber];
    [tile setImageName:imageName];
    [wakefulTiles replaceObjectAtIndex:index withObject:tile];
    //NSLog(@"tileForPage:%d, %@", pageNumber, tile);
    
    return tile;
}

- (void)fullReset {
    //LogMethod();
    // since we may have changed resolutions, which changes our maximum and minimum zoom scales, we need to 
    // reset all those values. After calling this method, the caller should change the maximum/minimum zoom scales
    // if it wishes to permit zooming.
    
    [super setZoomScale:1.0 animated:NO];
    [super setMinimumZoomScale:1.0];
    [super setMaximumZoomScale:1.0];
    
    //figure out the overall rect of the whole document
    size_t pageNumber = [imagesNames count];
    CGSize pageSize = [self tileSizeForRect:self.bounds];
    CGSize wholeMess = pageSize;
    wholeMess.height *= pageNumber;
    CGRect tileContainerViewFrame = [contentView frame];
    tileContainerViewFrame.size = wholeMess;
    [contentView setFrame:tileContainerViewFrame];
    [self setContentSize:wholeMess];
    [sleepingTiles removeAllObjects]; [sleepingTiles release]; sleepingTiles = nil;
    [wakefulTiles removeAllObjects]; [wakefulTiles release]; wakefulTiles = nil;
    sleepingTiles = [[NSMutableArray alloc] initWithCapacity:pageNumber];
    wakefulTiles = [[NSMutableArray alloc] initWithCapacity:pageNumber];
    for (BigViewPageView *tile in [contentView subviews]) {
        [tile removeFromSuperview];
    }
    for (NSUInteger i=0; i<pageNumber; i++) {
        [sleepingTiles addObject:[NSNull null]];
        [wakefulTiles addObject:[NSNull null]];
    }
    
    [super setMinimumZoomScale:1.0];
    [super setMaximumZoomScale:6.5];
    [self reloadData];
}

- (void)reloadData {
    //LogMethod();
    // recycle all tiles so that every tile will be replaced in the next layoutSubviews
    [self sleepAlltiles];
    
    // no rows or columns are now visible; note this by making the firsts very high and the lasts very low
    firstVisibleRow  = NSIntegerMax;
    lastVisibleRow   = NSIntegerMin;
    
    [self setNeedsLayout];
    [self performSelector:@selector(resumeDrawingInTiles) withObject:nil afterDelay:RESUME_DRAWING_IN_TILES_DELAY];
}

/***********************************************************************************/
/* Most of the work of tiling is done in layoutSubviews, which we override here.   */
/* We sleep the tiles that are no longer in the visible bounds of the scrollView   */
/* and we wake any tiles that should now be awake but are sleeping.                */
/***********************************************************************************/
- (void)layoutSubviews {
    if(IsEmpty(imagesNames))
        return;
    if([self isZooming] || isdblTapZooming) //if we're zooming, defer
    {
        [self performSelector:@selector(setNeedsLayout) withObject:nil afterDelay:0.01];
        return;
    }
    //LogMethod();
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setNeedsLayout) object:nil];
    [super layoutSubviews];
    
    CGRect visibleBounds = [self bounds];
    CGSize onePageSize = [self tileSizeForRect:[contentView frame]];
    visibleBounds.size.height += onePageSize.height * numberOfPrerenderedOffscreenViews;
    visibleBounds.origin.y -= (onePageSize.height * numberOfPrerenderedOffscreenViews) * .5;
    if(visibleBounds.origin.y < 0)
        visibleBounds.origin.y = 0;
    if (visibleBounds.size.height > [contentView frame].size.height) 
        visibleBounds.size.height = [contentView frame].size.height;
    
    CGSize tilesize = [self tileSizeForRect:[contentView frame]];
    //reset rects for all tiles in content view
    for (BigViewPageView *tile in [contentView subviews]) {
        int page = [tile pageToDraw];
        // set the tile's frame so we insert it at the correct position
        CGRect frame = CGRectMake(0.0, 
                                  tilesize.height * (page), 
                                  tilesize.width, tilesize.height);
        [tile setFrame:frame];
    }
    
    // first recycle all tiles that are no longer going to be on screen
    for (BigViewPageView *tile in [wakefulTiles nonEmptyObjects]) {
        
        // We want to see if the tiles intersect our (i.e. the scrollView's) bounds, so we need to convert their
        // frames to our own coordinate system
        CGRect scaledTileFrame = [contentView convertRect:[tile frame] toView:self];
        
        // If the tile doesn't intersect, it's not visible, so we can recycle it
        if (! CGRectIntersectsRect(scaledTileFrame, visibleBounds)) {
            [self sleepTile:tile];
        }
    }
    
    // calculate which rows and columns are visible by doing a bunch of math.
    float scaledTileHeight = [self tileSizeForRect:contentView.frame].height * [self zoomScale];
    int maxRow = [imagesNames count]-1;  // this is the maximum possible row
    int firstNeededRow = MAX(0, floorf(visibleBounds.origin.y / scaledTileHeight));
    int lastNeededRow  = MIN(maxRow, floorf(CGRectGetMaxY(visibleBounds) / scaledTileHeight));
    
    // iterate through needed rows, adding any tiles (pages) that are missing
    for (int page = firstNeededRow; page <= lastNeededRow; page++) {
        BigViewPageView *tile = (BigViewPageView *)[self tileForPage:page];
        [contentView addSubview:tile];
        if(!drawingSuspended)
            [self wakeTile:tile];
        else
            [self sleepTile:tile];
        //NSLog(@"Setting up tile to draw on page %d", [tile pageToDraw]);
        // annotateTile draws green lines and tile numbers on the tiles for illustration purposes. 
#if ANNOTATE_TILES
        [self annotateTile:tile];
#endif
    }
    
    // update our record of which rows/cols are visible
    firstVisibleRow = firstNeededRow;
    lastVisibleRow  = lastNeededRow;           
}

#pragma mark UIScrollViewDelegate

- (void)updateResolution {
    //LogMethod();
    isdblTapZooming = NO;
    float zoomScale = [self zoomScale];
    
    CGSize oldContentViewSize = [contentView frame].size;    
    //zooming properly resets contentsize as it happens.
    CGSize newContentSize = [self contentSize];
    
    CGPoint newContentOffset = [self contentOffset];
    float xMult = newContentSize.width / oldContentViewSize.width;
    float yMult = newContentSize.height / oldContentViewSize.height;
    
    newContentOffset.x *= xMult;
    newContentOffset.y *= yMult;
    
    float currentMinZoom = [self minimumZoomScale];
    float currentMaxZoom = [self maximumZoomScale];
    
    float newMinZoom = currentMinZoom / zoomScale;
    float newMaxZoom = currentMaxZoom / zoomScale;
    
    //don't call our own set..zoomScale, cause they eventually call this method.  
    //Infinite recursion is uncool.  
    [super setMinimumZoomScale:1.0];
    [super setMaximumZoomScale:1.0];
    [super setZoomScale:1.0 animated:NO];
    
    [contentView setFrame:CGRectMake(0, 0, newContentSize.width, newContentSize.height)];
    [self setContentSize:newContentSize];
    [self setContentOffset:newContentOffset animated:NO];
    
    [super setMinimumZoomScale:newMinZoom];
    [super setMaximumZoomScale:newMaxZoom];
    
    // throw out all tiles so they'll reload at the new resolution
    [self reloadData];        
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView 
                       withView:(UIView *)view 
                        atScale:(float)scale {
    if(scrollView != self) {
        return;
    }
    
    // after a zoom, check to see if we should change the resolution of our tiles
    [self updateResolution];
}

// the scrollViewDidEndZooming: delegate method is only called after an *animated* zoom. We also
//need to update our resolution for non-animated zooms. So we also override the  
//setZoomScale:animated: method of UIScrollView
- (void)setZoomScale:(float)scale animated:(BOOL)animated {
    //LogMethod();
    [super setZoomScale:scale animated:animated];
    
    //the delegate callback will catch the animated case; cover the non-animated case
    if (!animated) {
        [self updateResolution];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if(scrollView != self) {
        return;
    }
    [self performSelector:@selector(resumeDrawingInTiles) withObject:nil afterDelay:RESUME_DRAWING_IN_TILES_DELAY];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{// called on start of dragging (may require some time and or distance to move)
    if(scrollView != self) {
        return;
    }
    [self suspendDrawingInTiles];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{// called on finger up if user dragged. decelerate is true if it will continue moving afterwards
    if(scrollView != self) {
        return;
    }
    if(!decelerate)
    {
        [self performSelector:@selector(resumeDrawingInTiles) withObject:nil afterDelay:RESUME_DRAWING_IN_TILES_DELAY];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
{// called on finger up as we are moving
    if(scrollView != self) {
        return;
    }
    [self performSelector:@selector(resumeDrawingInTiles) withObject:nil afterDelay:RESUME_DRAWING_IN_TILES_DELAY];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{// called when scroll view grinds to a halt
    if(scrollView != self) {
        return;
    }
    [self performSelector:@selector(resumeDrawingInTiles) withObject:nil afterDelay:RESUME_DRAWING_IN_TILES_DELAY];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
{// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
    if(scrollView != self) {
        return;
    }
    [self performSelector:@selector(resumeDrawingInTiles) withObject:nil afterDelay:RESUME_DRAWING_IN_TILES_DELAY];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;
{// return a yes if you want to scroll to the top. if not defined, assumes YES
    if(scrollView != self) {
        return YES;
    }
    BOOL outBool = YES;
    if(outBool)
    {
        [self suspendDrawingInTiles];
    }
    return outBool;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;
{// called when scrolling animation finished. may be called immediately if already at top
    if(scrollView != self) {
        return;
    }
    [self performSelector:@selector(resumeDrawingInTiles) withObject:nil afterDelay:RESUME_DRAWING_IN_TILES_DELAY];
}

#pragma mark UIScrollView overrides

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    //LogMethod();
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;  
// animate at constant velocity to new offset
{
    [super setContentOffset:contentOffset animated:animated];
}

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated;   
{
    [super scrollRectToVisible:rect animated:animated];
    if(!animated)
    {
        [self performSelector:@selector(resumeDrawingInTiles) withObject:nil afterDelay:0.2];
    }
}

-(void)setContentSize:(CGSize )asize
{
    [super setContentSize:asize];
}

-(void)setFrame:(CGRect)aFrame
{
    [super setFrame:aFrame];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if(scrollView != self) {
        return nil;
    }
    return [self contentView];
}

#pragma mark
#define LABEL_TAG 3

- (void)annotateTile:(BigViewPageView *)tile {    
    UILabel *label = (UILabel *)[tile viewWithTag:LABEL_TAG];
    if (!label) {  
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, 50)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTag:LABEL_TAG];
        [label setTextColor:[UIColor greenColor]];
        [label setShadowColor:[UIColor blackColor]];
        [label setShadowOffset:CGSizeMake(1.0, 1.0)];
        [label setFont:[UIFont boldSystemFontOfSize:40]];
        [label setText:[NSString stringWithFormat:@"%d", [tile pageToDraw]]];
        [tile addSubview:label];
        [label release];
        [[tile layer] setBorderWidth:2];
        [[tile layer] setBorderColor:[[UIColor greenColor] CGColor]];
    }
    
    [tile bringSubviewToFront:label];
}

#pragma mark zooming utility
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self frame].size.height / scale;
    zoomRect.size.width  = [self frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

#pragma mark AAPLTapDetectingViewDelegate

- (void)tapDetectingView:(AAPLTapDetectingView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint {
    // double tap zooms in or out
    float newScale = [self zoomScale] * 1.0/ZOOM_STEP;
    if ([self zoomScale] <= [self minimumZoomScale] * 1.04) {
        newScale = [self zoomScale] * ZOOM_STEP;
    }
    isdblTapZooming = YES;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [self zoomToRect:zoomRect animated:YES];
}

#pragma mark -
#pragma mark accessors

@synthesize contentView;
@synthesize numberOfPrerenderedOffscreenViews;
@synthesize imagesNames;

- (void)addImageName:(id)anImagesName
{
    [[self imagesNames] addObject:anImagesName];
    [self fullReset];
}
- (void)removeImageName:(id)anImagesName
{
    [[self imagesNames] removeObject:anImagesName];
    [self fullReset];
}

- (NSUInteger)numberOfPrerenderedOffscreenViews
{
    //NSLog(@"in -numberOfPrerenderedOffscreenViews, returned numberOfPrerenderedOffscreenViews = (null)", numberOfPrerenderedOffscreenViews);
    
    return numberOfPrerenderedOffscreenViews;
}
- (void)setNumberOfPrerenderedOffscreenViews:(NSUInteger)anumberOfPrerenderedOffscreenViews
{
    //NSLog(@"in -setnumberOfPrerenderedOffscreenViews, old value of numberOfPrerenderedOffscreenViews: %d, changed to: %d", numberOfPrerenderedOffscreenViews, anumberOfPrerenderedOffscreenViews);
    if(numberOfPrerenderedOffscreenViews != anumberOfPrerenderedOffscreenViews)
    {
        if (numberOfPrerenderedOffscreenViews < anumberOfPrerenderedOffscreenViews) {
            [self reloadData]; //probably just got a memory warning... time to clear stuff out
        }
        numberOfPrerenderedOffscreenViews = anumberOfPrerenderedOffscreenViews;
    }
}

-(CGSize) contentSize
{
    CGSize sizeThatFits = [[self contentView] frame].size;
    return sizeThatFits;
}

-(CGFloat) scrollPositionY;
{
    return self.contentOffset.y;
}

-(void) setScrollPositionY:(CGFloat )position;
{
    //LogMethod();
    CGPoint contentOffset = [self contentOffset];
    contentOffset.y = position;
    [self setContentOffset:contentOffset];
}

-(void) setScrollPositionYByPages:(NSInteger )pages;
{
    CGSize tilesize = [self tileSizeForRect:[contentView frame]];
    CGFloat onePage = tilesize.height;
    CGFloat scrollThisMuch = onePage * pages;
    CGFloat position = [self scrollPositionY];
    position += scrollThisMuch;
    [self setScrollPositionY:position];
}

-(void)scrollToPageNumber:(NSUInteger )pageNumber;
{
    CGSize tilesize = [self tileSizeForRect:[contentView frame]];
    CGFloat onePage = tilesize.height;
    CGFloat position = onePage * pageNumber;
    [self setScrollPositionY:position];
}

-(CGFloat) numberOfPagesY;
{
    CGFloat pageNumber = [imagesNames count];
    return pageNumber;
}

-(NSUInteger) currentPageY;
{
    CGRect visibleBounds = [self bounds];
    CGSize tilesize = [self tileSizeForRect:[contentView frame]];
    // calculate which rows and columns are visible by doing a bunch of math.
    float scaledTileHeight = tilesize.height * [self zoomScale];
    NSUInteger firstNeededRow = MAX(0, floorf(visibleBounds.origin.y / scaledTileHeight));
    return firstNeededRow;
}




@end
