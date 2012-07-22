//
//  Person.h
//  SalesReport
//
//  Created by Aaron Hillegass on 1/5/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface Person : NSObject
{
    CGImageRef photo;
    CGSize photoSize;
    NSUInteger sales;
    NSString *name;
}
- (id)initWithImage:(UIImage *)i;
@property (copy) NSString *name;
@property NSUInteger sales;
@property (readonly) CGSize photoSize;
@property (readonly) CGImageRef photo;

@end
