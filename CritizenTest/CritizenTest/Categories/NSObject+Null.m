//
//  NSObject+Null.m
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "NSObject+Null.h"

@implementation NSObject (Null)

- (BOOL) isNotNull{
    
    return (self && ![self isKindOfClass:[NSNull class]]);
}

@end
