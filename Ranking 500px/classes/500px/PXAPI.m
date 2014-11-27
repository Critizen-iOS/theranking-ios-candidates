//
//  PXAPI.m
//  Ranking 500px
//
//  Created by Moisés Moreno on 25/11/14.
//  Copyright (c) 2014 sés. All rights reserved.
//

#import "PXAPI.h"

#import "HTTP.h"


// https:// api.500px.com/v1/photos?feature=popular&page=1&consumer_key=qKvEV1Hz5lAbylVhmBWCNLKeWSAA0LD3NQh4OMGK

//! Consumer key.
static NSString *const CONSUMER_KEY = @"qKvEV1Hz5lAbylVhmBWCNLKeWSAA0LD3NQh4OMGK";

//! 500px API base URL.
static NSString *const PXAPI_URL = @"https://api.500px.com/v1/";


#pragma mark - = PXAPI = -

@implementation PXAPI

+ (void)getPopularPhotosForPage:(NSInteger)page itemsPerPage:(NSInteger)itemsPerPage completion:(void (^)( PXPhotoPage *page ))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@photos?feature=popular&page=%d&rpp=%d&&image_size[]=2&image_size[]=4&consumer_key=%@", PXAPI_URL, page, itemsPerPage, CONSUMER_KEY];
    
    [HTTP getURL:urlString completion:^( NSData *data ) {
        if( completion ) {
            PXPhotoPage *page = nil;

            if( data ) {
                NSError *error;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                page = [[PXPhotoPage alloc] initWithJSON:json];
            }

            completion( page );
        }
    }];
}

@end
