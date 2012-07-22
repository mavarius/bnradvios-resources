//
//  Person.m
//  SalesReport
//
//  Created by Aaron Hillegass on 1/5/12.
//  Copyright (c) 2012 Big Nerd Ranch. All rights reserved.
//

#import "Person.h"

@implementation Person
@synthesize name, sales, photo, photoSize;

- (id)initWithImage:(UIImage *)i
{
    self = [super init];
    if (self) {
        photo = [i CGImage];
        CGImageRetain(photo);
        photoSize = [i size];
    }
    return self;
}

- (void)dealloc
{
    CGImageRelease(photo);
}

@end
