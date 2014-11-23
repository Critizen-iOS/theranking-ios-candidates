//
//  TRDataNetManager.m
//  theranking-ios-candidates.
//
//  Created by Joaquin Perez Barroso on 23/11/14.
//  Copyright (c) 2014 Joaquin Perez Barroso. All rights reserved.
//

#import "TRDataNetManager.h"

@interface TRDataNetManager ()

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSOperationQueue *opertationQueue;

@end



@implementation TRDataNetManager

+(TRDataNetManager *)sharedManager
{
    static TRDataNetManager *dataNetManager;
    if (!dataNetManager)
    {
        dataNetManager = [[TRDataNetManager alloc] init];
        dataNetManager.opertationQueue = [[NSOperationQueue alloc] init];
    }
    return dataNetManager;
}

#pragma mark - Request Operation
-(void)updatePhotosWithCompletionHandler:(void (^)(void))completionHandler
{
    
}


#pragma mark - CoreData Stack

-(NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *persCoordinator = self.persistentStoreCoordinator;
    if (persCoordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = persCoordinator;
    }
    return _managedObjectContext;
}

-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TRDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
    
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationLibraryCachesDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"TRStore.sqlite"]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption , nil];
    
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        
        abort();
    }
    return _persistentStoreCoordinator;
}


#pragma mark - Application's library directory

- (NSURL *)applicationLibraryCachesDirectory
{
    NSString *libraryPath= [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath =[libraryPath stringByAppendingPathComponent:@"Caches/"];
    
    return [NSURL fileURLWithPath:cachePath];
    
}


@end
