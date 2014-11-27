//
//  PXPhotoPage.h
//  Ranking 500px
//
//  Created by Moisés Moreno on 26/11/14.
//  Copyright (c) 2014 sés. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PXPhoto.h"

#pragma mark - = PXPhotoPage = -

@interface PXPhotoPage: NSObject

#pragma mark - Creation -

/*!
 * Create a new photo page object from JSON.
 *
 * \param json JSON object.
 */
- (instancetype)initWithJSON:(NSDictionary *)json;


#pragma mark - Properties -

@property (nonatomic, readonly) NSInteger pageIndex;
@property (nonatomic, readonly) NSInteger totalPages;
@property (nonatomic, readonly) NSInteger totalItems;
@property (nonatomic, readonly) NSArray *photos;

- (PXPhoto *)photoForIndex:(NSInteger)index;

@end
