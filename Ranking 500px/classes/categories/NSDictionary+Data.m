//
//  NSDictionary+Data.m
//
//  Created by Moisés Moreno.
//

#import "NSDictionary+Data.h"

@implementation NSDictionary (Data)

- (id)valueForKey:(id)aKey
{
    id value = [self objectForKey:aKey];
    if( value == [NSNull null] ) value = nil;

    return value;
}

- (NSInteger)integerForKey:(id)aKey
{
    return [[self valueForKey:aKey] integerValue];
}

- (short)shortForKey:(id)aKey
{
    return [[self valueForKey:aKey] shortValue];
}

- (float)floatForKey:(id)aKey
{
    return [[self valueForKey:aKey] floatValue];
}

- (double)doubleForKey:(id)aKey
{
    return [[self valueForKey:aKey] doubleValue];
}

- (NSInteger)boolForKey:(id)aKey
{
    return [[self valueForKey:aKey] boolValue];
}

@end
