//
//  CZCoreDataManager.h
//  CritizenTest
//
//  Created by Juan Pedro Catalán on 20/11/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CZPhoto.h"
#import "CZCamera.h"
#import "CZUser.h"

@interface CZCoreDataManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *context;

+ (CZCoreDataManager *) sharedSingleton;

// ---------------------------------------------------------
// | Core Data
// ---------------------------------------------------------
- (void) saveContext;

// ---------------------------------------------------------
// | CZPhoto
// ---------------------------------------------------------
- (CZPhoto *) createPhotoWithData:(NSDictionary *) json;
- (CZPhoto *) getPhotoFromDatabaseWithID:(NSInteger) photoID;

// ---------------------------------------------------------
// | CZCamera
// ---------------------------------------------------------
- (CZCamera *) createCameraWithData:(NSDictionary *) json;

// ---------------------------------------------------------
// | CZUser
// ---------------------------------------------------------
- (CZUser *) createUserWithData:(NSDictionary *) json;


@end
