//
//  JSRandomCrazyPageView.h
//  BigViewThing
//
//  Created by Jonathan Saggau on 7/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigViewPageView : UIView {
    NSUInteger pageToDraw;
    NSString *imageName;
    CGSize lastFrameSize;
    BOOL drawingSuspended;
    BOOL drawnPageOnce;
}

@property(nonatomic, copy)NSString *imageName;
@property(nonatomic, assign)NSUInteger pageToDraw;
@property(nonatomic, assign)BOOL drawingSuspended;

@end


