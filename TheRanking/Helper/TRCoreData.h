//
//  TRCoreData.h
//  TheRanking
//
//  Created by Jesús Emilio Fernández de Frutos on 25/10/14.
//  Copyright (c) 2014 Jesús Emilio Fernández de Frutos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRCoreData : NSObject<NSFetchedResultsControllerDelegate>

/**
 Fetched results controller to efficiently manage the results returned from a Core Data fetch request
 */
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsControllerPhoto;


/**
 Context to hold all interactions with the underlying database
 */
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


/**
 Get the shared instance of the TRCoreData class
 @returns the instance of TRCoreData
 */
+ (TRCoreData*)sharedInstance;

/**
 Parse JSON data and store objets into core data
 @param data data fetched
 */
- (void)parseJSONData:(NSData *)data;
@end
