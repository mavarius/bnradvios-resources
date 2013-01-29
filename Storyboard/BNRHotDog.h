//
//  BNRHotDog.h
//  DogHouse
//
//  Created by Jonathan Blocksom on 3/19/12.
//  Copyright (c) 2012 Big Nerd Ranch, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BNRHotDogKindRegular,
    BNRHotDogKindJumbo
} BNRHotDogKind;

@interface BNRHotDog : NSObject

@property (nonatomic) BNRHotDogKind kind;
@property (nonatomic, strong) NSMutableArray *condiments;

- (float)price;
- (NSString *)descriptionForOrder;

@end
