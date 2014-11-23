//
//  TRDataNetManager.h
//  theranking-ios-candidates.
//
//  Created by Joaquin Perez Barroso on 23/11/14.
//  Copyright (c) 2014 Joaquin Perez Barroso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TRDataNetManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+(TRDataNetManager *)sharedManager;

-(void)updatePhotosWithCompletionHandler:(void (^)(void))completionHandler;

@end
