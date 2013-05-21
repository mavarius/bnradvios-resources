//
//  BNRPerson.m
//  SalesReport
//
//  Created by Jonathan Blocksom on 4/1/13.
//  Copyright (c) 2013 Jonathan Blocksom. All rights reserved.
//

#import "BNRPerson.h"

@interface BNRPerson()

@property (strong, readwrite) UIImage *photo;
// Declaring photo property readwrite here and as
// readonly in the .h file means we can modify it
// in the implementation but a user of the class
// cannot change it.

@end

@implementation BNRPerson

- (id)initWithName:(NSString *)name image:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.name = name;
        if (image != nil) {
            self.photo = image;
        } else {
            self.photo = [UIImage imageNamed:name];
        }
    }
    return self;
}

@end
