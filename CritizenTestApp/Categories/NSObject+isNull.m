//
//  NSObject+isNull.m
//  CritizenTestApp
//
//  Created by Patricio on 19/02/15.
//  Copyright (c) 2015 Patricio. All rights reserved.
//

#import "NSObject+isNull.h"

@implementation NSObject (isNull)

+ (BOOL)isNull:(NSObject *)object
{
    if (!object) {
        return YES;
    } else if (object == [NSNull null]) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        return   ([((NSString *)object) isEqualToString:@""] ||
                  [((NSString *)object) isEqualToString:@"null"] ||
                  [((NSString *)object) isEqualToString:@"<null>"]);
    }
    return NO;
}

+ (BOOL)isNotNull:(NSObject *)object
{
    return ![self isNull:object];
}

@end
