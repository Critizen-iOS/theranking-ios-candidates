//
//  CoreDataManager.m
//  PopularPictures
//
//  Created by Nelson on 25/11/14.
//  Copyright (c) 2014 Nelson Domínguez. All rights reserved.
//

#import "CoreDataManager.h"

#define SET_IF_NOT_NULL(TARGET, VAL) if(VAL != [NSNull null]) { TARGET = VAL; }

@implementation CoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+(instancetype)sharedManager
{
    static CoreDataManager *_sharedManager = nil;
    static dispatch_once_t dispatchOnce;
    
    dispatch_once(&dispatchOnce, ^{
        _sharedManager = [[CoreDataManager alloc] init];
    });
    
    return _sharedManager;
}

-(PhotoMO*)findPhotoManagedObjectWithResourceId:(NSInteger)resourceId
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"photoId = %@", @(resourceId)];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass([PhotoMO class]) inManagedObjectContext:self.managedObjectContext];
    request.predicate = predicate;
    
    NSArray *photos = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    return photos.firstObject;
}

-(PhotoMO*)createPhotoManagedObjectWithDictionary:(NSDictionary*)dictionary
{
    NSInteger resourceId = [[dictionary valueForKey:@"id"] integerValue];
    float rating = [[dictionary valueForKey:@"rating"] floatValue];
    
    PhotoMO *photo = [self findPhotoManagedObjectWithResourceId:resourceId];
    if (photo == nil) {
        
        photo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([PhotoMO class]) inManagedObjectContext:self.managedObjectContext];
        
        photo.photoId = @(resourceId);
        
        id name = [dictionary valueForKey:@"name"];
        if (name != [NSNull null]) {
            photo.name = name;
        }
        
        id desc = [dictionary valueForKey:@"description"];
        if (desc != [NSNull null]) {
            photo.desc = desc;
        }
        
        id latitude = [dictionary valueForKey:@"latitude"];
        if (latitude != [NSNull null]) {
            photo.latitude = @([latitude doubleValue]);
        }
        
        id longitude = [dictionary valueForKey:@"longitude"];
        if (longitude != [NSNull null]) {
            photo.longitude = @([longitude doubleValue]);
        }
        
        id aperture = [dictionary valueForKey:@"aperture"];
        if (aperture != [NSNull null]) {
            photo.aperture = @([aperture floatValue]);
        }
        
        id camera = [dictionary valueForKey:@"camera"];
        if (camera != [NSNull null]) {
            photo.camera = camera;
        }
        
        id userName = [dictionary valueForKeyPath:@"user.fullname"];
        if (userName != [NSNull null]) {
            photo.userName = userName;
        }
        
        id userImageUrl = [dictionary valueForKeyPath:@"user.userpic_url"];
        if (userImageUrl != [NSNull null]) {
            photo.userImageUrl = userImageUrl;
        }
        
        photo.imageUrl = [dictionary valueForKey:@"image_url"];
    }
    
    photo.rating = [NSNumber numberWithFloat:rating];
    
    return photo;
}

#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PopularPictures" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PopularPictures.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
     
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
