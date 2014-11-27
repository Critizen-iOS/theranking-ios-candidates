//
//  PXAPI.h
//  Ranking 500px
//
//  Created by Moisés Moreno on 25/11/14.
//  Copyright (c) 2014 sés. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PXPhotoPage.h"


#pragma mark - = PXAPI = -

@interface PXAPI: NSObject

+ (void)getPopularPhotosForPage:(NSInteger)page itemsPerPage:(NSInteger)itemsPerPage completion:(void (^)( PXPhotoPage *page ))completion;

@end
