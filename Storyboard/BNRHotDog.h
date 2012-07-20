//
//  BNRHotDog.h
//  DogHouse
//
//  Created by Jonathan Blocksom on 3/19/12.
//  Copyright (c) 2012 Big Nerd Ranch, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BNRDOG_REGULAR,
    BNRDOG_JUMBO
} BNRHotDogVariety;

@interface BNRHotDog : NSObject

@property (nonatomic) BNRHotDogVariety kind;
@property (nonatomic, strong) NSMutableArray *condiments;

- (float)price;
- (NSString *)descriptionForOrder;

@end
