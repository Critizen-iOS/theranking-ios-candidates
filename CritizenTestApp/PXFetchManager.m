//
//  PXFetchManager.m
//  CritizenTestApp
//
//  Created by Patricio on 18/02/15.
//  Copyright (c) 2015 Patricio. All rights reserved.
//

#import "PXFetchManager.h"
#import "PXClient.h"
#import "AppDelegate.h"
#import "NSManagedObject+SafeSetValues.h"
#import "NSObject+isNull.h"

@implementation PXFetchManager

@synthesize moc;

#pragma mark - Intialization Methods

+ (PXFetchManager *)sharedManager
{
    static PXFetchManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[PXFetchManager alloc] init];
        sharedManager.moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    });
    
    return sharedManager;
}

#pragma mark - Request to API Methods

- (void)requestPhotos:(NSString *)feature
               page:(NSNumber *)page
               sort:(NSString *)sort
      sortDirection:(NSString *)sortDirection
          imageSize:(NSNumber *)size
           callback:(void (^)(NSDictionary *dictionary, NSError *error))callbackBlock
{
    NSDictionary *params = @{@"feature" : feature,
                             @"page" : page,
                             @"sort" : sort,
                             @"sort_direction" : sortDirection,
                             @"image_size" : size};
    
    [PXClient performRequestForPath:@"/photos"
                             params:params
                    completionBlock:^(NSDictionary *dataDictionary, NSError *error) {
                        if (!error) {
                            if (callbackBlock) {
                                
                                // Returns json data
                                callbackBlock(dataDictionary, error);
                            }
                        } else {
                            if (callbackBlock) {
                                callbackBlock(nil, error);
                            }
                        }
    }];
}

- (void)requestPhotoId:(NSNumber *)photoId
             imageSize:(NSNumber *)size
         callbackBlock:(void (^)(NSDictionary *dictionary, NSError *error))callbackBlock
{
    NSDictionary *params = @{@"image_size" : size};
    
    [PXClient performRequestForPath:[NSString stringWithFormat:@"photos/%f", photoId.doubleValue]
                             params:params
                    completionBlock:^(NSDictionary *dataDictionary, NSError *error) {
                        if (!error) {
                            if (callbackBlock) {
                                
                                // Create photos in Core Data and saves context
                                [self findOrCreatePhoto:dataDictionary];
                                [self saveContextAsync];
                                
                                // Returns json data
                                callbackBlock(dataDictionary, error);
                            }
                        } else {
                            if (callbackBlock) {
                                callbackBlock(nil, error);
                            }
                        }
    }];
}

#pragma mark - Find or Create Methods

- (void)findOrCreatePhoto:(NSDictionary *)photoJSON
{
    NSDictionary *photoDictionary = [photoJSON objectForKey:@"photo"];
        
    // Fetch photo if exist otherwise it will create one with json data
    NSManagedObject *photo = [self fetchPhotoById:[photoDictionary objectForKey:@"id"]];
    if (!photo) {
        
        // Creates photo object
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:moc];
        [photo safeSetValuesForKeysWithDictionary:photoDictionary];
        
        // Cannot parse attribute "description" because it cant be set as an attribute name in NSManagedObject.
        // The reason for this is that NSManagedObject inherits "description" attribute from NSObject class.
        NSString *desc = [photoDictionary valueForKey:@"description"];
        [photo safeSetValue:desc forKey:@"photo_description"];
    }
        
    // Fetch user if exist otherwise it will create one with json data
    NSDictionary *userDictionary = [photoDictionary valueForKey:@"user"];
    NSManagedObject *user = [self fetchUserById:[userDictionary objectForKey:@"id"]];
    if (!user) {
        // Create user object
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc];
        [user safeSetValuesForKeysWithDictionary:userDictionary];
    }
        
    // Creates camera object (no unique identifier)
    NSManagedObject *camera = [NSEntityDescription insertNewObjectForEntityForName:@"Camera" inManagedObjectContext:moc];
    [camera safeSetValuesForKeysWithDictionary:photoDictionary];
        
    // Creates relationships
    if (photo && user) {
        [(Photo *)photo setUser:(User *)user];
        [(User *)user addPhotos:[NSSet setWithObject:(Photo *)photo]];
    }
    if (photo && camera) {
        [(Photo *)photo setCamera:(Camera *)camera];
        [(Camera *)camera setPhotos:[NSSet setWithObject:(Photo *)photo]];
    }
}

#pragma mark - Fetch Methods

- (Photo *)fetchPhotoById:(NSNumber *)photoId
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", photoId];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [moc executeFetchRequest:request error:&error];
    if (!fetchedObjects && error) {
        NSLog(@"PXFetchManager::No photo found by id. Error:%@", [error localizedDescription]);
        return nil;
    } else if ([fetchedObjects count] > 1) {
        NSLog(@"PXFetchManager::More than one photo found by id. Returning first matched object.");
    }
    
    return [fetchedObjects firstObject];
}

- (User *)fetchUserById:(NSNumber *)userId
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", userId];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [moc executeFetchRequest:request error:&error];
    if (!fetchedObjects && error) {
        NSLog(@"PXFetchManager::No user found by id. Error:%@", [error localizedDescription]);
        return nil;
    } else if ([fetchedObjects count] > 1) {
        NSLog(@"PXFetchManager::More than one user found by id. Returning first matched object.");
    }
    
    return [fetchedObjects firstObject];
}

#pragma mark - Managed Object Context Methods

- (void)saveContextAsync
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if (moc != nil) {
            NSError *error = nil;
            if ([moc hasChanges] && ![moc save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    });
}

@end
