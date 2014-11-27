//
//  PXPhotoPage.m
//  Ranking 500px
//
//  Created by Moisés Moreno on 26/11/14.
//  Copyright (c) 2014 sés. All rights reserved.
//

#import "PXPhotoPage.h"

#import "NSDictionary+Data.h"


#pragma mark - = PXPhotoPage = -

@implementation PXPhotoPage

#pragma mark - Creation -

/*
 * Create a new photo page object from JSON.
 *
 * \param json JSON object.
 */
- (instancetype)initWithJSON:(NSDictionary *)json
{
    if( (self = [super init]) ) {
        _pageIndex = [json integerForKey:@"current_page"];
        _totalPages = [json integerForKey:@"total_pages"];
        _totalItems = [json integerForKey:@"total_items"];
        
        if( true ) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for( NSDictionary *jsonPhoto in [json valueForKey:@"photos"] ) {
                PXPhoto *pxPhoto = [[PXPhoto alloc] initWithJSON:jsonPhoto];
                [arr addObject:pxPhoto];
            }
            
            _photos = [[NSArray alloc] initWithArray:arr];
        }
    }

    return self;
}


#pragma mark - Properties -

- (PXPhoto *)photoForIndex:(NSInteger)index
{
    return (index < _photos.count) ? _photos[index] : nil;
}


@end
