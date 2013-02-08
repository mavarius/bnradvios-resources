//
//  BNRHotDog.m
//  DogHouse
//
//  Created by Jonathan Blocksom on 3/19/12.
//  Copyright (c) 2012 Big Nerd Ranch, Inc. All rights reserved.
//

#import "BNRHotDog.h"

@implementation BNRHotDog

- (id)init
{
    self = [super init];
    if (self) {
        _condiments = [[NSMutableArray alloc] init];
    }
    return self;
}

- (float)price
{
    if (self.kind==BNRHotDogKindRegular) return 1.0;
    if (self.kind==BNRHotDogKindJumbo) return 1.50;
    
    return 0.0;
}

- (NSString *)descriptionForOrder
{
    NSString *desc;
    if (self.kind==BNRHotDogKindRegular) desc = @"Hot Dog";
    if (self.kind==BNRHotDogKindJumbo) desc = @"Jumbo Dog";
    
    if ([self.condiments count] > 0) {
        NSString *nextDesc = [desc stringByAppendingString:@" with "];
        for (NSString *s in self.condiments) {
            desc = [nextDesc stringByAppendingString:s];
            nextDesc = [desc stringByAppendingString:@","];
        }
    }
    
    return desc;
}

@end
