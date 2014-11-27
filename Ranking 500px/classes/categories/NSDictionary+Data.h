//
//  NSDictionary+Data.h
//
//  Created by Moisés Moreno.
//

#import <Foundation/Foundation.h>

/*!
 * Helper category for dictionary.<br>
 * <br>
 * NOTE: These methods also convert 'NSNull' values to 'nil'.
 */
@interface NSDictionary (Data)

- (id)valueForKey:(id)aKey;
- (NSInteger)integerForKey:(id)aKey;
- (short)shortForKey:(id)aKey;
- (float)floatForKey:(id)aKey;
- (double)doubleForKey:(id)aKey;
- (NSInteger)boolForKey:(id)aKey;

@end
