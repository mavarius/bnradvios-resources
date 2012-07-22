//
//  NSArray+nonEmptyObjects.m
//  BigViewThing
//
//  Created by Jonathan Saggau on 7/5/09.
//  Copyright 2009 Sounds Broken inc.. All rights reserved.
//

#import "NSArray+nonEmptyObjects.h"

@implementation NSArray (nonEmptyObjects)

-(NSArray *)nonEmptyObjects;
{
    static NSPredicate *emptyPredicate;
    if(!emptyPredicate)
    {
        emptyPredicate = [[NSPredicate predicateWithFormat:@"SELF != nil"] retain];
    }
    return [self filteredArrayUsingPredicate:emptyPredicate];
}

@end
