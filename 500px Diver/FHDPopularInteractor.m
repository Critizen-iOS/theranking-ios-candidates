//
//  FHDPopularInteractor.m
//  500px Diver
//
//  Created by Jaime on 24/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import "FHDPopularInteractor.h"
#import "FHDPopularItem.h"
#import "FHDItem.h"

@implementation FHDPopularInteractor

- (void)getPopularFromPage:(NSInteger)page completionBlock:(void(^)(NSArray *items))completion
{
    [_dataManager getPopularDataForPage:page
                        completionBlock:^(NSArray *items) {
                            
                                NSMutableArray *presenterItems = [[NSMutableArray alloc] init];
                                [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                
                                    FHDItem *item = (FHDItem *)obj;
                                    FHDPopularItem *popularItem = [[FHDPopularItem alloc] init];
                                    
                                    popularItem.identifier = item.identifier;
                                    popularItem.name = item.name;
                                    popularItem.rating = item.rating;
                                    popularItem.imageUrl = item.imageUrl;
                                    
                                    [presenterItems addObject:popularItem];
                                }];
                            
                               completion (presenterItems);
                           }];
}

@end
