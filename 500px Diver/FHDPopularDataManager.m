//
//  FHDPopularDataManager.m
//  500px Diver
//
//  Created by Jaime on 24/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import "FHDPopularDataManager.h"
#import "FHDItem.h"
#import "FHDManagedItem.h"
#import "FHDDataConnectionAvailability.h"

@implementation FHDPopularDataManager

- (void)getPopularDataForPage:(NSInteger)page completionBlock:(void(^)(NSArray *items))completion
{
    if ([FHDDataConnectionAvailability isDataSourceAvailable]) {
        [self getPopularFromWebServiceForPage:page completionBlock:completion];
    } else {
        [self getPopularFromPersistanStoreForPage:page completionBlock:completion];
    }
}


// Gets data from web services
- (void)getPopularFromWebServiceForPage:(NSInteger)page completionBlock:(void(^)(NSArray *items))completion
{
    __weak FHDPopularDataManager *weakSelf = self;
    
    [_webService getPopularRequestFromPage:page
                           completionBlock:^(NSArray *items) {
                               
                               NSMutableArray *popularItems = [[NSMutableArray alloc] init];
                               if (items != nil) {
                                   [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                       FHDItem *item= [FHDItem itemWithJSON:(NSDictionary *)obj];
                                       [weakSelf addManagedItem:item];
                                       [popularItems addObject:item];
                                       NSLog(@"download %@ %@", [item name], [item rating]);
                                   }];
                                   
                                   [_persistantStore save];
                                   completion(popularItems);
                               }
                           }];
}

// Gets data from Core Data, when connection is not available
- (void)getPopularFromPersistanStoreForPage:(NSInteger)page completionBlock:(void(^)(NSArray *items))completion
{
    [_persistantStore fetchEntriesWithPredicate:nil
                                sortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"rating" ascending:NO]]
                                completionBlock:^(NSArray *items) {
                                    
                                    NSMutableArray *popularItems = [[NSMutableArray alloc] init];
                                    
                                    if (items.count != 0) {
                                        NSRange range;
                                        range.length = kItemsPerPage;
                                        range.location = (page - 1) * kItemsPerPage;
                                        items = [items subarrayWithRange:range];
                                        
                                        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                            FHDManagedItem *managedItem = (FHDManagedItem *)obj;
                                            FHDItem *item = [[FHDItem alloc] init];
                                            
                                            item.identifier = managedItem.identifier;
                                            item.name = managedItem.name;
                                            item.desc = managedItem.desc;
                                            item.imageUrl = managedItem.imageUrl;
                                            item.rating = managedItem.rating;
                                            item.camera = managedItem.camera;
                                            item.latitude = managedItem.latitude;
                                            item.longitude = managedItem.longitude;
                                            item.userName = managedItem.userName;
                                            item.userAvatarUrl = managedItem.userAvatarUrl;

                                            [popularItems addObject:item];
                                        }];
                                    }
                                    
                                    [popularItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                        FHDItem *popular = (FHDItem *)obj;
                                        NSLog(@"persistant %@ %@", popular.name, popular.rating);
                                    }];
                                    
                                    completion(popularItems);
                                }];
    
}

// Creates a Managed Objecto from an item
- (void)addManagedItem:(FHDItem *)item
{
    FHDManagedItem *managedItem = [_persistantStore newItem];

    managedItem.identifier = item.identifier;
    managedItem.name = item.name;
    managedItem.desc = item.desc;
    managedItem.imageUrl = item.imageUrl;
    managedItem.rating = item.rating;
    managedItem.camera = item.camera;
    managedItem.latitude = item.latitude;
    managedItem.longitude = item.longitude;
    managedItem.userName = item.userName;
    managedItem.userAvatarUrl = item.userAvatarUrl;
}

@end
