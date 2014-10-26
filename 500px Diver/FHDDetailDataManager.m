//
//  FHDDetailDataManager.m
//  500px Diver
//
//  Created by Jaime on 25/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import "FHDDetailDataManager.h"
#import "FHDManagedItem.h"


@implementation FHDDetailDataManager

- (void)getDetailDataForItem:(NSNumber *)identifier completionBlock:(void(^)(FHDItem *item))completion
{
    [self getDetailFromPersistanStoreForItem:identifier completionBlock:completion];
}

- (void)getDetailFromPersistanStoreForItem:(NSNumber *)identifier completionBlock:(void(^)(FHDItem *item))completion
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(identifier == %ld)", [identifier integerValue]];
    
    [_persistantStore fetchEntriesWithPredicate:predicate
                                sortDescriptors:nil
                                completionBlock:^(NSArray *items) {
                                    
                                    FHDManagedItem *managedItem = (items.count != 0) ? [items objectAtIndex:0] : nil;
                                    FHDItem *item;
                                    if (managedItem) {
                                        item = [[FHDItem alloc] init];
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
                                    }
                                    
                                    completion(item);
                                }];
}

@end
