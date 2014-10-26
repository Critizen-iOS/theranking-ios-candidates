//
//  FHDDataStore.h
//  500px Diver
//
//  Created by Jaime on 24/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FHDManagedItem.h"

// This class represents the main entry point to Core Data
@interface FHDPersistantStore : NSObject

/**
 * Initializes a new persistant store object
 * @return a new persistant store object ready to use
 */
- (id)init;

/**
 * Launchs a fetch request to the persistan store
 * @param predicate predicate to use in the fetch request
 * @param sortDescriptors sorting infomation
 * @param completionBlock block to execute when fetch request is finished; uses an array of Managed Objects
 */
- (void)fetchEntriesWithPredicate:(NSPredicate *)predicate
                  sortDescriptors:(NSArray *)sortDescriptors
                  completionBlock:(void(^)(NSArray *items))completionBlock;

/**
 * Creates a new Managed Object for an item
 * @return new managed object ready to use
 */
- (FHDManagedItem *)newItem;

/**
 * Saves data in persistant store
 */
- (void)save;

/**
 * Deletes all data in persistant store
 */
- (void)deleteAll;

@end
