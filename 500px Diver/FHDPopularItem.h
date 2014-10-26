//
//  FHDPopularItem.h
//  500px Diver
//
//  Created by Jaime on 24/10/14.
//  Copyright (c) 2014 Jaime Aranaz. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class represents the model used by Presenter and View
// It contains just the information that View needs to show
@interface FHDPopularItem : NSObject

// Identifier for this item
@property (nonatomic, strong) NSNumber *identifier;
// Name for this item
@property (nonatomic, strong) NSString *name;
// Rating for this item
@property (nonatomic, strong) NSNumber *rating;
// URL for the image in this item
@property (nonatomic, strong) NSString *imageUrl;

/**
 * Creates a new item with the given data
 * @param identifier identifier for this item
 * @param name name for this item
 * @param rating rating for the item
 * @param imageUrl URL for the image in this item
 * @return a new object with the given data
 */
+ (instancetype)popularItemWithId:(NSNumber *)identifier
                             name:(NSString *)name
                           rating:(NSNumber *)rating
                         imageUrl:(NSString *)imageUrl;

@end
