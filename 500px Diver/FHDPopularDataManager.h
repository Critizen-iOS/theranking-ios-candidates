//
//  FHDPopularDataManager.h
//  500px Diver
//
//  Created by Jaime on 24/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FHDPersistantStore.h"
#import "FHDWebService.h"

// Max number of items per page
#define kItemsPerPage 20

// This class represents the Data Manager for the use case "Show popular items"
// Data can be retrieved from Web Service, of Core Data if connection is not available
@interface FHDPopularDataManager : NSObject

// Object to access to Core Data
@property (nonatomic, strong) FHDPersistantStore *persistantStore;
// Object to access Web Services
@property (nonatomic, strong) FHDWebService *webService;

/**
 * Gets popular items from data source and passes it to the Interactor
 * @param page page number to get popular items
 * @param completion block to execute when data is ready; uses an array of FHDItem objects
 */
- (void)getPopularDataForPage:(NSInteger)page completionBlock:(void(^)(NSArray *items))completion;

@end
