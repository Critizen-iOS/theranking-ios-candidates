//
//  FHDPopularItem.m
//  500px Diver
//
//  Created by Jaime on 24/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import "FHDPopularItem.h"

@implementation FHDPopularItem

+ (instancetype)popularItemWithId:(NSNumber *)identifier
                             name:(NSString *)name
                           rating:(NSNumber *)rating
                         imageUrl:(NSString *)imageUrl
{
    FHDPopularItem *popularItem = [[self alloc] init];
    
    popularItem.identifier = identifier;
    popularItem.name = name;
    popularItem.rating = rating;
    popularItem.imageUrl = imageUrl;
    
    return popularItem;
}

@end
