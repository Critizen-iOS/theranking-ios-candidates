//
//  PhotoCache.h
//  Ranking 500px
//
//  Created by Moisés Moreno on 26/11/14.
//  Copyright (c) 2014 sés. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PXPhoto.h"

#pragma mark - = Messages = -

extern NSString *const PhotoCacheItemsLoadedMessage;


#pragma mark - = PhotoCache = -

@interface PhotoCache: NSObject


#pragma mark - Properties -

@property (nonatomic, readonly) NSInteger totalItems;


#pragma mark - Cache management -

- (PXPhoto *)photoForIndex:(NSInteger)index;

@end
