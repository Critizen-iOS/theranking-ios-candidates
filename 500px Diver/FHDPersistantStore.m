//
//  FHDDataStore.m
//  500px Diver
//
//  Created by Jaime on 24/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "FHDPersistantStore.h"

@interface FHDPersistantStore ()

@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation FHDPersistantStore

- (id)init
{
    if ((self = [super init]))
    {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSError *error = nil;
        NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                                       inDomains:NSUserDomainMask] lastObject];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES],
                                 NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES],
                                 NSInferMappingModelAutomaticallyOption,
                                 nil];
        NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"FHDDataModel.sqlite"];
        
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:storeURL
                                                        options:options
                                                          error:&error];
        
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
        _managedObjectContext.undoManager = nil;
    }
    
    return self;
}

- (void)fetchEntriesWithPredicate:(NSPredicate *)predicate
                  sortDescriptors:(NSArray *)sortDescriptors
                  completionBlock:(void(^)(NSArray *items))completionBlock
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [_managedObjectContext performBlock:^{
        NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:NULL];
        
        if (completionBlock)
        {
            completionBlock(results);
        }
    }];
}

- (FHDManagedItem *)newItem
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Item"
                                                         inManagedObjectContext:_managedObjectContext];
    FHDManagedItem *newEntry = (FHDManagedItem *)[[NSManagedObject alloc] initWithEntity:entityDescription
                                                          insertIntoManagedObjectContext:_managedObjectContext];
    return newEntry;
}

- (void)save
{
    [_managedObjectContext save:nil];
}

- (void)deleteAll
{
    NSFetchRequest * allFetch = [[NSFetchRequest alloc] init];
    [allFetch setEntity:[NSEntityDescription entityForName:@"Item" inManagedObjectContext:_managedObjectContext]];
    [allFetch setIncludesPropertyValues:NO]; //it only fetchs the managedObjectID
    
    NSError * error = nil;
    NSArray * items = [_managedObjectContext executeFetchRequest:allFetch error:&error];

    for (NSManagedObject * oneItem in items) {
        [_managedObjectContext deleteObject:oneItem];
    }
    
    NSError *saveError = nil;
    [_managedObjectContext save:&saveError];
}


@end
