//
//  DetailSection.m
//  TRCodeTest
//
//  Created by Oscar Antonio Duran Grillo on 20/10/14.
//  Copyright (c) 2014 Skyweb Production. All rights reserved.
//

#import "DetailSection.h"

@implementation DetailSection

- (instancetype)initWithName:(NSString *)name items:(NSArray *)items {
    if (self = [super init]) {
        _name = name;
        _items = items;
    }
    return self;
}

@end
