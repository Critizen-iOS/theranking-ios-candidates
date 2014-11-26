//
//  CoreDataManager.h
//  PopularPictures
//
//  Created by Nelson on 25/11/14.
//  Copyright (c) 2014 Nelson Domínguez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoMO.h"

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(instancetype)sharedManager;

-(PhotoMO*)createPhotoManagedObjectWithDictionary:(NSDictionary*)dictionary;

-(void)saveContext;

@end
