//
//  RNKDataBaseEngine.h
//  RankTest
//
//  Created by Rafael Bartolome on 26/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface RNKDataBaseEngine : NSObject

/**
 singleton pattern
 @return new RNKDataBaseEngine object
 */
+ (instancetype)sharedInstance;


/**
 Returns the NSManagedObjectContext for inserting and fetching objects into the store
 @return NSManagedObjectContext main context
 */
- (NSManagedObjectContext*) getManagedObjectContext;

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
