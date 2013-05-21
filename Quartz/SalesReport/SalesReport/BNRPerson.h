//
//  BNRPerson.h
//  SalesReport
//
//  Created by Jonathan Blocksom on 4/1/13.
//  Copyright (c) 2013 Jonathan Blocksom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRPerson : NSObject

@property (copy) NSString *name;
@property NSUInteger sales;
@property (readonly) UIImage *photo;

- (id)initWithName:(NSString *)name image:(UIImage *)image;
// Initializes object with specified properties; if image
// is nil, will try to load image named same thing as name

@end
