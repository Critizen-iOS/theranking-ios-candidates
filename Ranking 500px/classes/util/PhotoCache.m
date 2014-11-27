//
//  PhotoCache.m
//  Ranking 500px
//
//  Created by Moisés Moreno on 26/11/14.
//  Copyright (c) 2014 sés. All rights reserved.
//

#import "PhotoCache.h"

#import "PXAPI.h"


#pragma mark - = Messages = -

NSString *const PhotoCacheItemsLoadedMessage = @"PhotoCacheItemsLoadedMessage";


#pragma mark - = PhotoCache () = -

@interface PhotoCache () {
    NSInteger maxPages;
    NSInteger itemsPerPage;
    NSMutableArray *pages;
    
    BOOL loading;
}

- (void)updateTotalItems;

@end


#pragma mark - = PhotoCache = -

@implementation PhotoCache

- (instancetype)init
{
    if( (self = [super init]) ) {
        maxPages = 4;
        itemsPerPage = 20; // 20 = default
        _totalItems = 0;
        pages = [[NSMutableArray alloc] initWithCapacity:maxPages];
        loading = NO;

        [PXAPI getPopularPhotosForPage:1 itemsPerPage:itemsPerPage completion:^( PXPhotoPage *page ) {
            [pages addObject:page];
            [self updateTotalItems];
        }];
    }

    return self;
}

#pragma mark - Cache management -

- (PXPhoto *)photoForIndex:(NSInteger)index
{
    NSInteger pageNum = index / itemsPerPage + 1;
    
    PXPhotoPage *firstPage = [pages firstObject];
    NSInteger pageIndex = pageNum - firstPage.pageIndex;
    PXPhotoPage *page = pages[pageIndex];
    NSInteger photoIndex = index - ((page.pageIndex-1) * itemsPerPage);
    PXPhoto *pxPhoto = [page photoForIndex:photoIndex];

    if( !loading ) {
        // check if we need to load previous page
        if( pageNum > 1 ) {
            // check if
            PXPhotoPage *firstPage = [pages firstObject];
            if( pageNum == firstPage.pageIndex ) {
                loading = YES;
                //NSLog( @"Loading page %d...", pageNum-1 );
                [PXAPI getPopularPhotosForPage:pageNum-1 itemsPerPage:itemsPerPage completion:^( PXPhotoPage *page ) {
                    @synchronized( self ) {
                        //NSLog( @"Page %d loaded.", page.pageIndex );
                        [pages insertObject:page atIndex:0];
                        if( pages.count > maxPages ) {
                            [pages removeLastObject];
                        }
                        
                        loading = NO;
                        [self performSelectorOnMainThread:@selector(updateTotalItems) withObject:nil waitUntilDone:NO];
                    }
                }];
            }
        }

        // check if we need to load the next page
        if( true ) {
            PXPhotoPage *lastPage = [pages lastObject];
            if( pageNum == lastPage.pageIndex ) {
                loading = YES;
                //NSLog( @"Loading page %d...", pageNum+1 );
                [PXAPI getPopularPhotosForPage:pageNum+1 itemsPerPage:itemsPerPage completion:^( PXPhotoPage *page ) {
                    @synchronized( self ) {
                        //NSLog( @"Page %d loaded.", page.pageIndex );
                        [pages addObject:page];
                        if( pages.count > maxPages ) {
                            [pages removeObjectAtIndex:0];
                        }
                        
                        loading = NO;
                        [self performSelectorOnMainThread:@selector(updateTotalItems) withObject:nil waitUntilDone:NO];
                    }
                }];
            }
        }
    }
    
    return pxPhoto;
}



#pragma mark - PhotoCache () -

- (void)updateTotalItems
{
    NSInteger aux = _totalItems;

    if( pages.count ) {
        PXPhotoPage *lastPage = [pages lastObject];
        _totalItems = lastPage.pageIndex * itemsPerPage;
    } else {
        _totalItems = 0;
    }

    if( _totalItems != aux ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PhotoCacheItemsLoadedMessage object:self];
    }
}

@end
