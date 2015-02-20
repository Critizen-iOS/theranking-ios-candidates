//
//  NSManagedObject+SafeSetValues.h
//  CritizenTestApp
//
//  Created by Patricio on 18/02/15.
//  Copyright (c) 2015 Patricio. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (SafeSetValues)

- (BOOL)safeSetValue:(id)value forKey:(NSString *)key;
- (BOOL)safeSetValue:(id)value forKey:(NSString *)key dateFormatter:(NSDateFormatter *)dateFormatter;
- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues;
- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter;
- (void)logAttributes;

@end
