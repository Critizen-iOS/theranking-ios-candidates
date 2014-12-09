//
//  RNKDataBaseEngine.h
//  RankTest
//
//  Created by Rafael Bartolome on 26/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

/**
 *  Object that encapsulate all CoreData functions
 *  Works as a singleton
 */

@interface RNKDataBaseEngine : NSObject

/**
 singleton pattern
 @return new RNKDataBaseEngine object
 */
+ (instancetype)sharedInstance;


/**
 Returns the Main NSManagedObjectContext for inserting and fetching objects into the store
 @return NSManagedObjectContext main context
 */
- (NSManagedObjectContext*) getManagedObjectContext;

/**
 *  Returns a new Child context with ConcurrencyType: NSPrivateQueueConcurrencyType
 *  @return NSManagedObjectContext main context
 */
- (NSManagedObjectContext*) getChildManagedObjectContext;

/**
 Returns the NSPersistentStoreCoordinator for creating new contexts
 @return NSPersistentStoreCoordinator
 */
- (NSPersistentStoreCoordinator*) sharedPSC;

/**
 Saves context if necesary
 @param NSManagedObjectContext if nil saves default managedObjectContext
 */
- (void)saveContext: (NSManagedObjectContext*) context;

@end
