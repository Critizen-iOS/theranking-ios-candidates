//
//  FHDDetailDataManager.h
//  500px Diver
//
//  Created by Jaime on 25/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FHDWebService.h"
#import "FHDPersistantStore.h"
#import "FHDItem.h"

// This class represents the Data Manager for the use case "Show item details"
// Data is actually retreived only from Core Data
@interface FHDDetailDataManager : NSObject

// Object to access to Web Service (maybe in the future, not used by now)
@property (nonatomic, strong) FHDWebService *webService;
// Object to access to Core Data
@property (nonatomic, strong) FHDPersistantStore *persistantStore;

/**
 * Gets item details from data source and passes it to the Interactor
 * @param identifier identifier for the item to get
 * @param completion block to execute when data is ready; uses an FHDItem object
 */
- (void)getDetailDataForItem:(NSNumber *)identifier completionBlock:(void(^)(FHDItem *item))completion;

@end
