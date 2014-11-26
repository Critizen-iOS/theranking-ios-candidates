//
//  RNKDataBaseEngine.m
//  RankTest
//
//  Created by Rafael Bartolome on 26/11/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//


#import "RNKDataBaseEngine.h"
#import "RNKConstants.h"
@import UIKit;

@interface RNKDataBaseEngine (){

    NSManagedObjectContext *_managedObjectContext;
    NSPersistentStoreCoordinator *_sharedPSC;
    int _currentOperations;
    NSManagedObjectModel *_managedObjectModel;
}

@end

@implementation RNKDataBaseEngine


+ (instancetype)sharedInstance {
    static RNKDataBaseEngine *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        _sharedInstance = [[super alloc]init];

    });

    return _sharedInstance;
}


#pragma mark - Core Data

- (void)saveContext: (NSManagedObjectContext*) context {
    //DLog();
    NSError *error = nil;

    if (!context) {
        context = _managedObjectContext;
    }

    if ([context isEqual: _managedObjectContext]) {
        //DLog(@"Saving main context.");
    }

    if (context != nil) {
        if ([context hasChanges]){
            if (![context save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                ELog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            [context processPendingChanges];
            //DLog(@" Context saved! %@", context);
        } else {
            //DLog(@" No changes in context to save");
        }
    } else {
        //DLog(@" No context to save");
    }

}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *) getManagedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }


    NSPersistentStoreCoordinator *coordinator = self.sharedPSC;
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }

    //Observer for changes in other contexts
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mergeChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:nil];

    //DLog(@"%@", _managedObjectContext);
    return _managedObjectContext;
}



// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)createManagedObjectModel {
    //DLog();

    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }

    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];

    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *) sharedPSC{

    if (_sharedPSC != nil) {
        return _sharedPSC;
    }


    NSPersistentStoreCoordinator *persistentStoreCoordinator = nil;

    NSManagedObjectModel *managedObjectModel = [self createManagedObjectModel];

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Pushed.sqlite"];

    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // TODO:  handle the error appropriately.
        ALog(@"Critical error\nIncompatible DataBase\nReinstall App\n%@", error);
        [self performSelector:@selector(abort) withObject: nil afterDelay:5];
    }
    //DLog(@" only one time");
    _sharedPSC = persistentStoreCoordinator;

    return _sharedPSC;
}

- (void) abort{
    //Critical error
    abort();
}

// Returns the URL to the application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



#pragma mark SaveNotifications

// this is called via observing "NSManagedObjectContextDidSaveNotification" 
- (void)mergeChanges:(NSNotification *)notification {
    //DLog(@"received NSManagedObjectContextDidSaveNotification");
    if (notification.object != _managedObjectContext) {
        [self performSelectorOnMainThread:@selector(updateMainContext:) withObject:notification waitUntilDone:NO];
    }
}

// merge changes to main context,fetchedRequestController will automatically monitor the changes and update tableview.
- (void)updateMainContext:(NSNotification *)notification {
    //DLog();
    assert([NSThread isMainThread]);
    [_managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
}


- (void)dealloc {
    // we are no longer interested in these notifications:
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSManagedObjectContextDidSaveNotification
                                                  object:nil];
}




@end
