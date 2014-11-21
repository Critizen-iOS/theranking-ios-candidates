//
//  CZCoreDataManager.m
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "CZCoreDataManager.h"

@implementation CZCoreDataManager

#pragma mark - Singleton

+ (CZCoreDataManager *) sharedSingleton
{
    static CZCoreDataManager *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSingleton = [[self alloc] initSingleton];
    });
    
    return _sharedSingleton;
}

- (CZCoreDataManager*) initSingleton
{
    self = [super init];
    if (self) {
        // Inicializaciones
    }
    return self;
}

- (id)init
{
    NSAssert(NO, @"No se pueden crear instancias adicionales de este singleton. Utiliza el método sharedSingleton.");
    return nil;
}

+ (id)new
{
    NSAssert(NO, @"No se pueden crear instancias adicionales de este singleton. Utiliza el método sharedSingleton.");
    return nil;
}

#pragma mark - CZPhoto Methods

- (CZPhoto *) createPhotoWithData:(NSDictionary *) json
{
    return [CZPhoto createPhotoWithJSONData:json
                                    context:self.context];
}

- (CZPhoto *) getPhotoFromDatabaseWithID:(NSInteger) photoID{
    
    NSFetchRequest *fetchRequest    = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity     = [NSEntityDescription entityForName:@"CZPhoto"
                                                  inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id == %d)", photoID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Houston, we have a problem: %@", error);
        return nil;
    }
    
    if (fetchedObjects.count != 0) {
        return [fetchedObjects objectAtIndex:0];
    }else{
        return nil;
    }
}

#pragma mark - CZCamera Methods

- (CZCamera *) createCameraWithData:(NSDictionary *) json
{
    return [CZCamera createCameraWithJSONData:json
                                      context:self.context];
}

#pragma mark - CZUser Methods

- (CZUser *) createUserWithData:(NSDictionary *) json
{
    return [CZUser createUserWithJSONData:json
                                  context:self.context];
}

#pragma mark - Core Data General Methods

- (void) saveContext
{
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

@end
