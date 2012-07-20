//
//  BNROrder.h
//  DogHouse
//
//  Created by Jonathan Blocksom on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRHotDog;

@interface BNROrder : NSObject <UITableViewDataSource>

+ (BNROrder *)currentOrder;

- (void)addDog:(BNRHotDog *)dog;
- (void)addDrink;

- (float)totalPrice;

@end
