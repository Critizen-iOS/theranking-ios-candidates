//
//  NSManagedObject+SafeSetValues.m
//  CritizenTestApp
//
//  Created by Patricio on 18/02/15.
//  Copyright (c) 2015 Patricio. All rights reserved.
//

#import "NSManagedObject+SafeSetValues.h"
#import "NSObject+isNull.h"

@implementation NSManagedObject (SafeSetValues)


- (BOOL)safeSetValue:(id)value forKey:(NSString *)key
{
    if ([NSObject isNull:value])
        return NO;
    
    NSDictionary *attributes = [[self entity] attributesByName];
    NSAttributeType attributeType = [[attributes objectForKey:key] attributeType];
    
    if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
        value = [value stringValue];
    } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
        value = [NSNumber numberWithInteger:[value integerValue]];
    } else if ((attributeType == NSFloatAttributeType) && ([value isKindOfClass:[NSString class]])) {
        value = [NSNumber numberWithDouble:[value doubleValue]];
    }
    [self setValue:value forKey:key];
    
    return YES;
}

- (BOOL)safeSetValue:(id)value forKey:(NSString *)key dateFormatter:(NSDateFormatter *)dateFormatter
{
    if ([NSObject isNull:value])
        return NO;
    
    NSDictionary *attributes = [[self entity] attributesByName];
    NSAttributeType attributeType = [[attributes objectForKey:key] attributeType];
    
    if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
        value = [value stringValue];
    } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
        value = [NSNumber numberWithInteger:[value integerValue]];
    } else if ((attributeType == NSFloatAttributeType) && ([value isKindOfClass:[NSString class]])) {
        value = [NSNumber numberWithDouble:[value doubleValue]];
    } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]])) {
        value = [dateFormatter dateFromString:value];
    }
    [self setValue:value forKey:key];
    
    return YES;
}

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *attribute in attributes) {
        id value = [keyedValues objectForKey:attribute];
        [self safeSetValue:value forKey:attribute];
    }
}

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter
{
    NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *attribute in attributes) {
        id value = [keyedValues objectForKey:attribute];
        [self safeSetValue:value forKey:attribute dateFormatter:dateFormatter];
    }
}

- (void)logAttributes
{
    NSEntityDescription *entity = [self entity];
    NSLog(@"--------------------------");
    NSLog(@"Entity: %@", [entity name]);
    
    NSDictionary *attributes = [entity attributesByName];
    for (NSString *attribute in attributes) {
        id value = [self valueForKey:attribute];
        NSLog(@"%@ : %@", attribute, value);
    }
}

@end
